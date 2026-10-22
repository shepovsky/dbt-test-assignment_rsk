{{ config(materialized='table') }}

select
    count(*) as row_count,
    count(distinct transaction_id) as distinct_transaction_ids,
    sum(case when quantity < 0 then 1 else 0 end) as negative_quantity_rows
from {{ ref('stg_consolidated_transactions') }}