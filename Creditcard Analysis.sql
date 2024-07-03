--The objective of this Analysis is aimed at understanding the factors that influence an individual's eligibility for a credit card, and identifying trends in those factors. 

							--DEMOGRAPHIC ANALYSIS OF ELIGIBILITY--
--1. How does demographic factors like Gender and age influence Credit Card Eligibility?
	--(a) Analyze the eligibility rates for different age groups. Identify if there are any significant differences--


WITH age_group_eligibility AS 
	(SELECT  
		CASE
		WHEN ROUND(age, 0) BETWEEN 18 AND 30 THEN 'Young adult (18-30)'
		WHEN ROUND(age, 0) BETWEEN 31 AND 50 THEN 'Middle-aged adult (31-50)'
		WHEN ROUND(age, 0) BETWEEN 51 AND 70 THEN 'Aging adult (51-70)'
		WHEN ROUND(age, 0) > 70 THEN 'Aged'
		ELSE 'Not applicable'
		END AS age_group,
		CASE
		WHEN target = 1 THEN 1
		END AS eligible,
		CASE
		WHEN target = 0 THEN 1
		END AS not_eligible
FROM creditcard_dataset)

SELECT DISTINCT(age_group),
	   COUNT(age_group) age_group_count,
	   COUNT(eligible) eligible_count,
	   COUNT(not_eligible) not_eligible_count,
	   (COUNT(eligible) * 100) / COUNT(age_group)  AS eligible_percent,
	   (COUNT(not_eligible) * 100) / COUNT(age_group)  AS not_eligible_percent
FROM age_group_eligibility
GROUP BY age_group
ORDER BY age_group DESC;
--From the results of this query, among the 3 age group segments, there is a significant number that is not eligible for credit cards, based on each segments
--eligibility count, from the target column. On the surface level, it appears that there are more individuals under the middle_aged adults who are eligible
--for credit cards. However, looking deeper we can see that the reason for the higher number of eligible individuals is because the overall number of individuals
--in this segment is higher than the rest of the segments but as per on a percentage of each segment's volume, the middle_aged adults segment is not leading.
--When it comes to percent eligibility of each segment, the young adult segment has a higher percentage of eligible individuals and a lower percentage of not
--eligible individuals than the rest of the segments. This can present an opportunity for the credit card issuing company to see potential among the young
--adult segment. 


	--(b) Is there a significant difference in credit card eligibility between genders? Calculate the eligibility rate percent of individuals with "target" = 1
	--for each gender. 

WITH t1 AS   
			(SELECT  
				CASE
				WHEN gender = 0 THEN 'Male'
				WHEN gender = 1 THEN 'Female'
				END AS gender,
				CASE
				WHEN target = 1 THEN 1
				END AS eligible,
				CASE
				WHEN target = 0 THEN 1
				END AS not_eligible
FROM creditcard_dataset)

SELECT DISTINCT gender,
				COUNT(gender) gender_count,
				COUNT(eligible) eligible_count,
			    (COUNT(eligible) * 100) / COUNT(gender) AS percent_eligible
FROM t1
GROUP BY gender;
--As is the case with the previous query, there is a higher count of males than females who are eligible, based on the "target" rating.
--However, it is also worth noting that that the reason for the higher count of eligibility for males is that there is also a higher gender count for
--males, hence the higher eligibility count. However, on the basis of percentage based on each gender group's total count, females have a slightly higher 
--eligibility percent than males. It is almost as good as equal, so there is no significant difference among the 2 genders. 



--IMPACT OF EMPLOYMENT ON CREDIT CARD ELIGIBILITY
--2. How does employment status affect credit card eligibility?
--Compare the eligibility rates for employed and unemployed indiciduals using the unemployed column.

WITH t1 AS 
		(SELECT
			CASE
			WHEN unemployed = 0 THEN 'Employed'
			WHEN unemployed = 1 THEN 'Unemployed'
			END AS employment_status,
			CASE
			WHEN target = 1 THEN 1
			END AS eligible,
			CASE
			WHEN target = 0 THEN 1
			END AS not_eligible
FROM creditcard_dataset)

SELECT DISTINCT
	   employment_status,
	   COUNT(employment_status) employment_status_count,
	   COUNT(eligible) eligible_count,
	   COUNT(not_eligible) not_eligible_count,
	   (COUNT(eligible) * 100) / COUNT(employment_status) percent_eligible,
	   (COUNT(not_eligible) * 100) / COUNT(employment_status) percent_not_eligible
FROM t1
WHERE employment_status IS NOT NULL
GROUP BY employment_status
ORDER BY employment_status_count DESC;
--In this analysis, there is a significant difference between the percentage of eligible people and not eligible people across the 2 employment groups.
--There is a small percent of eligible individuals in the both employment groups, among the vast count of individuals in each group. 
--It seems that employment is not a signigicant factor in determining the eligibility of individuals in this dataset. 


												--INCOME AND FAMILY STATUS ANALYSIS
--3. What is the relationship between total income and family status on Credit Card Eligibility?
	 --Determine the average total income for each family status category and compare the eligibility rates.

WITH t1 AS 
		 (SELECT DISTINCT family_status,
				ROUND(total_income, 0) total_income,
				CASE
				WHEN target = 1 THEN 1
				END AS eligible,
				CASE
				WHEN target = 0 THEN 1
				END AS not_eligible
FROM creditcard_dataset)

