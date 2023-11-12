use pizzadb;

select * from pizza_sales;
#Revenue
select sum(total_price) as total_revenue from pizza_sales;  #"as" is alias (temporary name)
#Average
select sum(total_price)/ count(distinct order_id) as average from pizza_sales; #"distinct" multiple values ignore krna eg(sets) 
#total pizza sold
select sum(quantity) as total_pizza_sold from pizza_sales;
#total orders
select count(distinct order_id) as total_orders from pizza_sales;
#average pizza per order (total quantity/count order)
select cast(sum(quantity) / count(distinct order_id)as decimal(10,2)) as average_pizza_per_order from pizza_sales; 





#ensure that the column is of type VARCHAR or TEXT
ALTER TABLE pizza_sales MODIFY order_date VARCHAR(255);

#Update the column to convert the text to a DATE type
UPDATE pizza_sales
SET order_date = DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y'), '%Y-%m-%d');

#alter the column to type DATE
ALTER TABLE pizza_sales MODIFY order_date DATE;

#extracting weekdays using dayname() function
select dayname(order_date) as order_day, count(distinct order_id) as total_orders from pizza_sales group by(dayname(order_date));

#extracting months using monthname() function
select monthname(order_date) as order_month, count(distinct order_id) as total_orders from pizza_sales group by(monthname(order_date)) order by total_orders desc; #month-names
select month(order_date) as order_month, count(distinct order_id) as total_orders from pizza_sales group by(month(order_date)); #month-number

#percentage of total sales category wise
select pizza_category, sum(total_price)*100/ (select sum(total_price) from pizza_sales) as percent_total_sales from pizza_sales group by pizza_category;
#Month wise 
select pizza_category, sum(total_price) as total_sales, sum(total_price)*100/ (select sum(total_price) from pizza_sales where month(order_date)=1) as percent_total_sales
 from pizza_sales where month(order_date)=1
 group by pizza_category;

#percentage of total sales of pizza based on size 
select pizza_size, cast(sum(total_price) as decimal(10,2)) as total_sales, cast(sum(total_price)*100/ (select sum(total_price) from pizza_sales)as decimal(10,2)) as percent_total_sales
 from pizza_sales 
 group by pizza_size
 order by percent_total_sales desc;

#total pizza sold by category for feburary month
select pizza_category, sum(quantity) as total_pizza_sold from pizza_sales
where month(order_date)=2
group by pizza_category
order by total_pizza_sold desc;


#top 5 highest and lowest sellers by revenue, total quantity and total orders
select pizza_name, sum(total_price) as total_revenue from pizza_sales group by pizza_name order by total_revenue desc limit 5;
select pizza_name, sum(total_price) as total_revenue from pizza_sales group by pizza_name order by total_revenue asc limit 5;

#highest and lowest 5 pizza sold by quantity
select pizza_name, sum(quantity) as total_pizza_sold from pizza_sales group by pizza_name order by total_pizza_sold desc limit 5;
select pizza_name, sum(quantity) as total_pizza_sold from pizza_sales group by pizza_name order by total_pizza_sold asc limit 5;

#highest and lowest 5 pizza ordered
select pizza_name, count(distinct order_id) as total_pizza_ordered from pizza_sales group by pizza_name order by total_pizza_ordered desc limit 5;
select pizza_name, count(distinct order_id) as total_pizza_ordered from pizza_sales group by pizza_name order by total_pizza_ordered asc limit 5;

#using where clause we can find out category wise highest oreder or lowest orderd pizza
select pizza_name, count(distinct order_id) as total_pizza_ordered from pizza_sales where pizza_category='classic' group by pizza_name order by total_pizza_ordered desc limit 5;






