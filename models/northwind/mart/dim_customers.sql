{{ config(materialized='table') }}

with
    staging as (
        select *
        from {{ ref('stg_public_customers')}}
    )
    , transformed as (
        select 
            row_number() over (order by customer_id) as customer_sk -- auto-incremental surrogate key
            , customer_id
            , country
            , city
            , fax
            , postal_code
            , address
            , region
            , phone
            , contact_name
            , company_name
            , contact_title
            from staging
    )
select * from transformed