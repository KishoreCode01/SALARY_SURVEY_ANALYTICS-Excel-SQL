create database Salary_Survey;

use Salary_Survey;

create table salary_data(
	Age_Range varchar(20),
	Industry varchar(100),
	Job_Title varchar(100),
	Annual_Salary int,
	Additional_Monetary_Compensation int,
	Currency varchar(10),
	Country varchar(100),
	City varchar(100),
	Years_of_Professional_Experience_Overall varchar (100),
	Years_of_Professional_Experience_in_Field varchar(100),
	Education varchar(100),
	Gender varchar(50)
);


create table Exchage_value(
	Currency_ctry varchar(3),
    Exchage_Value decimal (10,6)
);

alter table salary_data add column Salary_USD decimal(30,2);
alter table salary_data add column Additional_Monetary_Compensation_USD decimal(30,2);

SET SQL_SAFE_UPDATES = 0;
update salary_data s
inner join exchage_value e on s.Currency = e.Currency_ctry
set s.Salary_USD = s.Annual_Salary * e.Exchage_Value;

update salary_data s
inner join exchage_value e on s.Currency = e.Currency_ctry
set s.Additional_Monetary_Compensation_USD = s.Additional_Monetary_Compensation * e.Exchage_Value;


select * from salary_data;
select * from exchage_value;

-- 1.Average Salary by Industry and Gender

select Industry,Gender,Concat("$ ",round(avg(Salary_USD),2)) as Average_Salary
from salary_data
group by Industry,Gender;

--  2.Total Salary Compensation by Job Title

select Job_Title, sum(Salary_USD), sum(Additional_Monetary_Compensation_USD),
concat("$ ",sum(Salary_USD + Additional_Monetary_Compensation_USD)) as Total_Salary
from salary_data group by Job_Title;

-- 3.Salary Distribution by Education Level

select Education,concat("$ ",round(avg(Salary_USD),2)) as Average_Salary,
 concat("$ ",min(Salary_USD)) as Minimum_Salary,
 concat("$ ",max(Salary_USD)) as Maximum_Salary
from salary_data group by Education;

-- 4. Number of Employees by Industry and Years of Experience

select count(Industry) as No_Of_Employees,Industry,Years_of_Professional_Experience_Overall
from salary_data 
group by Industry,Years_of_Professional_Experience_Overall;

-- 5.Median Salary by Age Range and Gender

select Age_Range,Gender,concat("$ ",round(avg(Salary_USD),2)) as Median_Salary
from salary_data
group by Age_Range,Gender
order by Age_Range asc;

-- 6. Job Titles with the Highest Salary in Each Country

select Job_Title,Country,concat("$ ",max(Salary_USD)) as Maximum_Salary
from salary_data
group by Job_Title,Country order by Maximum_Salary desc;

-- 7. Average Salary by City and Industry

select Industry,City,concat("$ ",round(avg(Salary_USD),2)) as Average_Salary
from salary_data
group by Industry,City;

-- 8. Percentage of Employees with Additional Monetary Compensation by Gender

select * from salary_data;

select Gender,
    concat(round(100 * sum(
    case when 
        Additional_Monetary_Compensation > 0 
        then 1 
        else 0 
        end) / count(*), 2),'%') as Additional_Monetary_Compensation
from salary_data
group by Gender
order by Gender;

-- 9. Total Compensation by Job Title and Years of Experience

select Job_Title,Years_of_Professional_Experience_in_Field,
concat("$ ",sum(Salary_USD+Additional_Monetary_Compensation_USD)) as Total_Salary
from salary_data
group by Job_Title,Years_of_Professional_Experience_in_Field;

-- 10. Average Salary by Industry, Gender, and Education Level

select Industry,Gender,Education, concat("$ ",round(avg(Salary_USD),2)) as Average_Salary
from salary_data
group by Industry,Gender,Education;












