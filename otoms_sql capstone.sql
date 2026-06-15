CREATE DATABASE OTOMS_TDI;
use OTOMS_TDI;
select * 
from stress_capstone;

update stress_capstone
 set gender = case
  when gender = 'm' then 'Male'
  when gender = 'f' then 'Female'
  end ;

  
	Exec sp_rename 'Stress_capstone.id', 'ID'
	Exec sp_rename 'Stress_capstone.first_name', 'First Name'
	Exec sp_rename 'Stress_capstone.last_name', 'Last Name'
	Exec sp_rename 'Stress_capstone.gender', 'Gender'
	Exec sp_rename 'Stress_capstone.dob', 'Date of Birth'
	Exec sp_rename 'Stress_capstone.test_date', 'Test Date'
	Exec sp_rename 'Stress_capstone.test_time', 'Test Time'
	Exec sp_rename 'Stress_capstone.stress_source', 'Stress Source'
	Exec sp_rename 'Stress_capstone.physical_symptoms', 'Physical Symptoms'
	Exec sp_rename 'Stress_capstone.emotional_symptoms', 'Emotional Symptoms'
	Exec sp_rename 'Stress_capstone.coping_mechanism', 'Coping Mechanism'
	Exec sp_rename 'Stress_capstone.stress_duration', 'Stress Duration'
	Exec sp_rename 'Stress_capstone.severity', 'Severity'
	Exec sp_rename 'Stress_capstone.sleep_quality', 'Sleep Quality'
	Exec sp_rename 'Stress_capstone.mood', 'Mood'
	Exec sp_rename 'Stress_capstone.heart_rate', 'Heart Rate'
	Exec sp_rename 'Stress_capstone.cortisol_level', 'Cortisol Level'
	Exec sp_rename 'Stress_capstone.stress_level_score', 'Stress Level Score'
	;

	With Duplicates As (
Select *, ROW_NUMBER() over (Partition by ID,[First Name],[Last Name] ,Gender ,"Date of Birth" ,"Test Date"
,[Test Time],[Stress Source] ,[Physical Symptoms],[Emotional Symptoms],[Coping Mechanism],[Stress Duration]
,[Severity],[Sleep Quality],[Mood],[Heart Rate],[Cortisol Level],[Stress Level Score]
order by (Select Null)) As RowNum
From stress_capstone)
Delete From Duplicates 
Where RowNum > 1;

	Update stress_capstone
	Set [Stress Level Score] = (select round(avg([stress level score]), 10)
	from stress_capstone)
	Where ID = 'FSXMV4';

		Delete From stress_capstone
	Where ID is null or [First Name]is null or [Last Name] is null or Gender is null or "Date of Birth" is null or
	"Test Date" is null or [Test Time] is null or [Stress Source]is null or [Physical Symptoms]is null or 
	[Emotional Symptoms] is null or [Coping Mechanism] is null or [Stress Duration] is null or
	[Severity] is null or [Sleep Quality] is null or [Mood] is null or [Heart Rate] is null or [Cortisol Level] is null or
	[Stress Level Score]is null
	;

	select * from stress_capstone;

	--- 1 age column
select *
from stress_capstone;

alter table stress_capstone
add Age int;

update stress_capstone
	Set Age = datediff(year,[date of birth],[test date])-case
	when dateadd(year,datediff(year,[date of birth], [test date]),
	[date of birth]) > [test date]
	then 1
	else 0
	end;

--- To group the age of the employees
Alter table stress_capstone
Add [Age Group] nvarchar(50);
update stress_capstone
	set [Age Group] = case
	when age between 17 and 25 then '17 - 25'
		when age between 26 and 35 then '26 - 35'
		when age between 36 and 45 then '36 - 45'
		when age between 46 and 55 then '46 - 55'
		when age between 56 and 65 then '56 - 65'
		when age between 66 and 75 then '66 - 75'
		when age between 76 and 79 then '76 - 79'
		else 'not known'
		end;



--- 3 to categorize the stress level score of the employees
alter table stress_capstone
 add [Stress category] nvarchar(50);

 update stress_capstone
 set [stress category] =  case
		when round([stress level score], 2) between 0.00 and 0.99
		then 'Low Stress'
		when round([stress level score],2) between 1.00 and 1.90 
		then 'Normal stress'
		when round([stress level score],2) between 1.91 and 2.38 
		then 'Mild Stress'
		else 'High Stress'
	end ;


--- categorizing time into morning afternoon and evening;
select max([test time]) 
from stress_capstone;


alter table stress_capstone
add [Test Time category] nvarchar(50);

update stress_capstone
set [Test Time category] = case
	when [test time] between '08:00:00' and '11:59:59' then 'Morning'
	when [test time] between '12:00:00' and '15:59:59' then 'Noon'
	when [test time] between '16:00:00' and '19:59:59' then 'Evening'
	else 'Night'
end;

--- to correct 'stomach ache' and 'stomach age'
UPDATE stress_capstone
	SET [Physical Symptoms] = 'Stomach Ache'
	WHERE [Physical Symptoms] = 'Stomach Age';

---KPIS
--1 total employees
select count(id) as 'total employees' 
from stress_capstone;

---2 average age
select AVG(age) as 'average age of employees'
from stress_capstone;

--- 3 average cortisol level
select avg([cortisol level]) as 'Average cortisol level' 
from stress_capstone;

