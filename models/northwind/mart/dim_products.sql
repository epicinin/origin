{{ config(materialized='table') }}

with
    stg_products as (
        select *
        from {{ ref('stg_public_products')}}
    )
    , stg_categories as (
        select *
        from {{ ref('stg_public_categories')}}
    )
    , stg_suppliers as (
        select *
        from {{ ref('stg_public_suppliers')}}
    )
    , transformed as (
        select 
            row_number() over (order by product_id) as product_sk -- auto-incremental surrogate key
            ,stg_products.product_id
            ,stg_products.product_name
            ,stg_products.supplier_id
            ,stg_products.category_id
            ,stg_products.quantity_per_unit
            ,stg_products.unit_price
            ,stg_products.units_in_stock
            ,stg_products.units_on_order
            ,stg_products.reorder_level
            ,stg_products.discontinued
            ,stg_categories.category_name
            ,stg_suppliers.company_name
            ,stg_suppliers.country
            from stg_products
            left join stg_categories on stg_products.category_id = stg_categories.category_id
            left join stg_suppliers on stg_products.supplier_id = stg_suppliers.supplier_id
    )
select * from transformed