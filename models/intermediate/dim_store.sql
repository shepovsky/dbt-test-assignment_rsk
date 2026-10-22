
with stores as (

    select
        store_id,
        store_name,
        state_code,
        region_name
    from {{ ref('stg_consolidated_transactions') }}
    where store_id is not null

),

ranked as (

    select
        store_id,
        store_name,
        state_code,
        region_name,

        row_number() over (
            partition by store_id
            order by
                region_name nulls last,
                state_code nulls last,
                store_name nulls last
        ) as row_num

    from stores

)

select
    store_id,
    store_name,
    state_code,
    region_name

from ranked
where row_num = 1
