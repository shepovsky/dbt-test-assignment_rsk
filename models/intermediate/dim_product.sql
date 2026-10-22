
with products as (

    select
        product_id,
        product_name_on_transaction,
        product_name_catalog,
        product_category
    from {{ ref('stg_consolidated_transactions') }}
    where product_id is not null

),

ranked as (

    select
        product_id,
        product_name_on_transaction,
        product_name_catalog,
        product_category,

        row_number() over (
            partition by product_id
            order by
                product_name_catalog nulls last,
                product_name_on_transaction nulls last,
                product_category nulls last
        ) as row_num

    from products

)

select
    product_id,
    coalesce(
        product_name_catalog,
        product_name_on_transaction,
        'Unknown product'
    ) as product_name,
    product_category

from ranked
where row_num = 1
