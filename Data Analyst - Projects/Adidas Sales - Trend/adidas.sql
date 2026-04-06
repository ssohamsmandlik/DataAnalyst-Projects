DROP TABLE if exists adidas;
Create table adidas
(
  Retailer VARCHAR(25),
  Retailer_id INT,
  Invoice_date DATE,
  Region VARCHAR(40),
  state VARCHAR(30),
  city VARCHAR(35),
  product VARCHAR(80),
  price DECIMAL(10,2),
  Units_sold DECIMAL(10,2),
  Total_sales DECIMAL(10,2),
  Operating_profit DECIMAL(10,2),
  Operating_margin_in_percent INT,
  sales_method VARCHAR(40)
)

--EDA

 select * from adidas

select *,count(*)
 from adidas
   group by 
  Retailer,
  Retailer_id ,
  Invoice_date ,
  Region ,
  state ,
  city ,
  product ,
  price ,
  Units_sold ,
  Total_sales,
  Operating_profit ,
  Operating_margin_in_percent ,
  sales_method 
  having count(*)>1

select retailer_id 
 from adidas
   where
     retailer_id is null

select invoice_date
 from adidas
   where
     invoice_date is null

select distinct product from adidas

select distinct state from adidas

select max(price) from adidas
select min(price) from adidas
select avg(price) from adidas
SELECT MODE() WITHIN GROUP (ORDER BY price) from adidas

select max(units_sold) from adidas
select min(units_sold) from adidas
select avg(units_sold) from adidas
SELECT MODE() WITHIN GROUP (ORDER BY units_sold) from adidas

select * 
 from adidas 
 where
   units_sold=0.00

select max(total_sales) from adidas
select min(total_sales) from adidas
select avg(total_sales) from adidas
SELECT MODE() WITHIN GROUP (ORDER BY total_sales) from adidas

select max(operating_profit) from adidas
select min(operating_profit) from adidas
select avg(operating_profit) from adidas
SELECT MODE() WITHIN GROUP (ORDER BY operating_profit) from adidas   

select max(operating_margin_in_percent) from adidas
select min(operating_margin_in_percent) from adidas
select avg(operating_margin_in_percent) from adidas
SELECT MODE() WITHIN GROUP (ORDER BY operating_margin_in_percent) from adidas 

select distinct sales_method from adidas

select 
 extract(year from invoice_date) as year,
 count(*)
from adidas
group by 1

--

--BUSINESS INSIGHTS

--1.Total Sales
select 
  round(sum(total_sales)/1000000,2) || 'M' as Total_sales 
from adidas

--2.YTD Sales Growth
select
  round(
  sum(total_sales)/1000000.0,2) || 'M' as ytd_sales_2020
from adidas
  where 
     invoice_date>='2020-01-01'
	 and
	 invoice_date<=(
        select
		  max(invoice_date)
        from adidas
		where extract(year from invoice_date)='2020'
	 )
  
 select
  round(
  sum(total_sales)/1000000.0,2) || 'M' as ytd_sales_2021
from adidas
  where 
     invoice_date>='2021-01-01'
	 and
	 invoice_date<=(
        select
		  max(invoice_date)
        from adidas
		where extract(year from invoice_date)='2021'
	 ) 


--2.YTD Products sold
select 
  round
  (sum(units_sold)/1000000.0,2)||'M' as ytd_products_sold_2020
from adidas
  where 
     invoice_date>='2020-01-01'
	 and
	  invoice_date<=(
	  select 
	     max(invoice_date)
	  from adidas
	  where extract(year from invoice_date)='2020')

select 
  round
  (sum(units_sold)/1000000.0,2)||'M' as ytd_products_sold_2020
from adidas
  where 
     invoice_date>='2021-01-01'
	 and
	  invoice_date<=(
	  select 
	     max(invoice_date)
	  from adidas
	  where extract(year from invoice_date)='2021')


--3.YOY Growth Percentage by Sales
with sales 
as
( select
  extract(year from invoice_date) as year,
  round(sum(total_sales)/1000000.0,2) as total_revenue 
 from adidas
 group by 1
 order by 2
)
   select
      year,
	  total_revenue,
	  lag(total_revenue) over(order by year) as previous_year_sales,
	  round(
	  100*(total_revenue-lag(total_revenue) over(order by year))/ lag(total_revenue) over(order by year),2)||'%' as pct
   from sales


