use Interview_Dataset;
select * from [Superstore Data];
---LEVEL 1 — Beginner (Basic SQL | Screening Round)
---Total sales aur total profit calculate karo.
select sum(try_cast (sales as float)) as total_sales , 
SUM(try_cast(profit as float)) as total_profit 
from [Superstore Data];
---Har region ka total sales nikaalo.
select region, sum(sales) as Region_sales 
from [Superstore Data]
group by region ; 
---Har category me kitne orders hue hain?
select category, COUNT(distinct order_id) as total_orders
from [Superstore Data]
group by category;
---Top 5 products by sales ka naam nikaalo.
select top 5 product_id , sum(sales) as product_sales 
from [Superstore Data]
group by product_id
order by product_sales desc;
---Kaun-se ship mode me sabse zyada orders hain?
select ship_mode, count(distinct order_id) as total_orders
from [Superstore Data]
group by ship_mode
order by total_orders desc;
---Negative profit wale orders ka count nikaalo.
select count(*) as negative_profit_orders
from [Superstore Data]
where try_cast (profit as float) <0;
---Har segment ka total profit nikaalo.
select segment,
sum(try_cast (profit as int)) as Segment_profit 
from [Superstore Data]
group by segment;
---Distinct states ki list nikaalo jahan orders aaye.
select count(DISTINCT state) as distinct_state 
from [Superstore Data];
---Year-wise total sales nikaalo (Order Date se).
select YEAR(order_date) as order_Year,
sum(sales ) as total_sales  
from [Superstore Data]
group by year(order_date)
order by order_year;	
---Average discount per category find karo.
select category,AVG(try_cast (discount as float)) as Avg_discount
from [Superstore Data]
group by category
order by Avg_discount desc;
---LEVEL 2 — Intermediate (Joins, Group By, KPI Thinking)
---Har sub-category ka total sales aur profit nikaalo.
select sub_category,
sum(try_cast(sales as float)) as total_sales,
sum(try_cast(profit as float)) as total_proft
from [superstore data]
group by sub_category;
---Kaun-si state sabse zyada profit generate karti hai?
select state,
sum(try_cast(profit as float)) as total_profit
from [Superstore Data]
group by state
order by total_profit desc;
---Region + Category combination ka total sales nikaalo.
select region, 
category, 
sum(try_cast(sales as float)) as Total_sales 
from [Superstore Data]
group by region,category;
---Har customer ka total sales nikaal ke top 10 customers dikhao.
select top 10 customer_name,
sum(try_cast (sales as float)) as total_sales
from [superstore data]
group by customer_name
order by total_sales desc;
---Kaun-se products loss-making hain (overall profit < 0)?
select product_id, 
sum(try_cast(profit as float)) as total_profit 
from [Superstore Data]
group by product_id
having sum(try_cast(profit as float ))<0;
---Ship Mode wise average delivery time nikaalo (Order Date vs Ship Date use karke).
select ship_mode,
avg(datediff(day,order_date,ship_date)) as avg_delivery_days
from [superstore Data]
group by ship_mode;
---Har year ka profit margin calculate karo.
select year(order_date) as order_year,
sum(try_cast (profit as float))/ sum(try_cast(sales as float)) as profit_margin
from [Superstore Data]
group by year(order_date);
---Kaun-sa segment highest average order value deta hai?
select top 1 segment,
avg(try_cast(sales as float)) as avg_order_value
from [Superstore Data]
group by segment
order by avg_order_value desc;
---Category wise discount impact check karo (avg discount vs profit).
select category,
avg(try_cast(discount as float)) as avg_discount,
sum(try_cast(profit as float)) as total_profit
from [Superstore Data]
group by category;
---Har city me total orders aur total profit nikaalo.
select city, 
count(distinct order_id) as total_orders,
sum(try_cast(profit as float)) as total_profit
from [Superstore Data]
group by city;
---LEVEL 3 — Advanced (Subqueries, Window Functions)
---Har category ka top 3 products by profit nikaalo.
select product_id,
category,
total_profit
from (select category,
product_id,
sum(try_cast(profit as float)) as total_profit,
dense_rank() over(partition by category
order by sum(try_cast(profit as float)) desc ) as rnk
from [Superstore Data]
group by category,product_id ) as t
where rnk <=3;
---Har region ka highest profit-making product find karo.
select product_id,
region,
total_profit
from ( select region,
product_id,
sum(try_cast(profit as float)) as total_profit,
rank() over( partition by region
order by sum(try_cast(profit as float)) desc ) as rnk
from [superstore Data]
group by region, product_id) as t
where rnk=1;
--Month-wise running total sales calculate karo.
select order_month,
monthly_sales ,
sum(monthly_sales) 
over ( order by order_month) as running_total_sales
from( select 
month(order_date) as order_month,
sum(try_cast(sales as float)) as monthly_sales
from [Superstore Data]
group by month(order_date)) as t;
---Har customer ka first order date aur last order date nikaalo.
select customer_name,
max(order_date) as last_order_date,
min(order_date) as first_order_date
from [Superstore Data]
group by customer_name;
---Kaun-se customers repeat buyers hain (1 se zyada orders)?
select customer_name,
count(distinct order_id) as total_orders
from [Superstore Data]
group by customer_name
having count(distinct order_id) >1
order by total_orders;
---Year-over-year sales growth % calculate karo.
select order_year,
total_sales,
round((total_sales-lag(total_sales) 
over( order by order_year))
*100.0/lag(total_sales) 
over(order by order_year),2
) as yoy_growth_percent
from ( select year(order_date) as order_year,
sum(try_cast(sales as float)) as total_sales
from [Superstore Data]
group by year (order_date)) as t;
---Har state ka contribution % to total sales nikaalo.
select state,
sum(try_cast(sales as float)) as state_sales,
round(sum(try_cast(sales as float)) * 100.0 /
sum(sum(try_cast(sales as float))) 
over (),2) as sales_contribution_percent
from [Superstore Data]
group by state;
---Kaun-se sub-categories consistently loss me hain?
select sub_category,
sum(try_cast(profit as float)) as total_profit
from [Superstore Data]
group by sub_category
having sum(try_cast(profit  as float))<0;
---Rank customers based on total profit (use window function).
select customer_name,
total_profit,
rank() over ( order by total_profit desc) as profit_rank
from( select customer_name,
sum(try_cast(profit as float)) as total_profit
from [Superstore Data]
group by customer_name ) as t;
---Har month ka best performing category nikaalo.
select order_month,
category,
total_sales
from( select month(order_date) as order_month,
category,
sum(try_cast(sales as float)) as total_sales,
rank () over ( partition by month (order_date)
order by sum(try_cast(sales as float)) desc) as rnk
from [Superstore Data]
group by month (order_date), category) as t
where rnk = 1;
---LEVEL 4 — Business / Interview Advanced (GitHub-Ready ⭐)
---Kaun-se products high sales but low profit generate karte hain?
select product_id ,
sum(try_cast(sales as float)) as total_sales,
sum(try_cast(profit as float)) as total_profit
from [Superstore Data]
group by Product_ID
having sum(try_cast(profit as float)) <0 ;
---Discount ke wajah se profit loss ka analysis karo.
select Discount,
sum(Try_cast(profit as float)) as total_profit
from [Superstore Data]
group by discount
having sum(Try_cast(profit as float)) <0;
---Pareto analysis: Kaun-se 20% products 80% sales dete hain?
with prod as (
select product_id,
sum(try_cast(sales as float)) as total_sales
from [Superstore Data]
group by Product_id ),
ranked as ( 
select product_id,
total_sales,
sum(total_sales)
over (order by total_sales desc) as running_sales,
sum(total_sales)
over() as total_sales_all
from prod )
select product_id,
total_sales,
Running_sales,
total_sales_all,
running_sales/ Total_sales_all as cumulative_percentage
from ranked
where running_sales/total_sales_all<=0.80;
---Har region me kaun-si category sabse zyada profitable hai?
with cte as (
select Region,
category,
sum(try_cast(profit as float)) as total_profit
from [Superstore Data]
group by region, category),
ranked as(
select region,
category,
total_profit,
rank () over(partition by region order by total_profit desc) as rnk
from cte)
select * from ranked 
where rnk=1;
---Customer Lifetime Value (CLV) type metric design karo.
select customer_name,
sum(try_cast(sales as float)) as CLV
from [Superstore Data]
group by customer_name
order by CLV desc;
---Seasonality analysis: Kaun-se months me sales peak hoti hai?
select datename( month,order_date) as month_name,
month(order_date) as month_nomber,
sum(Try_cast(sales as float)) as total_sales
from [Superstore Data]
group by datename(month,order_date),month(order_date)
order by total_sales desc;
---Loss-making orders ko kaun-se states & categories drive kar rahe hain?
select Category,
state,
count(*) as loss_orders
from [Superstore Data]
where try_cast(profit as float)<0
group by category,state
order by loss_orders desc;
---Ship mode optimization suggestion ke liye data nikaalo.
select ship_mode,
region,
sum(try_cast(sales as float)) as total_sales,
sum(try_cast(profit as float)) as total_profit
from [Superstore Data]
group by ship_mode ,region
order by total_profit desc;
---Top 10 customers ka total profit vs overall profit % find karo.
with total as (
select sum(try_cast(profit as float)) as total_profit 
from [Superstore Data]),
cust as (
select customer_name,
sum(try_cast(profit as float)) as cust_profit
from [Superstore Data]
group by Customer_Name)
select top 10 customer_name,
cust_profit,
(cust_profit/total_profit)*100 as profit_percentage
from cust,total
order by cust_profit desc;
---Ek query likho jo dashboard KPIs ke liye use ho sake.
SELECT SUM(try_cast(Sales as float)) AS Total_Sales,
SUM(try_cast(Profit as float)) AS Total_Profit,
SUM(try_cast(Discount as float)) AS Total_Discount,
COUNT(DISTINCT Order_ID) AS Total_Orders
FROM [Superstore Data];
SELECT round(SUM(try_cast(Sales as float)),2) AS Total_Sales
from [Superstore Data];