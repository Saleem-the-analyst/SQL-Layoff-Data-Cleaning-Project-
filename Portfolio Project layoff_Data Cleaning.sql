CREATE DATABASE Layoff;

SELECT *
FROM layoffs;

-- layoff TABLE DUPLUCATING with layoff_duplucates easy further changes not effected with layoff data


CREATE TABLE layoff_duplucates LIKE layoffs;

SELECT *
FROM layoff_duplucates;


INSERT layoff_duplucates
SELECT * FROM layoffs;


-- 1. Finding and Removing DUPLICATES in the columns
-- 2. Change unknow formats to poper STANDARDIZE of the DATA
-- 3. Identifing the  NULL VALUES OR BLANK VALUES to pull out 
-- 4. Finally Unwanted COLUMN OR ROWs Removing from the Table 


-- 1. REMOVE DUPLICATES

SELECT company,industry,total_laid_off,`date`,
		ROW_NUMBER() OVER(PARTITION BY company,industry,total_laid_off,`date`)
FROM
    layoff_duplucates;
    
    
-- ADDING ROW_NUMBERS TO company,industry,total_laid_off,`date` TO FIND DUPLUCATES

SELECT *
FROM (
		SELECT 	company,industry,total_laid_off,`date`,
				ROW_NUMBER() 
                OVER(PARTITION BY company,industry,total_laid_off,`date`) AS row_num
		FROM layoff_duplucates
	) AS Duplucates
    
WHERE row_num > 1;
-- WE GOT COUNTRYS > 1 BASCED ON ABOVE COLUMNS

-- Casper
-- Cazoo
-- Hibob
-- Oda
-- Oda
-- Terminus
-- Wildlife Studios
-- Yahoo


-- CHECKING EACH ROWS WHICH ARE DUPLUCATES > 1 BASCED ON ABOVE COLUMNS

SELECT *
FROM layoff_duplucates
WHERE company = 'Hibob';

-- AFTER CONFORMING THAT TO CHECKING ALL COLUMNS TO GET ACCURATE OUTPUT

SELECT *
FROM (
		SELECT 	company,location,industry,total_laid_off,percentage_laid_off,
				`date`,stage,country,funds_raised_millions,
				ROW_NUMBER() 
							OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,
												`date`,stage,country,funds_raised_millions
								) AS row_num
		FROM layoff_duplucates
	) AS Duplucates
;


-- WE GOT COUNTRYS > 1 BASCED ON ALL COLUMNS

-- Casper
-- Cazoo
-- Hibob
-- Wildlife Studios
-- Yahoo

-- Here i got an idea acctual returned output pull into new table  `layoff_duplicates2`
-- NOW  the query write like this 
-- Create Duplicate table of `layoff_duplicates` to `layoff_duplicates2` 
-- add new `row_num` column in `layoff_duplicate` 


ALTER TABLE layoff_duplucates ADD row_num INT;

-- using create statement to return same column from the `layoff_duplicates` table

CREATE TABLE `layoff_duplucates2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` double DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoff_duplucates2;

-- here we inserting data basced on `layoff_duplucates` columns and addtionaly add `row_number function` to `row_num` column to return selected column duplicates rows 

INSERT INTO layoff.layoff_duplucates2
(company,
location,
industry,
total_laid_off,
percentage_laid_off,
`date`,
stage,
country,
funds_raised_millions,
row_num)
SELECT 	
company,
location,
industry,
total_laid_off,
percentage_laid_off,
`date`,
stage,
country,
funds_raised_millions,
ROW_NUMBER() 
			OVER(PARTITION BY 	company,location,industry,total_laid_off,percentage_laid_off,
								`date`,stage,country,funds_raised_millions
				) AS row_num 
FROM layoff.layoff_duplucates;


-- Now to re-verify to find row_num > 1
SELECT *
FROM layoff_duplucates2
WHERE row_num > 1;

-- now that we have this we can delete rows where row_num is greater than 1

DELETE
FROM layoff_duplucates2
WHERE row_num > 1;

SELECT *
FROM layoff_duplucates2
WHERE row_num > 1;



-- 2. STANDARDIZE THE DATA

SELECT DISTINCT COUNTRY
FROM layoff_duplucates2
ORDER BY 1;

-- here we got 'UNITED STATES' and some Like 'UNITED STATES.'  

SELECT *
FROM layoff_duplucates2
WHERE COUNTRY LIKE 'United%';

-- Now UPDATE with `TRAILING` to remove '.' from 'UNITED STATES.' in country column

UPDATE layoff_duplucates2
SET country= TRIM(TRAILING '.' FROM country);



-- using `Trim` to remove unwanted space from the `company` column

UPDATE layoff_duplucates2
SET company = TRIM(company);



-- Have any `BLANKS` or `NULL` in Industry Column

select industry
from layoff_duplucates2
order by 1;

-- Finding both `BLANKS` or `NULL` to pull out from the INDUSTRY 

select *
from layoff_duplucates2
where industry is null or industry = ''
order by industry;

-- Identifying with similer rows to which Industry

select *
from layoff_duplucates2
-- where company = "Bally's Interactive" and location = 'Providence'; 	-- Not there  
-- where company = "Airbnb" and location = 'SF Bay Area'; 				-- `Travel`- Industry
-- where company = "Carvana" and location = 'Phoenix'; 					-- `Transport` - Industry
where company = "Juul" and location = 'SF Bay Area';					-- `Consumer` - Industry

-- UPDATING with `BLANKS` rows to NULL  

UPDATE layoff_duplucates2
SET industry = null
WHERE industry = '';

-- UPDATE tO Join with Populate Similer INDUSTRY to them

UPDATE layoff_duplucates2 AS ld
JOIN layoff_duplucates2 AS ld2
ON ld.company = ld2.company
SET ld.industry = ld2.industry
WHERE 	ld.industry IS NULL 
	AND ld2.industry IS NOT NULL;


-- Here in Industry column we find out different `Crypto` names 
SELECT distinct industry
FROM layoff_duplucates2
ORDER BY industry;

-- Changing Industry where 'Crypto Currency' AND 'CryptoCurrency' to 'Crypto'
SELECT *
FROM layoff_duplucates2
where industry like 'Crypto%'
ORDER BY industry;

-- updating the 'Crypto%' to `Crypto`

UPDATE layoff_duplucates2
SET industry = 'Crypto'
where industry Like 'Crypto%';



SELECT *
FROM layoff_duplucates2
;

-- CHANGING DATE FORMATE
-- we can use str to date to update this field

UPDATE layoff_duplucates2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- here we modify the date formate with date data_type 

ALTER TABLE layoff_duplucates2
MODIFY COLUMN `date` DATE;


-- 3. REMOVING NULL values or BLANK Values

-- In total_laid_off and percentage_laid_off finding Null values
SELECT *
FROM layoff_duplucates2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- 361 ROWS EFFECTED 

-- DELETING USELESS NULL ROWS FROM `TOTAL_LAID_OFF` AND `PERCENTAGE_LAID_OFF` COLUMNS

DELETE
FROM layoff_duplucates2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- 1995 ROWS RETURNED

SELECT *
FROM layoff_duplucates2;

-- 4. Remove any un wanted Columns or Rows from the table 

-- remove `row_num` column from the table

ALTER TABLE layoff_duplucates2
DROP COLUMN row_num;


-- FIANALLY DATA CLEANING PROCESS IS COMPLETED.../-- 




