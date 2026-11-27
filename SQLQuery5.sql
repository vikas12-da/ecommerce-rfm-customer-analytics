create database ecommerceanalytics;
-- check row count after import 
select count(*) as rows_2009_2010 from dbo.[year 2009-2010];
select count(*) as rows_2010_2011 from dbo.[year 2010-2011];

--combine both years and convert types safely 
select 
invoice,stockcode,description,quantity,

coalesce(
   TRY_CONVERT(datetime2,invoicedate,120),
   try_convert(datetime2,invoicedate,105)
   ) as invoicedate,

   TRY_CONVERT(decimal(10,2),price)as price,
   customer_id,country,'2009-2010' as sourcesheet
into dbo.retailcombined
from dbo.[year 2009-2010]

union all

select 
invoice,stockcode,description,quantity,
coalesce(
   TRY_CONVERT(datetime2,invoicedate,120),
   try_convert(datetime2,invoicedate,105)
) as invoicedate,

try_convert(decimal(10,2),price) as price,
customer_id,country,'2010-2011' as sourcesheet
from dbo.[year 2010-2011]

--confirm the conversion worked cleanly
select count(*) as total_rows from dbo.retailcombined;
select count(*) as failed_dates from dbo.retailcombined where invoicedate is null;
select count(*) as failed_prices from dbo.retailcombined where price is null;

--check 1- missing customer id 
select count(*) as missing_customerid from dbo.retailcombined where customer_id is null;

-- check 2- negative or zero quantity 
select count(*) as negative_qty
from dbo.retailcombined where Quantity<=0;

--check 3- missing decription 
select count(*) as missing_description 
from dbo.retailcombined where Description is null;

--check 4- exact duplicate rows 
select invoice,stockcode, description, quantity, invoicedate, price,customer_id,country,
 count(*) as exactduplicatecount
 from dbo.retailcombined
 group by Invoice,StockCode,Description,Quantity,invoicedate,price,Customer_ID,Country
 having count(*)>1;

 -- duplicate and produce the final cleaned tables 
 with deduped as (
       select*,
       row_number() over(
       partition by invoice,stockcode,description,quantity,invoicedate,price,customer_id,country
       order by (select null)
       )as rownum
       from dbo.retailcombined
       )
       select invoice,stockcode,description,quantity,invoicedate,price,Customer_ID,country,sourcesheet
       into dbo.retailcleaned
       from deduped 
       where rownum=1;

select * from dbo.retailcleaned;