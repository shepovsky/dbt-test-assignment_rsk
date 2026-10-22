
{{ config(materialized='table') }}

with source_data as (

    select *
    from {{ source('raw', 'consolidated_transactions') }}

),

repeated_ids as (

    select "Transaction ID"
    from source_data
    group by "Transaction ID"
    having count(*) > 1

),

repeated_records as (

    select s.*
    from source_data s
    inner join repeated_ids r
        on s."Transaction ID" = r."Transaction ID"

),

field_differences as (

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
            as transaction_product_name_variants,

        count(distinct product_name_catalog)
            + case when count(product_name_catalog) < count(*) then 1 else 0 end
            as catalog_product_name_variants,

        count(distinct product_category)
            + case when count(product_category) < count(*) then 1 else 0 end
            as product_category_variants,

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

    from repeated_records
    group by "Transaction ID"

)

select
    count(*) as repeated_transaction_ids,

    countif(transaction_date_variants > 1) as ids_with_date_differences,
    countif(quantity_variants > 1) as ids_with_quantity_differences,
    countif(unit_price_variants > 1) as ids_with_price_differences,
    countif(unit_cost_variants > 1) as ids_with_unit_cost_differences,
    countif(standard_unit_cost_variants > 1) as ids_with_standard_cost_differences,
    countif(landed_unit_cost_variants > 1) as ids_with_landed_cost_differences,
    countif(pack_size_variants > 1) as ids_with_pack_size_differences,
    countif(product_id_variants > 1) as ids_with_product_id_differences,
    countif(transaction_product_name_variants > 1) as ids_with_transaction_name_differences,
    countif(catalog_product_name_variants > 1) as ids_with_catalog_name_differences,
    countif(product_category_variants > 1) as ids_with_category_differences,
    countif(store_id_variants > 1) as ids_with_store_id_differences,
    countif(store_name_variants > 1) as ids_with_store_name_differences,
    countif(state_code_variants > 1) as ids_with_state_differences,
    countif(region_variants > 1) as ids_with_region_differences,
    countif(source_system_variants > 1) as ids_with_source_system_differences,
    countif(ingested_at_variants > 1) as ids_with_ingestion_timestamp_differences

from field_differences
