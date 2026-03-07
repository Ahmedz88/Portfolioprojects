-- SQL Project - Data Cleaning
-- 1. Create new table for cleaning data
-- 2. Remove duPlicates
-- 3. Standardize the data
-- 4. Null values or blank values
-- 5. Remove any columns

SELECT * 
FROM layoffs;

-- 1. Create a staging table
CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT * 
FROM layoffs_staging;

-- 2. Remove duPlicates
-- If we have unique row id  for each row it will be easy to remove duplicates, here no identifying factor so we should identify row numbers, if number more than 1 that means there is duplicates
SELECT *,
ROW_NUMBER() over(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Create CTE
WITH Duplicate_CTE AS
(SELECT *,
ROW_NUMBER() over(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM Duplicate_CTE
WHERE row_num > 1;

-- Check oda and casper
SELECT *
FROM layoffs_staging
WHERE company = 'Oda';
SELECT *
FROM layoffs_staging
WHERE company = 'casper';

-- Delete here not working
WITH Duplicate_CTE AS
(SELECT *,
ROW_NUMBER() over(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM Duplicate_CTE
WHERE row_num > 1;

-- Will create new table to delete duplicates and add new column as row_num

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table still eampty, we need to insert data from provious table, after adding row_num
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() over(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- The new table here
SELECT *
FROM layoffs_staging2;

-- The new table where row number >1
SELECT *
FROM layoffs_staging2
WHERE row_num>1;

-- Now delete from new table where row number>1
DELETE
FROM layoffs_staging2
WHERE row_num>1;

-- Check after deleting if there are any rows still > 1, the result is nothing
SELECT *
FROM layoffs_staging2
WHERE row_num>1;

-- Note that after deleting if will run any query will give the same result after deleting even if delete query line removed, No undo after deleting
-- Now duplicates removed
-----------------------------------------------------------------------
-- 3. Standardize the data
-- 3.1 Company
SELECT DISTINCT trim(company)
FROM layoffs_staging2;
UPDATE layoffs_staging2
SET company = trim(company);
----------------------------------------------------------------------
-- 3.2 Location
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;
UPDATE layoffs_staging2
SET location = 'Dusseldorf'
WHERE location LIKE 'Dأ¼sseldorf';
UPDATE layoffs_staging2
SET location = 'Florianopolis'
WHERE location LIKE 'Florianأ³polis';
UPDATE layoffs_staging2
SET location = 'Malmo'
WHERE location LIKE 'Malmأ¶';
-------------------------------------------------------------------------------
-- 3.3 Industry
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-------------------------------------------------------------------------------
-- 3.4 Country
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States.%';
-------------------------------------------------------------------------------
-- 3.5 `Date`
SELECT `date`
from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
------------------------------------------------------------------
-- 4. Null values or blank values

SELECT  *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging
WHERE company = 'Airbnb';
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- Set the blanks to nulls
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Populate data
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

---------------------------------------------------------------------
-- 5. Remove any columns
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off is NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off is NULL;

SELECT *
FROM layoffs_staging2;





