create database Daily_Attendance_School
use Daily_Attendance_School
select * from Attendance
--Q1 Total Scools ?
Select COUNT(distinct school_dbn) as Total_Unique_Schools
from Attendance
--Q2 Total frequency for each school ?
Select school_dbn , COUNT('school_dbn')  from Attendance 
group by school_dbn order by COUNT('school_dbn') desc
---Q3 Top schools  have students enrolled ?
WITH top_schools AS (
    SELECT TOP 10 
        school_dbn,
        SUM(enrolled) AS total_enrollment
    FROM Attendance
    GROUP BY school_dbn
    ORDER BY SUM(enrolled) DESC
),

school_by_year AS (
    SELECT
        school_dbn,
        YEAR(date) AS year,
        SUM(enrolled) AS total_enrolled_year
    FROM Attendance
    WHERE school_dbn IN (SELECT school_dbn FROM top_schools)
    GROUP BY school_dbn, YEAR(date)
)

SELECT *
FROM school_by_year
ORDER BY school_dbn, year;
--Q3  ---Q3 Top schools  have students absent ?
WITH top_schools AS (
    SELECT TOP 10 
        school_dbn,
        SUM(absent) AS total_absent
    FROM Attendance
    GROUP BY school_dbn
    ORDER BY SUM(absent) DESC
),

school_by_year AS (
    SELECT
        school_dbn,
        YEAR(date) AS year,
        SUM(absent) AS total_absent_year
    FROM Attendance
    WHERE school_dbn IN (SELECT school_dbn FROM top_schools)
    GROUP BY school_dbn, YEAR(date)
)

SELECT *
FROM school_by_year
ORDER BY school_dbn, year;
---Q4 Top schools  have students present ?
WITH top_schools AS (
    SELECT TOP 10 
        school_dbn,
        SUM(present) AS total_present
    FROM Attendance
    GROUP BY school_dbn
    ORDER BY SUM(present) DESC
),

school_by_year AS (
    SELECT
        school_dbn,
        YEAR(date) AS year,
        SUM(present) AS total_present_year
    FROM Attendance
    WHERE school_dbn IN (SELECT school_dbn FROM top_schools)
    GROUP BY school_dbn, YEAR(date)
)

SELECT *
FROM school_by_year
ORDER BY school_dbn, year;
--Q5 Top schools  have students released ?
WITH top_schools AS (
    SELECT TOP 10 
        school_dbn,
        SUM(released) AS total_released
    FROM Attendance
    GROUP BY school_dbn
    ORDER BY SUM(released) DESC
),

school_by_year AS (
    SELECT
        school_dbn,
        YEAR(date) AS year,
        SUM(released) AS total_released_year
    FROM Attendance
    WHERE school_dbn IN (SELECT school_dbn FROM top_schools)
    GROUP BY school_dbn, YEAR(date)
)

SELECT *
FROM school_by_year
ORDER BY school_dbn, year;
--Q6 Count of study days for each school ?
Select school_dbn , COUNT(date) as total_dayes from Attendance
group by school_dbn order by COUNT(date) desc
--Q7 Top 10 days enrolled at schools ?
Select top 10 school_dbn , date , sum(enrolled)  as total_enrolled from Attendance
group by school_dbn,date order by  sum(enrolled) desc
--Q8 lowest 10 days enrolled at schools ?
Select top 10 school_dbn , date , sum(enrolled)  as total_enrolled from Attendance
group by school_dbn,date order by  sum(enrolled) asc
--Q8 Most months have enrolled ?
Select MONTH(date) as month_name , SUM(enrolled) as total_enrolled from Attendance
group by MONTH(date) order by SUM(enrolled) desc
--Q9 Which Quarter have more number Enrolled ?
Select YEAR(date) as Year, 
 case 
     when month(date) between 1 and 3 then 'Q1'
	 when month(date) between 4 and 6 then 'Q2'
	 when month(date) between 7 and 9 then 'Q3' 
	 when month(date) between 10 and 12 then 'Q4' 
 end as Quarters
 , SUM(enrolled) as total_enrolled from Attendance
 group by YEAR(date) , 
 case 
     when month(date) between 1 and 3 then 'Q1'
	 when month(date) between 4 and 6 then 'Q2'
	 when month(date) between 7 and 9 then 'Q3' 
	 when month(date) between 10 and 12 then 'Q4' 
 end order by YEAR(date), case 
     when month(date) between 1 and 3 then 'Q1'
	 when month(date) between 4 and 6 then 'Q2'
	 when month(date) between 7 and 9 then 'Q3' 
	 when month(date) between 10 and 12 then 'Q4' 
 end
 --Q10 Top 10 schools in each Quarter have most enrolled  ?
 WITH QuarterData AS (
    SELECT
        school_dbn,
        YEAR(date) AS Year,
        CASE 
            WHEN MONTH(date) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN MONTH(date) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN MONTH(date) BETWEEN 7 AND 9 THEN 'Q3'
            WHEN MONTH(date) BETWEEN 10 AND 12 THEN 'Q4'
        END AS Quarter,
        SUM(enrolled) AS Total_Enrolled
    FROM Attendance
    GROUP BY 
        school_dbn,
        YEAR(date),
        CASE 
            WHEN MONTH(date) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN MONTH(date) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN MONTH(date) BETWEEN 7 AND 9 THEN 'Q3'
            WHEN MONTH(date) BETWEEN 10 AND 12 THEN 'Q4'
        END
),
RankedData AS (
    SELECT
        school_dbn,
        Year,
        Quarter,
        Total_Enrolled,
        ROW_NUMBER() OVER (
            PARTITION BY Year, Quarter
            ORDER BY Total_Enrolled DESC
        ) AS rn
    FROM QuarterData
)
SELECT 
    school_dbn,
    Year,
    Quarter,
    Total_Enrolled
