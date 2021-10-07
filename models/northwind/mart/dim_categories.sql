{{ config(materialized='table') }}

with
    staging as (
        select *
        from {{ ref('stg_public_categories')}}
    )
    , transformed as (
        select 
            row_number() over (order by category_id) as category_sk -- auto-incremental surrogate key
            ,category_id
            ,category_name
            ,description
            ,picture
            from staging
    )
select * from transformed