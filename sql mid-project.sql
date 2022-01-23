-- SQL questions - regression
-- 1. Create a database called `house_price_regression`.
​
drop database if exists house_price_regression;
​
create database if not exists house_price_regression;
​
-- 2. Create a table `house_price_data` with the same columns as given in the csv file. Please make sure you use the correct data types for the columns. You can find the names of the headers for the table in the `regression_data.xls` file. Use the same column names as the names in the excel file. Please make sure you use the correct data types for each of the columns.
​
drop table if exists house_price_data;
​
create table house_price_data (
	`Id` varchar(20) unique not null,  -- primary key
	`Date` date default null, 
	`Bedrooms` int default null, 
	`Bathrooms` float default null, 
	`Sqft living` float default null, 
	`Sqft lot` float default null, 
	`Floors` float not null, 
	`Waterfront` int default null, 
	`View` int default null, 
	`Condition` int default null, 
	`Grade` int DEFAULT null, 
	`Sqft above` float default null, 
	`Sqft basement` float default null, 
	`Year built` float default null, 
	`Year renovated` float default null, 
	`Zipcode` float default null, 
	`Lat` char(15) default null, 
	`Long` char(15) default null, 
	`Sqft living15` float default null, 
	`Sqft lot15` float default null, 
	`Price` int default null, 
	constraint primary key (`Id`)
	);
		
-- 3. Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. (in this case we have already deleted the header names from the csv files).  To not modify the original data, if you want you can create a copy of the csv file as well. Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:
​
show variables like 'local_infile'; -- it is off
​
set global local_infile = 1;
​
show variables like 'secure_file_priv';
​
set sql_safe_updates = 0; -- the secure_file_priv did not work for me
​
-- 4. Select all the data from table `house_price_data` to check if the data was imported correctly
​
select * from house_price_data;
​
-- 5. Use the alter table command to drop the column `date` from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
​
alter table house_price_data
drop column Date;
select * from house_price_data
limit 10;
​
-- 6.  Use sql query to find how many rows of data you have.
​
select count(Id) as 'Number of rows' from house_price_data;
​
-- 7. Now we will try to find the unique values in some of the categorical columns:
    -- What are the unique values in the column `bedrooms`?
    select distinct `bedrooms` from house_price_data;
    
    -- What are the unique values in the column `bathrooms`?
    select distinct bathrooms from house_price_data;
    
    -- What are the unique values in the column `floors`?
    select distinct floors from house_price_data;
    
    -- What are the unique values in the column `condition`?
    select distinct `condition` from house_price_data;
    
    -- What are the unique values in the column `grade`?
    select distinct grade from house_price_data;    
        
-- 8. Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
​
select Id from house_price_data
order by price desc
limit 10;
​
-- 9. What is the average price of all the properties in your data?
​
select round(avg(price), 2) as 'Average Price' from house_price_data;
​
-- 10. 10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data
    -- What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
    
    select bedrooms, round(avg(price), 2) as 'Average Price' from house_price_data
    group by bedrooms
    order by bedrooms asc;
    
    -- What is the average `sqft_living` of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the `sqft_living`. Use an alias to change the name of the second column.
    
    select bedrooms, round(avg(`Sqft living`), 2) as 'Average Sqft' from house_price_data
    group by bedrooms
    order by bedrooms asc;
    
    -- What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and `Average` of the prices. Use an alias to change the name of the second column.
    
    select waterfront, round(avg(Price), 2) as 'Average Price' from house_price_data
    group by waterfront;
    
    -- Is there any correlation between the columns `condition` and `grade`? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
	 -- You might also have to check the number of houses in each category (ie number of houses for a given `condition`) to assess if that category is well represented in the dataset to include it in your analysis. For eg. If the category is under-represented as compared to other categories, ignore that category in this analysis
	 
	select `condition`, round(avg(grade), 2) as 'Avg Grade', count(`Id`) from house_price_data
	group by `condition` 
	order by `condition` asc; -- it is clear that the houses with 1 & 2 of condition are under represented
	
	select grade, round(avg(`condition`),2) as 'Avg Condiion', count(`Id`) from house_price_data
	group by grade
	order by grade asc; -- as well we have under represented categories that would be better to drop off.
	
	-- But it does not appear to be a clear correlation between grade and condition
	 
-- 11. One of the customers is only interested in the following houses:
    -- Number of bedrooms either 3 or 4
    -- Bathrooms more than 3
    -- One Floor
    -- No waterfront    
    -- Condition should be 3 at least
    -- Grade should be 5 at least
    -- Price less than 300000
-- For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them?
​
select * from house_price_data
where (`bedrooms` = 3 or `bedrooms` = 4)
and `bathrooms` >= 3
and `floors` = 1
and `waterfront` = 0
and `grade` >= 5
and `condition` = 3
and price < 300000;
​
-- 12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.
​
select round(avg(price),2) * 2 as 'Average Price' from house_price_data; -- twice the average
​
select * from house_price_data
where price >= (select round(avg(price),2) * 2 as 'Average Price' from house_price_data);
​
-- 13. Since this is something that the senior management is regularly interested in, create a view called `Houses_with_higher_than_double_average_price` of the same query.
​
create view Houses_with_higher_than_double_average_price as
select * from house_price_data
where `price` >= (select round(avg(price),2) * 2 as 'Average Price' from house_price_data);
​
-- 14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms? In this case you can simply use a group by to check the prices for those particular houses. 
​
select bedrooms, round(avg(price),2) as 'Avg price' from house_price_data
where bedrooms = 3 or bedrooms = 4
group by bedrooms;
​
-- 15. What are the different locations where properties are available in your database? (distinct zip codes)
​
select distinct `zipcode` from house_price_data
order by `zipcode` asc;
​
-- 16. Show the list of all the properties that were renovated.
​
select * from house_price_data
where `Year renovated` > 0
order by `Year renovated` asc;
​
-- 17. Provide the details of the property that is the 11th most expensive property in your database.
with cte_most_expensive as
(select * from house_price_data
order by price desc
limit 11
)
​
select * from cte_most_expensive
order by price asc
limit 1;