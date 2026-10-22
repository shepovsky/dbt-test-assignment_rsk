with source_rows as (

    select
        *,
        row_number() over (
            order by
                transaction_id,
                transaction_month,
                product_id,
                store_id,
                quantity,
                unit_price,
                unit_cost,
                standard_unit_cost,
                landed_unit_cost,
                pack_size,
                source_system,
                ingested_at
        ) as source_row_number

    from {{ ref('stg_consolidated_transactions') }}

)

select
    source_row_number as sales_row_id,
    transaction_id,
    transaction_month,
    product_id,
    store_id,
    quantity,
    unit_price,
    unit_cost,
    standard_unit_cost,
    landed_unit_cost,
    pack_size,

    quantity * unit_price as gross_sales_amount,

    source_system,
    ingested_at

from source_rows