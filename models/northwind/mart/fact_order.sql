{{ config(materialized='table') }}

with
    customers as (
        select 
            customer_sk
            , customer_id
            from {{ref('dim_customers')}} 
    )
    , orders_with_sk as (
        select 
        orders.order_id
        , customers.customer_id
        , orders.ship_name
        , orders.order_date
        , orders.ship_region
        , orders.shipped_date
        , orders.ship_country        
        , orders.ship_postal_code
        , orders.ship_city
        , orders.freight
        , orders.ship_address
        , orders.required_date
        from {{ref('stg_public_orders')}} orders
            left join customers on orders.customer_id = customers.customer_id
    )
    select * from orders_with_sk