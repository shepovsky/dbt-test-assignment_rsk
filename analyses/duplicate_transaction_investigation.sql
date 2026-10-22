with transaction_stats as (

    select
        transaction_id,
        count(*) as row_count,
        count(distinct product_id) as product_count,
        count(distinct store_id) as store_count,
        count(distinct transaction_month) as date_count,
        count(distinct quantity) as quantity_count,
        count(distinct unit_price) as price_count
    from {{ ref('stg_consolidated_transactions') }}
    group by transaction_id

)

select *
from transaction_stats
where row_count > 1
order by row_count desc, transaction_id