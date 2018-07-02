--How many campaigns does CoolTShirts use? 
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

--How many source does CoolTShirts use? 
SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

--How are CoolTShirts campaigns and sources related?  
SELECT DISTINCT utm_campaign AS 'Marketing Campaign',
	utm_source AS 'Source'
FROM page_visits;

--What pages are on the CoolTShirts website?
SELECT DISTINCT page_name AS 'Page Name'
FROM page_visits;  



--How many first touches is each campaign responsible for?  
--The utm_source for each campaign is also identified in this query.

--How many first touches is each campaign responsible for?  
--The utm_source for each campaign is also identified in this query.

--Create a temporary table (first_touch) that identifies the timestamp 
--for each users first touch.
WITH first_touch AS (
   SELECT user_id,
          MIN(timestamp) as first_touch_at
   FROM page_visits
   GROUP BY user_id),
--Create a temporary table (ft_attribute) that combines source,
--campaign from page_visits table with user_id and first_touch_at from 
--first_touch,joined on user_id and timestamp.  This table enables the 
--source to be identified in the query results.
ft_attribute AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
--Count the rows where the first touch is associated with a source and 
--campaign. Order from highest to lowest count.
SELECT ft_attribute.utm_source AS 'Source',
       ft_attribute.utm_campaign AS 'Marketing Campaign',
       COUNT(*) AS 'Count'
FROM ft_attribute
GROUP BY 1, 2
ORDER BY 3 DESC;


--How many last touches is each campaign responsible for?  
--The utm_source for each campaign is also identified in this query.

--Create a temporary table (last_touch) that identifies the timestamp 
--for each users last touch.
WITH last_touch AS (
   SELECT user_id,
   	  MAX(timestamp) AS 'last_touch_at'
   FROM page_visits
   GROUP BY user_id),
--Create a temporary table (lt_attribute) that combines source,
--campaign from page_visits table with user_id and last_touch_at from 
--last_touch,joined on user_id and timestamp.  This table enables the 
--source to be identified in the query results.
lt_attribute AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
--Count the rows where the last touch is associated with a source and 
--campaign. Order from highest to lowest count.
SELECT lt_attribute.utm_source AS 'Source',
       lt_attribute.utm_campaign AS 'Marketing Campaign',
       COUNT(*) AS 'Count'
FROM lt_attribute
GROUP BY 1, 2
ORDER BY 3 DESC;

--How many visitors make a purchase?
--Count the distinct users who visited the page named 4 - purchase.
SELECT COUNT(DISTINCT user_id) AS 'Visitors that make a purchase'
FROM page_visits
WHERE page_name ='4 - purchase';

--How many last touches on the purchase page is each campaign responsible for?

--Create a temporary table (last_touch) that identifies the timestamp 
--for each users last touch.  This table now filters by last touches where the page 
--was '4 - purchase'
WITH last_touch AS (
  SELECT user_id,
    	 MAX(timestamp) AS 'last_touch_at'  
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
--Create a temporary table (lt_attribute) that combines source,
--campaign from page_visits table with user_id and last_touch_at from 
--last_touch,joined on user_id and timestamp.
lt_attribute AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
--Count the rows where the last touch is associated with a source and 
--campaign. Order from highest to lowest count.
SELECT lt_attribute.utm_source AS 'Source',
       lt_attribute.utm_campaign AS 'Marketing Campaign',
       COUNT(*) AS 'Count'
FROM lt_attribute
GROUP BY 1, 2
ORDER BY 3 DESC;