SELECT DISTINCT family_status,
				ROUND(AVG(total_income), 0) avg_total_income,
				COUNT(eligible) eligible_count,
				COUNT(not_eligible) not_eligible_count
FROM t1
WHERE Family_status IS NOT NULL
GROUP BY family_status
ORDER BY avg_total_income DESC;


										--DETERMINE THE INFLUENCE OF HOUSING TYPE ON ELIGIBILITY
--4. How does the type of housing influence the Credit Card Eligibility?
	 --Calculate eligibility rates for each housing type

WITH t1 AS 
		 (SELECT housing_type,
				 CASE WHEN target = 1 THEN 1
				 END AS eligible
FROM creditcard_dataset)

SELECT DISTINCT housing_type,
				COUNT(housing_type) housing_type_count,
				COUNT(eligible) eligible_count,
				(COUNT(eligible) * 100) / COUNT(housing_type) percent_eligibility
FROM t1
WHERE housing_type IS NOT NULL
GROUP BY Housing_type
ORDER BY eligible_count DESC;
--Individuals living in House/Apartment housing type have a way higher eligibility count more than the other housing types. It is also important to note that 
--the reason why this is so is because there is a way higher count of individuals living in the House/Apartment house type that is way above the other housing
--types, hence the reason why there is a higher eligibility count. A percentage calculation will paint a better picture of which housing type is more eligible.
--On a percentage basis, Rented apartment has a higher percentage as per it's overall count. 


												--CAR OWNERSHIP AND FINANCIAL STABILITY
--5. Do individuals who own a car have higher financial stability and Credit Card Eligibility?
	 --Compare the Average total income and eligibility rates between car owners and non-car owners.

WITH t1 AS 
	(SELECT total_income,
		   CASE
		   WHEN target = 1 THEN 1
		   END AS eligible,
		   CASE
		   WHEN own_car = 1 THEN 'Owns car'
		   WHEN own_car = 0 THEN 'Not own car'
		   END AS car_possession,
		   CASE
		   WHEN own_car = 1 THEN 1
		   END AS own_car,
		   CASE
		   WHEN own_car = 0 THEN 1
		   END AS not_own_car
FROM creditcard_dataset)

SELECT DISTINCT car_possession,
				COUNT(eligible) eligible_count,
				ROUND(AVG(total_income), 0) average_income
FROM t1
WHERE car_possession IS NOT NULL AND eligible IS NOT NULL
GROUP BY car_possession
ORDER BY average_income DESC;
--It is funny to think, that those who do not own cars, have a lower total income on average, however has a Credit Card Eligibility count that is about double
--the eligibility count of those who own cars. 


												--EDUCATION LEVEL AND CREDIT CARD ELIGIBILITY
--6. How does education level impact credit card eligibility?
	 --Calculate the eligibility rates for each education type.

WITH t1 AS 
	   (SELECT education_type,
			   CASE
			   WHEN target = 1 THEN 1
			   END AS eligible
FROM creditcard_dataset)

SELECT DISTINCT education_type,
				COUNT(education_type) education_type_count,
				COUNT(eligible) eligible_count,
				(COUNT(eligible) * 100) / COUNT(education_type) AS eligible_percent
FROM t1
GROUP BY education_type
ORDER BY education_type_count DESC;
--This query shows something interesting. The most number of individuals are in the secondary/secondary special category. However, this group are among the lowest
--in the place of eligibility rate, expressed as a percentage of the overall count in each education category. The lowest count is the Academic category but
--with just 2 eligible count out of 6 total count, the eligibility rate expressed as a percent is much higher than every other category. 



											--PREDICTING ELIGIBILITY BASED ON YEARS EMPLOYED
--7. Can the number of years employed predict credit card eligibility?
	 --Analyze the correlation between years employed and target. What kind of proportion or relationship do they share?

WITH t1 AS 
	   (SELECT years_employed,
			   CASE
			   WHEN target = 1 THEN 1 
			   END AS eligible
FROM creditcard_dataset)

SELECT DISTINCT ROUND(years_employed, 0) years_employed			
FROM t1
ORDER BY years_employed;				
--It is possible to think that individuals having less than 1 year of employment history are more eligible than every other individuals that have worked longer. 
--However when we consider eligibility expressed as a percentage of the total count of each employed year, we find that individuals with less than 1 year of 
--employment has a mere 11 percent eligibility rate



											--EFFECT OF FAMILY SIZE ON CREDIT CARD ELIGIBILITY
--8. Does the number of children or family number affect Credit card eligibility?
	 --Compare the eligibility rates for different rates of Number of children and number of family.

SELECT
    Num_children,
    AVG(CASE WHEN Target = 1 THEN 1 ELSE 0 END) AS Eligibility_Rate
FROM
    creditcard_dataset
GROUP BY
    Num_children;

SELECT
    Num_family,
    AVG(CASE WHEN Target = 1 THEN 1 ELSE 0 END) AS Eligibility_Rate
FROM
    creditcard_dataset
GROUP BY
    Num_family;
	--There is little to show that the number of family or children that an individual has, impacts signigicantly on the individual's credit card eligibility. 


