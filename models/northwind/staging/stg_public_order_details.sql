with 
    source_data as (
        select
        order_id
        ,product_id
        ,unit_price
        ,quantity
        ,discount
    from {{source('northwind_dataset','public_order_details')}}
    )
select * from source_data