FROM RankedData
WHERE rn <= 10
ORDER BY Year, Quarter, Total_Enrolled DESC;
--Q11 Make a group as a region for each letter ?
SELECT 
    SUBSTRING(school_dbn, CEILING(LEN(school_dbn) / 2.0), 1) AS Region,
    COUNT(DISTINCT school_dbn) AS Total_Schools,
    SUM(enrolled) AS Total_Enrolled,
    SUM(absent) AS Total_Absent,
    SUM(present) AS Total_Present,
    SUM(released) AS Total_Released
FROM Attendance
GROUP BY 
    SUBSTRING(school_dbn, CEILING(LEN(school_dbn) / 2.0), 1)
ORDER BY 
    Region;
--Q12  Top schools  have students absent ?
WITH top_schools AS (
    SELECT TOP 10 
        school_dbn,
        SUM(absent) AS total_absent
    FROM Attendance
    GROUP BY school_dbn
    ORDER BY SUM(absent) DESC
),

school_by_year AS (
    SELECT
        school_dbn,
        YEAR(date) AS year,
        SUM(absent) AS total_absent_year
    FROM Attendance
    WHERE school_dbn IN (SELECT school_dbn FROM top_schools)
    GROUP BY school_dbn, YEAR(date)
)

SELECT *
FROM school_by_year
ORDER BY school_dbn, year;
--Q 13  Top schools  have students present ?
WITH top_schools AS (
    SELECT TOP 10 
        school_dbn,
        SUM(present) AS total_present
    FROM Attendance
    GROUP BY school_dbn
    ORDER BY SUM(present) DESC
),

school_by_year AS (
    SELECT
        school_dbn,
        YEAR(date) AS year,
        SUM(present) AS total_present_year
    FROM Attendance
    WHERE school_dbn IN (SELECT school_dbn FROM top_schools)
    GROUP BY school_dbn, YEAR(date)
)

SELECT *
FROM school_by_year
ORDER BY school_dbn, year;
--Q 14  Top schools  have students released ?
WITH top_schools AS (
    SELECT TOP 10 
        school_dbn,
        SUM(released) AS total_released
    FROM Attendance
    GROUP BY school_dbn
    ORDER BY SUM(released) DESC
),

school_by_year AS (
    SELECT
        school_dbn,
        YEAR(date) AS year,
        SUM(present) AS total_released_year
    FROM Attendance
    WHERE school_dbn IN (SELECT school_dbn FROM top_schools)
    GROUP BY school_dbn, YEAR(date)
)

SELECT *
FROM school_by_year
ORDER BY school_dbn, year;
--Q15 Total of each one ?
SELECT 
    SUM(enrolled) AS Total_Enrolled,
    SUM(present) AS Total_Present,
    SUM(absent) AS Total_Absent,
    SUM(released) AS Total_Released
FROM Attendance;
--Q16 Attendance rate ?
SELECT 
    SUM(present) * 100 / SUM(enrolled) AS Attendance_Rate
FROM Attendance;
--Q17 Which school have the highest attendance?
SELECT 
  Top 1  school_dbn,
    SUM(present) AS Total_Present
FROM Attendance
GROUP BY school_dbn
ORDER BY Total_Present DESC
--Q18 Which school have the lowest attendance?
SELECT 
   Top 1  school_dbn,
    SUM(absent) AS Total_Absent
FROM Attendance
GROUP BY school_dbn
ORDER BY Total_Absent DESC
--Q19 Which school have the highest released?
SELECT 
   Top 1 school_dbn,
    SUM(released) AS Total_Released
FROM Attendance
GROUP BY school_dbn
ORDER BY Total_Released DESC
-- Q20 Attendance rate for each school ?
SELECT 
    school_dbn,
    SUM(enrolled) AS Total_Enrolled,
    SUM(present) AS Total_Present,
    SUM(absent) AS Total_Absent,
    SUM(released) AS Total_Released,
    SUM(present) * 100 / SUM(enrolled) AS Attendance_Rate
FROM Attendance
GROUP BY school_dbn
ORDER BY Attendance_Rate DESC;
--Q 21 Comparing each school to the average of all schools ?
WITH totals AS (
    SELECT 
        SUM(enrolled) AS total_enrolled,
        SUM(present) AS total_present
    FROM Attendance
)
SELECT 
    school_dbn,
    SUM(enrolled) AS school_enrolled,
    SUM(present) AS school_present,
    SUM(present) * 100 / SUM(enrolled) AS school_rate,
    (SELECT total_present * 100 / total_enrolled FROM totals) AS overall_rate
FROM Attendance
GROUP BY school_dbn;
--Q22 Schools with the highest absent + highest released ?
SELECT 
    school_dbn,
    SUM(absent) AS Total_Absent,
    SUM(released) AS Total_Released
FROM Attendance
GROUP BY school_dbn
ORDER BY Total_Absent DESC, Total_Released DESC;
--Q23The day with the lowest attendance rate ?
SELECT 
    school_dbn,Date,
    present * 100 / enrolled AS Attendance_Rate
FROM Attendance 
ORDER BY Attendance_Rate ASC


