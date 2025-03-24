USE insurance_db;

CREATE TABLE insurance (
    age INT,
    sex VARCHAR(10),
    bmi FLOAT,
    children INT,
    smoker VARCHAR(5),
    region VARCHAR(20),
    charges FLOAT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/insurance.csv'
INTO TABLE insurance
FIELDS TERMINATED BY ','  
IGNORE 1 ROWS;

-- DATA CLEANING--
-----------------------------

-- 1) Delete duplicate rows

SELECT COUNT(DISTINCT age, sex, bmi, children, smoker, region, charges) AS unique_rows
FROM insurance;
CREATE TABLE insurance_new AS
SELECT DISTINCT * FROM insurance;
ALTER TABLE insurance_dedup RENAME TO insurance;
SELECT COUNT(*) FROM insurance;

-- 2) Check for Null
SELECT*
FROM insurance
WHERE sex IS NULL
OR age IS NULL
OR bmi IS NULL
OR children IS NULL
OR smoker IS NULL
OR region IS NULL
OR charges IS NULL;
-- There are no null values here 
-- But if there were null values we could use
SET @avgbmi = (SELECT AVG(bmi) FROM insurance);
UPDATE insurance
SET bmi= @avgbmi
WHERE bmi IS NULL;

-- 3) Check for inconsistent entries
SELECT DISTINCT sex FROM insurance;
SELECT DISTINCT smoker FROM insurance;
SELECT DISTINCT region FROM insurance;

-- 4) Check for datatype
DESC insurance;

-- 5) Check for outliers
SELECT MIN(age),MAX(age) FROM insurance;
SELECT MIN(bmi),MAX(bmi) FROM insurance;
SELECT MIN(charges), MAX(charges) FROM insurance;
SELECT* FROM insurance WHERE bmi>60;
SELECT* FROM insurance WHERE charges>100000;

-- 7) Add Columns
ALTER TABLE insurance 
ADD COLUMN bmi_category VARCHAR(20),
ADD COLUMN age_category VARCHAR(20);
DESC insurance;

SET SQL_SAFE_UPDATES = 0;

UPDATE insurance
SET bmi_category = 
    CASE
        WHEN bmi < 18.5 THEN 'underweight'
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN 'normal weight'
        WHEN bmi BETWEEN 25 AND 29.9 THEN 'overweight'
        WHEN bmi >= 30 THEN 'obese'
    END,
    
    age_category = 
    CASE
        WHEN age BETWEEN 18 AND 30 THEN 'young'
        WHEN age BETWEEN 31 AND 50 THEN 'middle aged'
        ELSE 'senior citizen'
    END;

SELECT*
FROM insurance 
WHERE bmi_category IS NULL
OR age_category IS NULL;

SET @modeofbmi = (
	SELECT bmi_category
	FROM insurance
	GROUP BY bmi_category
    ORDER BY COUNT(*) DESC
    LIMIT 1);
UPDATE insurance
SET bmi_category = @modeofbmi
WHERE bmi_category IS NULL;


-- DATA ANALYSIS
-- -------------------------------------
-- 1) Impact of smoking on medical charges
SELECT smoker,
AVG(charges) AS avg_charges FROM insurance
GROUP BY smoker;

-- 2) BMI's impact on charges
SELECT bmi_category,
AVG(charges) AS avg_charges FROM insurance
GROUP BY bmi_category;

-- 3) Age and medical charges
SELECT age_category,
AVG(charges) AS avg_charges FROM insurance
GROUP BY age_category;

SELECT*
FROM insurance;

