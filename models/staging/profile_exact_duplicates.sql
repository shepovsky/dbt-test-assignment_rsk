{{ config(materialized='table') }}

with source_data as (

    select *
    from {{ source('raw', 'consolidated_transactions') }}

)

select
    count(*) as total_rows,
    count(distinct "Transaction ID") as distinct_transaction_ids,
    (select count(*) from (
        select distinct *
        from source_data
    ) distinct_rows) as distinct_full_rows

from source_data