{{ config(materialized='table') }}

with source_data as (
    select *
    from {{ source('raw', 'consolidated_transactions') }}
),

per_transaction as (
    select
        "Transaction ID",
        count(*) as row_count,

        count(distinct "Transaction Date")
          + case when count("Transaction Date") < count(*) then 1 else 0 end
          as transaction_date_variants,

        count(distinct quantity)
          + case when count(quantity) < count(*) then 1 else 0 end
          as quantity_variants,

        count(distinct unit_price)
          + case when count(unit_price) < count(*) then 1 else 0 end
          as unit_price_variants,

        count(distinct unit_cost)
          + case when count(unit_cost) < count(*) then 1 else 0 end
          as unit_cost_variants,

        count(distinct standard_unit_cost)
          + case when count(standard_unit_cost) < count(*) then 1 else 0 end
          as standard_unit_cost_variants,

        count(distinct landed_unit_cost)
          + case when count(landed_unit_cost) < count(*) then 1 else 0 end
          as landed_unit_cost_variants,

        count(distinct pack_size)
          + case when count(pack_size) < count(*) then 1 else 0 end
          as pack_size_variants,

        count(distinct "Product index")
          + case when count("Product index") < count(*) then 1 else 0 end
          as product_id_variants,

        count(distinct "Product Name")
          + case when count("Product Name") < count(*) then 1 else 0 end
          as product_name_variants,

        count(distinct product_name_catalog)
          + case when count(product_name_catalog) < count(*) then 1 else 0 end
          as catalog_name_variants,

        count(distinct product_category)
          + case when count(product_category) < count(*) then 1 else 0 end
          as category_variants,

        count(distinct "Store ID")
          + case when count("Store ID") < count(*) then 1 else 0 end
          as store_id_variants,

        count(distinct store_name)
          + case when count(store_name) < count(*) then 1 else 0 end
          as store_name_variants,

        count(distinct state_code)
          + case when count(state_code) < count(*) then 1 else 0 end
          as state_code_variants,

        count(distinct region_name)
          + case when count(region_name) < count(*) then 1 else 0 end
          as region_variants,

        count(distinct source_system)
          + case when count(source_system) < count(*) then 1 else 0 end
          as source_system_variants,

        count(distinct ingested_at)
          + case when count(ingested_at) < count(*) then 1 else 0 end
          as ingested_at_variants

    from source_data
    group by "Transaction ID"
    having count(*) > 1
),

field_counts as (
    select
        count(*) as repeated_transaction_ids,
        countif(transaction_date_variants > 1) as transaction_date,
        countif(quantity_variants > 1) as quantity,
        countif(unit_price_variants > 1) as unit_price,
        countif(unit_cost_variants > 1) as unit_cost,
        countif(standard_unit_cost_variants > 1) as standard_unit_cost,
        countif(landed_unit_cost_variants > 1) as landed_unit_cost,
        countif(pack_size_variants > 1) as pack_size,
        countif(product_id_variants > 1) as product_id,
        countif(product_name_variants > 1) as product_name,
        countif(catalog_name_variants > 1) as catalog_name,
        countif(category_variants > 1) as product_category,
        countif(store_id_variants > 1) as store_id,
        countif(store_name_variants > 1) as store_name,
        countif(state_code_variants > 1) as state_code,
        countif(region_variants > 1) as region_name,
        countif(source_system_variants > 1) as source_system,
        countif(ingested_at_variants > 1) as ingested_at
    from per_transaction
)

select 'transaction_date' as field_name, transaction_date as differing_ids
from field_counts
union all
select 'quantity', quantity from field_counts
union all
select 'unit_price', unit_price from field_counts
union all
select 'unit_cost', unit_cost from field_counts
union all
select 'standard_unit_cost', standard_unit_cost from field_counts
union all
select 'landed_unit_cost', landed_unit_cost from field_counts
union all
select 'pack_size', pack_size from field_counts
union all
select 'product_id', product_id from field_counts
union all
select 'product_name', product_name from field_counts
union all
select 'catalog_name', catalog_name from field_counts
union all
select 'product_category', product_category from field_counts
union all
select 'store_id', store_id from field_counts
union all
select 'store_name', store_name from field_counts
union all
select 'state_code', state_code from field_counts
union all
select 'region_name', region_name from field_counts
union all
select 'source_system', source_system from field_counts
union all
select 'ingested_at', ingested_at from field_counts
union all
select 'TOTAL_REPEATED_IDS', repeated_transaction_ids from field_counts
order by field_name