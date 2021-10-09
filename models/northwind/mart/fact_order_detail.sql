{{ config(materialized='table') }}

with
    product as (
        select 
            product_sk
            , product_id
            , product_name
            , supplier_id
            , category_id
            , quantity_per_unit
            , unit_price
            , units_in_stock
            , units_on_order
            , reorder_level
            , discontinued
            , category_name
            , company_name
            , country
            from {{ref('dim_products')}} 
    )
    , order_detail_sk as (
        select 
            row_number() over (order by order_id) as order_detail_sk -- auto-incremental surrogate key        
            , order_id
            , order_detail.unit_price as order_unit_price
            , order_detail.quantity
            , order_detail.discount
            , product.product_id
            , product.product_name
            , product.supplier_id
            , product.category_id
            , product.quantity_per_unit
            , product.unit_price
            , product.units_in_stock
            , product.units_on_order
            , product.reorder_level
            , product.discontinued
            , product.category_name
            , product.company_name
            , product.country
        from {{ref('stg_public_order_details')}} order_detail
            left join product on order_detail.product_id = product.product_id
    )
    select * from order_detail_sk