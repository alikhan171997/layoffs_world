-- Data cleaning
select * from layoffs;
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove any Columns 
create table Layoffs_staging
like layoffs;
insert into Layoffs_staging 
select * from layoffs; 
with duplicate_cte as (
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, 'date',
 stage, country, funds_raised_millions) as row_num
 from layoffs_staging
)
select * from duplicate_cte
where row_num > 1;
select * from layoffs_staging
where company = 'casper';
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
select * from layoffs_staging2;
insert into layoffs_staging2 
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, 'date',
 stage, country, funds_raised_millions) as row_num
 from layoffs_staging;
 
 SET SQL_SAFE_UPDATES = 0;
delete from layoffs_staging2
where row_num > 1; 
select * from layoffs_staging2
where row_num > 1; 
select * from layoffs_staging2;
-- standardizing data
select company, (trim(company))
from layoffs_staging2;
update layoffs_staging2
set company = trim(company);
select distinct industry
from layoffs_staging2;
select * from layoffs_staging2 where industry like 'Crypto%';
update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%'; 
select distinct country from layoffs_staging2 order by 1;
select distinct country, trim(trailing '.' from country) from layoffs_staging2
order by 1;
update layoffs_staging2 
set country = trim(trailing '.' from country)
where country like 'United States%';
select `date`,
Str_To_Date(`date`, '%m/%d/%Y')
from layoffs_staging2;
update layoffs_staging2
set `date` = Str_To_Date(`date`, '%m/%d/%Y');
 alter table layoffs_staging2
 modify column `date` Date;
 
 select * from layoffs_staging2
 where total_laid_off is null and percentage_laid_off is null;
 
 
 select *
 from layoffs_staging2
 where industry is null or industry = '';
 
 select * from layoffs_staging2
 where company like 'Bally%';
 
 select T1.industry, T2.industry from layoffs_staging2 as T1
 join layoffs_staging2 as T2
 on T1.company = T2.company
 and T1.location = T2.location
 where (T1.industry is null or T1.industry = '')
 and T2.industry  is not null;
 
 update layoffs_staging2
 set industry = null 
 where industry = '';
 
 update layoffs_staging2 T1
 join layoffs_staging2 as T2
 on T1.company = T2.company
 set T1.industry = T2.industry
 where T1.industry is null
 and T2.industry  is not null;
 
select * from layoffs_staging2;
select * from layoffs_staging2
 where total_laid_off is null and percentage_laid_off is null;
 
 delete from layoffs_staging2 where total_laid_off is null
 and percentage_laid_off is null;
 
 
 Alter table layoffs_staging2
 drop column row_num;