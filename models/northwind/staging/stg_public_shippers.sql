with source_data as (
    select
        shipper_id
        ,company_name
        ,phone
    from {{source('northwind_dataset','public_shippers')}} 
)
select * from source_data