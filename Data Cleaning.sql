-- Data Cleaning in SQL

Select *
From layoffs;

-- 1. Remove Duplicates.
-- 2. Standardize the data and fix errors (Correct Spellings, etc).
-- 3. Remove Null values and Blank values.
-- 4. Remove any Columns or Rows that are not necessary (probably those which are Null).

-- Creating a staging table to work in and clean the data.
Create Table layoffs_staging
Like layoffs;

Select *
From layoffs_staging;

-- Inserting same values as layoffs in layoffs_staging
Insert Into layoffs_staging
Select *
From layoffs;

-- 1. Removing Duplicates

Select *,
Row_Number() Over(Partition By company, industry, total_laid_off, percentage_laid_off, `date`) As row_num
From layoffs_staging;

With duplicate_cte As
(
Select *,
Row_Number() 
Over(Partition By company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
As row_num
From layoffs_staging
)
Select *
From duplicate_cte
Where row_num > 1;

Select *
From layoffs
Where company = 'Casper';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
From layoffs_staging2;

Insert Into layoffs_staging2
Select *,
Row_Number() 
Over(Partition By company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
As row_num
From layoffs_staging;

Select *
From layoffs_staging2
Where row_num > 1;

Delete
From layoffs_staging2
Where row_num > 1;


-- 2. Standardizing the data

Select company, TRIM(company)
From layoffs_staging2;

Update layoffs_staging2
Set company = TRIM(company);

Select Distinct(industry)
From layoffs_staging2
Order By 1;

Select *
From layoffs_staging2
Where industry Like 'Crypto%';

Update layoffs_staging2
Set industry = 'Crypto'
Where industry Like 'Crypto%';

Select Distinct(location)
From layoffs_staging2
Order By 1;

Select Distinct(country)
From layoffs_staging2
Order By 1;

Select *
From layoffs_staging2
Where country Like 'United States%';

Select Distinct(country), Trim(Trailing '.' From country)
From layoffs_staging2
Order By 1;

Update layoffs_staging2
Set country = Trim(Trailing '.' From country)
Where country Like 'United States%';

Select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
From layoffs_staging2;

Update layoffs_staging2
Set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

Alter Table layoffs_staging2
Modify Column `date` Date;


-- 3. Removing Null and Blank Values

Select *
From layoffs_staging2
Where industry IS NULL
OR industry = '';

Select *
From layoffs_staging2
Where company = 'Airbnb';

Select t1.industry, t2.industry
From layoffs_staging2 t1
JOIN layoffs_staging2 t2
	On t1.company = t2.company
    AND t1.location = t2.location
Where (t1.industry Is Null OR t1.industry = '')
AND t2.industry Is Not Null;

Update layoffs_staging2 t1
JOIN layoffs_staging2 t2
	On t1.company = t2.company
Set t1.industry = t2.industry
Where t1.industry Is Null
AND t2.industry Is Not Null;

Select *
From layoffs_staging2
Where company Like 'Bally%';


-- 4. Removing any columns or Rows (probably which are Null)

Select *
From layoffs_staging2
Where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

Delete
From layoffs_staging2
Where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

Select *
From layoffs_staging2;

Alter Table layoffs_staging2
Drop Column row_num;

Select *
From layoffs_staging2;