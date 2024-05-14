-- Exploratory Data Analysis (EDA)

Select *
From layoffs_staging2;

Select MAX(total_laid_off), MAX(percentage_laid_off)
From layoffs_staging2;

Select *
From layoffs_staging2
Where percentage_laid_off = 1
Order By total_laid_off DESC;

Select *
From layoffs_staging2
Where percentage_laid_off = 1
Order By funds_raised_millions DESC;

-- Companies with the biggest single Layoff
Select company, total_laid_off
From layoffs_staging2
Order By 2 DESC
LIMIT 5;

-- Companies with the most Total Layoffs
Select company, SUM(total_laid_off)
From layoffs_staging2
Group By company
Order By 2 DESC
LIMIT 10;

Select MIN(`date`), MAX(`date`)
From layoffs_staging2;

Select industry, SUM(total_laid_off)
From layoffs_staging2
Group By industry
Order By 2 DESC;

Select industry, SUM(percentage_laid_off)
From layoffs_staging2
Group By industry
Order By 2 DESC;

Select company, SUM(percentage_laid_off)
From layoffs_staging2
Group By company
Order By 2 DESC;

Select country, SUM(total_laid_off)
From layoffs_staging2
Group By country
Order By 2 DESC;

Select `date`, SUM(total_laid_off)
From layoffs_staging2
Group By `date`
Order By 1 DESC;

Select Year(`date`), SUM(total_laid_off)
From layoffs_staging2
Group By Year(`date`)
Order By 1 DESC;

Select stage, SUM(total_laid_off)
From layoffs_staging2
Group By stage
Order By 2 DESC;

Select Substring(`date`, 6, 2) As `Month`, Sum(total_laid_off)
From layoffs_staging2
Group By `Month`;

-- Rolling Total of Layoffs Per Month
Select Substring(`date`, 1, 7) As `Dates`, Sum(total_laid_off) As total_laid_off
From layoffs_staging2
Where Substring(`date`, 1, 7) Is Not Null
Group By `Dates`
Order By 1 ASC;

With Rolling_Total As
(
Select Substring(`date`, 1, 7) As `Dates`, Sum(total_laid_off) As total_laid
From layoffs_staging2
Where Substring(`date`, 1, 7) Is Not Null
Group By `Dates`
Order By 1 ASC
)
Select `Dates`, total_laid, Sum(total_laid) Over(Order By `Dates`) As rolling_total
From Rolling_Total;


Select company, Year(`date`), SUM(total_laid_off)
From layoffs_staging2
Group By company, Year(`date`)
Order By company ASC;

Select company, Year(`date`), SUM(total_laid_off)
From layoffs_staging2
Group By company, Year(`date`)
Order By 3 DESC;

With Company_Year (company, years, total_laid_off) As
(
Select company, Year(`date`), SUM(total_laid_off)
From layoffs_staging2
Group By company, Year(`date`)
)
Select *, Dense_rank() Over(Partition By years Order By total_laid_off DESC) As Ranking
From Company_Year
Where years Is Not Null;

With Company_Year (company, years, total_laid_off) As
(
Select company, Year(`date`), SUM(total_laid_off)
From layoffs_staging2
Group By company, Year(`date`)
)
Select *, Dense_rank() Over(Partition By years Order By total_laid_off DESC) As Ranking
From Company_Year
Where years Is Not Null
Order By Ranking ASC;

With Company_Year (company, years, total_laid_off) As
(
Select company, Year(`date`), SUM(total_laid_off)
From layoffs_staging2
Group By company, Year(`date`)
), Company_Year_Rank As
(Select *, Dense_rank() Over(Partition By years Order By total_laid_off DESC) As Ranking
From Company_Year
Where years Is Not Null)
Select *
From Company_Year_Rank;

-- Looking at Companies with the most layoffs per year. 
With Company_Year (company, years, total_laid_off) As
(
Select company, Year(`date`), SUM(total_laid_off)
From layoffs_staging2
Group By company, Year(`date`)
), Company_Year_Rank As
(Select *, Dense_rank() Over(Partition By years Order By total_laid_off DESC) As Ranking
From Company_Year
Where years Is Not Null)
Select *
From Company_Year_Rank
Where Ranking <= 5
Order By years ASC, total_laid_off DESC;