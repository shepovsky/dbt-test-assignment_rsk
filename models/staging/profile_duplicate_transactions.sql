-- TEMPORARY DIAGNOSTIC MODEL
-- Compare repeated transaction IDs before deciding how to deduplicate.

{{ config(materialized='table') }}

select
    cast("Transaction ID" as integer) as transaction_id,
    count(*) as row_count,

    count(distinct "Product index") as product_count,
    count(distinct "Store ID") as store_count,
    count(distinct "Transaction Date") as transaction_date_count,
    count(distinct quantity) as quantity_count,
    count(distinct unit_price) as unit_price_count,

    count(distinct unit_cost) as unit_cost_count,
    count(distinct standard_unit_cost) as standard_cost_count,
    count(distinct landed_unit_cost) as landed_cost_count,
    count(distinct pack_size) as pack_size_count,

    count(distinct source_system) as source_system_count,
    count(distinct ingested_at) as ingestion_timestamp_count,

    min(try_cast(ingested_at as timestamp)) as first_ingested_at,
    max(try_cast(ingested_at as timestamp)) as last_ingested_at

from {{ source('raw', 'consolidated_transactions') }}
group by "Transaction ID"
having count(*) > 1