--4.YOY Growth Percentage by Product sold
with products
as
( select
   extract(year from invoice_date) as year,
  sum(units_sold) as Products_sold
 from adidas
 group by 1
 order by 2
)
   select
     year,
	 Products_sold,
	 lag(Products_sold) over (order by year) as previous_year_products_sold,
	 round(
	 100*(Products_sold-lag(Products_sold) over (order by year))/lag(Products_sold) over (order by year),2)||'%' as pct
	from products


--5.Monthly Sales Trend
select
  extract(year from invoice_date) as year,
  extract(month from invoice_date) as month,
  round(sum(total_sales)/1000000.0,2)||'M' as total_revenue
from adidas
group by 2,1
order by 2,1


--6.What is total products sold per month?
select
  extract(year from invoice_date) as year,
  extract(month from invoice_date) as month,
  round(sum(units_sold)/1000000.0,2) as total_products_sold
from adidas
group by 2,1
order by 2,1


--7.MOM Growth Percentage by Sales
with monthly_sales
as
(
select
 extract(year from invoice_date) as year,
 extract(month from invoice_date) as month,
 round(sum(total_sales)/1000000.0,2) as total_revenue
from adidas
group by 1,2
)
   select 
      year,
	  month,
	  total_revenue,
	  lag(total_revenue) over (order by year,month) as prev_month_sales,
	  round(
	  100*(total_revenue-lag(total_revenue) over (order by year,month))/ lag(total_revenue) over (order by year,month),2) as pct
	from monthly_sales
	order by year,month


--8.What % of total revenue comes from each retailer?
 with sales
 as
 (
 select
   retailer,
   
   sum(total_sales) as total_revenue
 from adidas
 group by 1
 )
   select 
     retailer,
	 total_revenue,
	 round(total_revenue*100/sum(total_revenue) over(),2) as pct_of_total_revenue
   from sales
   group by 1,2
   order by 3 desc


--9.Retailer revenue by sales method.
with revenue
as
(
 select 
   retailer,
   sales_method,
    sum(total_sales) as total_revenue
 from adidas
group by 1,2
 )
    select
	  retailer,
	  sales_method,
	  round(total_revenue*100/sum(total_revenue)over(),2) as pct
	  from revenue
	order by 3,1
	

--10.Growth rate of units sold per retailer (YoY).
with cte 
as
(
select 
  extract(year from invoice_date) as year,
  retailer,
  sum(units_sold) as total_units_sold
from adidas
group by 1,2
)
   select 
     year,
	 retailer,
	 total_units_sold,
	 lag(total_units_sold) over(partition by retailer order by year) as previous_year_units_sold,
	 100*(total_units_sold- lag(total_units_sold) over(partition by retailer order by year))/
	       lag(total_units_sold) over(partition by retailer order by year) as growth_rate
   from cte
   order by 2,1


--11.Retailer revenue comparison across states.
with states
as
(
select
  retailer,
  state,
  sum(total_sales) as total_revenue
from adidas
group by 1,2
),
 ranked_state
 as
 ( 
   select 
      retailer,
	  state,
	  total_revenue,
	  dense_rank() over(partition by state order by total_revenue desc) as rnk
	from states
	order by state,rnk
  )
    select 
	   retailer,
	   state,
	   rnk
	 from ranked_state
	 where rnk=1

--12.Top 5 products by total sales.
 select
     distinct product,
	  total_sales
 from adidas
 order by 2 desc
 limit 5


--13.Top 3 retailer–product combinations by revenue.
  with sales 
  as
  (
  select
    retailer,
	product,
	sum(total_sales) as total_revenue
  from adidas
  group by 1,2
  ),
  ranked_product 
  as
    ( select
	   retailer,
	   product,
	   total_revenue,
	   dense_rank() over (partition by retailer order by total_revenue desc) as rnk
	 from sales
	  )
	    select 
		  retailer,
	      product,
	      total_revenue,
		  rnk
		from ranked_product
		where rnk<4


--15.Units Sold by Retailer & Sales Method
 select 
  retailer,
  sales_method,
  sum(units_sold) as products_sold
 from adidas
 group by 1,2
 order by 1,2,3 desc


--16.Which retailer is most profitable?
  select 
    retailer,
	round(sum(operating_profit)/1000000.0,2)||'M' as total_profit
 from adidas
 group by 1
 order by 2 desc


--17.Profit Margin vs Units Sold
 select 
   retailer,
   sum(units_sold) as total_units_sold,
   round(avg(operating_margin_in_percent),2) as margin_pct
  from adidas
  group by 1
  order by 2,3

--18.Total Sales by Product
select
  product,
  round(sum(total_sales)/1000000.0,2)||'M' as total_sales
from adidas
group by 1
order by 2


-----