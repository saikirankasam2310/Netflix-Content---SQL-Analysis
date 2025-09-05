-- Netflix Content SQL Analysis - queries.sql
-- Schema for netflix_titles (simplified)
DROP TABLE IF EXISTS netflix_titles;
CREATE TABLE netflix_titles (
  show_id VARCHAR(20) PRIMARY KEY,
  type VARCHAR(20),
  title VARCHAR(255),
  director VARCHAR(255),
  cast TEXT,
  country VARCHAR(255),
  date_added DATE,
  release_year INT,
  rating VARCHAR(20),
  duration VARCHAR(50),
  listed_in VARCHAR(255),
  description TEXT
);

-- 1) Count movies vs TV shows
SELECT type, COUNT(*) AS count FROM netflix_titles GROUP BY type;

-- 2) Top 10 countries by content count
SELECT country, COUNT(*) AS cnt FROM netflix_titles GROUP BY country ORDER BY cnt DESC LIMIT 10;

-- 3) Most common ratings
SELECT rating, COUNT(*) AS cnt FROM netflix_titles GROUP BY rating ORDER BY cnt DESC;

-- 4) Content added per year (based on date_added)
SELECT YEAR(date_added) AS yr, COUNT(*) AS added FROM netflix_titles GROUP BY yr ORDER BY yr;

-- 5) Top 10 directors by number of shows
SELECT director, COUNT(*) AS num_shows FROM netflix_titles WHERE director<>'' GROUP BY director ORDER BY num_shows DESC LIMIT 10;

-- 6) Shows with largest cast sizes (approx)
SELECT show_id, title, (LENGTH(cast)-LENGTH(REPLACE(cast, ',', ''))+1) AS cast_size FROM netflix_titles ORDER BY cast_size DESC LIMIT 10;

-- 7) Percentage split between Movies and TV Shows
SELECT type, ROUND(COUNT(*)/(SELECT COUNT(*) FROM netflix_titles)*100,2) AS pct FROM netflix_titles GROUP BY type;

-- 8) Content added by month-year
SELECT DATE_FORMAT(date_added, '%Y-%m') AS month, COUNT(*) AS added FROM netflix_titles GROUP BY month ORDER BY month;

-- 9) TV shows with more than 3 seasons
SELECT show_id, title, duration FROM netflix_titles WHERE type='TV Show' AND duration LIKE '%Season%' AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 3;

-- 10) Top 10 genre combinations (listed_in)
SELECT listed_in, COUNT(*) AS cnt FROM netflix_titles GROUP BY listed_in ORDER BY cnt DESC LIMIT 10;

-- 11) Most frequent directors (approximation)
SELECT director, COUNT(*) AS cnt FROM netflix_titles WHERE director<>'' GROUP BY director ORDER BY cnt DESC LIMIT 10;

-- 12) Longest movies (duration parsing)
SELECT show_id, title, CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS minutes FROM netflix_titles WHERE duration LIKE '%min' ORDER BY minutes DESC LIMIT 10;

-- 13) Average content release per year since 2010
SELECT release_year, COUNT(*) AS cnt FROM netflix_titles WHERE release_year >= 2010 GROUP BY release_year ORDER BY release_year;

-- 14) Top 10 most common genres in the last 5 years
SELECT listed_in, COUNT(*) AS cnt FROM netflix_titles WHERE release_year >= YEAR(CURDATE())-5 GROUP BY listed_in ORDER BY cnt DESC LIMIT 10;

-- 15) Year-over-year growth of titles added
SELECT YEAR(date_added) AS yr, COUNT(*) AS added,
       LAG(COUNT(*)) OVER (ORDER BY YEAR(date_added)) AS prev_year,
       ROUND((COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY YEAR(date_added)))/LAG(COUNT(*)) OVER (ORDER BY YEAR(date_added))*100,2) AS yoy_pct
FROM netflix_titles GROUP BY YEAR(date_added) ORDER BY yr;

-- End of queries
