{{ config(materialized='table') }}

with
    customers as (
        select 
            customer_sk
            , customer_id
            from {{ref('dim_customers')}} 
    )
    , employee as (
         select 
            employee_sk
            , employee_id
            from {{ref('dim_employees')}}
    )
    , shipper as (
         select 
            shipper_sk
            , shipper_id
            from {{ref('dim_shippers')}}
    )
    , orders_with_sk as (
        select 
        orders.order_id
        , customers.customer_id
        , orders.employee_id
        , shipper.shipper_id
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
            left join employee on orders.employee_id = employee.employee_id
            left join shipper on orders.ship_via = shipper.shipper_id
    )
    select * from orders_with_sk