---4 average stress level score
select round(AVG([stress level score]), 7) as 'Average stress level'
from stress_capstone;

--- average heart rate
select AVG([heart rate]) as 'average heart rate'
from stress_capstone;
--- most preferred coping mechanism
select TOP 2 [Coping Mechanism]
from (select [coping mechanism], count(id) as 'frequency'
		from stress_capstone
		group by [Coping Mechanism]
		order by 'frequency' desc);

		--- OBJECTIVES

--- 1 Most Common physical symptom
select [Physical Symptoms], count(id) as 'frequency'
from stress_capstone
group by [Physical Symptoms] 
order by frequency desc;

---2 emotional symptoms
select [Emotional Symptoms], count(id) as 'frequency' 
from stress_capstone
group by [Emotional Symptoms]
order by frequency desc;

--- 3 mood of employees by time of day
select mood, [Test Time category], count(id) as 'frequency'
from stress_capstone
group by mood, [Test Time category];

--- 4 stress source
 select [stress source], count(id) as 'frequency'
 from stress_capstone
 group by [Stress Source]
 order by frequency desc;
 
 ---5 cortisol level at time of test
 select [Test Time category],avg([cortisol level]) as 'cortisol levels'
 from stress_capstone
 group by [test Time category];

 ---6 Employees preferred coping mechanism
 select [coping mechanism], count(id) as 'frequency'
		from stress_capstone
		group by [Coping Mechanism]
		order by frequency desc;

--- 7 Heart rate by stress category
select [stress category], avg([heart rate]) as 'Average heart rate'
from stress_capstone
group by [Stress category];

--- 8 sleep quality and stress category by stress level score, heart rate, cortisol level, stress duration
select [Sleep Quality], [Stress category], round(avg([stress level score]),3) as  'Average stress level',
			avg([cortisol level]) as 'Average cortisol level', avg([heart rate]) as 'Average heart rate',
			avg([stress duration]) as 'Average stress duration' 
FROM stress_capstone
Group by [Sleep Quality],[Stress category]
order  by [Sleep Quality];
		
--- 9 stress category 
select [stress category], count(id) as 'Frequency'
from stress_capstone
group by [Stress category];


--- 10 gender and stress source
select gender,[stress source], count([id]) as stress_frequency 
 from stress_capstone
 group by gender, [stress source]
 order by stress_frequency DESC;

 
 ---11 severity by age group
 select [age group],severity, count([age]) as [amount of employee]
 from stress_capstone
 group by [Age Group], severity
 order by severity, [amount of employee];

 select [Age Group], count(id) as 'Number of employees'
 from stress_capstone
 group by [Age Group];

 select column_name, data_type 
 from information_schema.columns
 where table_name =  'stress_capstone'
 
 SELECT [COPING MECHANISM], SEVERITY, AVG([STRESS LEVEL SCORE]) AS 'AVG_STRESS LEVEL'
 FROM stress_capstone
 GROUP BY [Coping Mechanism], SEVERITY
 ORDER BY 'AVG_STRESS LEVEL' DESC;
 
 SELECT SEVERITY, AVG([STRESS DURATION]) AS 'AVG STRESS DURATION', AVG([STRESS LEVEL SCORE]) AS 'AVG_STRESS LEVEL',
 AVG([CORTISOL LEVEL]) AS 'AVG CORTISOL LEVEL'
 FROM stress_capstone
 GROUP BY SEVERITY;

 SELECT DISTINCT [PHYSICAL SYMPTOMS], COUNT(ID) AS 'NUMBER'
 FROM STRESS_CAPSTONE
 WHERE [STRESS SOURCE] = 'RELATIONSHIPS'
 GROUP BY [PHYSICAL SYMPTOMS];

 SELECT DISTINCT [EMOTIONAL SYMPTOMS], COUNT(ID) AS 'AMOUNT'
 FROM STRESS_CAPSTONE
 WHERE [STRESS SOURCE] = 'RELATIONSHIPS'
 GROUP BY [EMOTIONAL SYMPTOMS];


 --- LONGEST LASTING STRESS SOURCE
 SELECT [STRESS SOURCE],AVG([STRESS DURATION]) AS 'AVG STRESS DURATION', COUNT(ID) AS 'NUMBER OF EMPLOYEES'
 FROM stress_capstone
 GROUP BY [STRESS SOURCE]
 ORDER BY 'AVG STRESS DURATION' DESC

 --- MOST COMMON COPING MECHANISM
 SELECT [COPING MECHANISM], COUNT(ID) AS 'NUMBER OF EMPLOYEES'
 FROM stress_capstone 
 GROUP BY [COPING MECHANISM]
 ORDER BY 'NUMBER OF EMPLOYEES' DESC;

 --- COPING MECHANISM BY STRESS LEVELS
 SELECT [COPING MECHANISM], AVG([STRESS LEVEL SCORE]) AS 'AVG STRESS LEVELS' 
 FROM STRESS_CAPSTONE
 GROUP BY [COPING MECHANISM]
 ORDER BY 'AVG STRESS LEVELS' DESC;


select [age group], count(id) as total_number
from stress_capstone
group by [age group]
order by [Age Group];


select [gender],[age group], count(id) as total_number
from stress_capstone
group by [gender], [age group]
order by [age group], [gender];