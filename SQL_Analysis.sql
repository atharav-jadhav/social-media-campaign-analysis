DROP TABLE IF EXISTS social_media_campaign;


CREATE TABLE social_media_campaign (

    user_id VARCHAR(10),
    age INT,
    gender VARCHAR(10),
    location VARCHAR(50),
    interests VARCHAR(100),

    ad_id VARCHAR(10),
    ad_category VARCHAR(50),
    ad_platform VARCHAR(50),
    ad_type VARCHAR(50),

    impressions INT,
    clicks INT,
    conversion INT,

    time_spent_on_ad DECIMAL(5,2),

    day_of_week VARCHAR(15),
    device_type VARCHAR(20),

    engagement_score DECIMAL(5,2)

);


SELECT * FROM social_media_campaign

-- understanding the data

SELECT COUNT(*) 
FROM social_media_campaign

SELECT DISTINCT ad_platform
from social_media_campaign

SELECT DISTINCT gender 
from social_media_campaign

SELECT DISTINCT location
from social_media_campaign


--Main Business Problem
--How can a company improve social media ad campaign performance and user engagement?

--1. PLATFORM PERFORMANCE ANALYSIS

--Q1. Which social media platform generates the highest total number of clicks?

SELECT ad_platform , SUM(clicks) as total_clicks
from social_media_campaign
GROUP BY ad_platform
ORDER BY 2 DESC 
LIMIT 1;

-- Instagram is the platform generates the highest total number of clicks

-- Q2. Which platform has the highest average engagement score?

SELECT ad_platform , AVG(engagement_score) as "Average Score"
FROM social_media_campaign
GROUP BY ad_platform
ORDER BY 2 DESC
LIMIT 1;

-- Instagram is the platform has the highest average engagement score

-- Q3. Which platform achieves the highest conversion rate?

SELECT 
ad_platform,
SUM(conversion) * 1.0 / SUM(clicks) AS conversion_rate
FROM social_media_campaign
GROUP BY ad_platform
ORDER BY conversion_rate DESC
LIMIT 1;

---- Instagram is the platform achieves the highest conversion rate

-- Q4. Compare impressions and clicks across platforms to evaluate audience interaction levels.

SELECT 
    ad_platform,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr_percentage
FROM social_media_campaign
GROUP BY ad_platform
ORDER BY ctr_percentage DESC;

-- instagram audience interaction level is more than facebook

-- Q5. Which platform performs best for specific ad types such as Video or Image ads?


SELECT ad_platform ,ad_type, AVG(engagement_score)
from social_media_campaign
GROUP BY 1,2
ORDER BY 3 DESC

--for both instagram and facebook Image ads perform best , but rather than image for instagram video and for facebook carousel is best 


/* Insight : Campaign SHould focus on Instagram ads , because it is best across all things it also has more conversion rate
images and video way of ads works best viewers gets engage */


-- =========================================================
-- 2. AUDIENCE BEHAVIOR ANALYSIS


-- Q1. Which age groups show the highest engagement with social media advertisements?

SELECT 
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END AS age_group,
    
    AVG(engagement_score) AS avg_engagement
FROM social_media_campaign
GROUP BY age_group
ORDER BY avg_engagement DESC;

-- age groups '25-34' show the highest engagement with social media advertisements


-- Q2. How does engagement vary between male and female users?

SELECT gender , AVG(engagement_score) AS "AVG Engagement"
FROM social_media_campaign
GROUP BY gender
ORDER BY "AVG Engagement" DESC

-- Females are more engage as compared to male

-- Q3. Which user interests generate the highest clicks, conversions, and engagement?

SELECT * from social_media_campaign

SELECT 
interests,
SUM(clicks) AS total_clicks,
SUM(conversion) AS total_conversions,
AVG(engagement_score) AS avg_engagement
FROM social_media_campaign
GROUP BY interests
ORDER BY total_clicks DESC;

-- tech user interests generate the highest clicks, conversions, and engagement

-- Q4. Which locations contain the most active and highly engaged users?



SELECT location , AVG(time_spent_on_ad) as avg_time,AVG(engagement_score) as avg_engagement
from social_media_campaign
GROUP BY location
order by avg_time DESC , avg_engagement DESC


-- Q5. Analyze engagement patterns across different demographic segments such as age, gender,and interests.

SELECt * from social_media_campaign

SELECT 
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END AS age_group,
	gender,interests,
    
    ROUND(AVG(engagement_score),2) AS avg_engagement
FROM social_media_campaign
GROUP BY age_group,gender,interests
ORDER BY avg_engagement DESC;

/*Engagement is strongest among younger audiences (18–34), especially for lifestyle and entertainment
content like Travel, Fashion, and Gaming, while Tech content underperforms across most demographics.*/
/* people with other gender with interest travel , fashion , gaming has highest avg engagement*/

/**Male users:
Strong in:
Food (18–24)
Gaming (younger segments)
Weak in:
Travel (very low in 25–34, 35–44)

Female users:
Strong in:
Fashion
Food
Weak in:
Tech (very low in 18–24)*/


-- =========================================================
-- 3. AD STRATEGY ANALYSIS

-- Q1. Which ad category generates the highest engagement?

SELECT ad_category , ROUND(AVG(engagement_score),2) as avg_engagement
FROM social_media_campaign
GROUP BY ad_category
ORDER BY avg_engagement DESC

--Sportswear advertisements generated the highest average engagement, indicating stronger audience interaction compared to other ad categories.

-- Q2. Compare the performance of different adtype

SELECT 
    ad_type,
    ROUND(AVG(clicks), 2) AS avg_clicks,
    ROUND(AVG(impressions), 2) AS avg_impressions,
    SUM(conversion) AS total_conversions,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score,
    ROUND(SUM(conversion) * 100.0 / SUM(clicks), 2) AS conversion_rate
FROM social_media_campaign
GROUP BY ad_type
ORDER BY avg_engagement_score DESC,conversion_rate DESC;

/*Image ads generated the highest engagement
levels, while Carousel ads achieved slightly
better conversion rates, suggesting that
different ad formats may serve different
marketing objectives.*/

-- Q3. Which device type contributes the highest clicks and conversions?

SELECT device_type ,
SUM(clicks) AS total_clicks,
SUM(conversion) AS total_conversion
FRom social_media_campaign
GROUP BY device_type
ORDER BY total_conversion DESC

/*Mobile users generated the highest number
of clicks, indicating stronger interaction
volume, while Desktop users achieved the
highest conversions, suggesting higher
purchase intent or decision-making behavior.*/

-- Q4. Which ad strategy performs best across different platforms?

SELECT 
    ad_platform,
    ad_type,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr_percentage
FROM social_media_campaign
GROUP BY ad_platform, ad_type
ORDER BY ctr_percentage DESC;

/*Instagram Image ads achieved the highest
CTR, indicating that visual content performs
particularly well on Instagram compared to
other platform and ad type combinations.*/

-- Q5. Analyze the relationship between impressions,clicks, and conversions.


SELECT 
    ad_platform,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversion) AS conversions,

    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr_percentage,

    ROUND(SUM(conversion) * 100.0 / SUM(clicks), 2) AS conversion_rate_percentage

FROM social_media_campaign
GROUP BY ad_platform
ORDER BY conversion_rate_percentage DESC;

/*Instagram consistently outperformed Facebook
in both CTR and conversion rate, indicating
stronger audience engagement and more
effective campaign performance.*/



========================================
-- 4. ENGAGEMENT TREND ANALYSIS

--Q1. Which days of the week generate the highest audience engagement and interaction?

SELECT 
    day_of_week,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(time_spent_on_ad), 2) AS avg_time_spent,
    ROUND(AVG(clicks), 2) AS avg_clicks,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr_percentage
FROM social_media_campaign
GROUP BY day_of_week
ORDER BY avg_engagement_score DESC;

/*Wednesday showed the highest average engagement,
while Sunday achieved the strongest CTR, indicating
higher audience interaction and campaign responsiveness
during these periods.*/

--Q2. Does higher time spent on advertisements lead to better engagement and conversions?

SELECT 
    CASE 
        WHEN time_spent_on_ad < 10 THEN 'Low Time'
        WHEN time_spent_on_ad BETWEEN 10 AND 20 THEN 'Medium Time'
        ELSE 'High Time'
    END AS time_category,

    ROUND(AVG(engagement_score), 2) AS avg_engagement_score,
    
    ROUND(AVG(conversion) * 100, 2) AS conversion_rate

FROM social_media_campaign
GROUP BY time_category
ORDER BY avg_engagement_score DESC;

/*Users who spent more time viewing advertisements
demonstrated higher engagement scores and better
conversion rates, suggesting a positive relationship
between ad attention and campaign effectiveness.*/

--Q3. How do engagement patterns vary across different device types and platforms?

SELECT 
    ad_platform,device_type,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(time_spent_on_ad), 2) AS avg_time_spent,
    ROUND(AVG(clicks), 2) AS avg_clicks,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr_percentage
FROM social_media_campaign
GROUP BY ad_platform,device_type
ORDER BY ad_platform DESC,avg_engagement_score DESC;

/*Instagram generally performs better than Facebook in engagement.
Mobile users engage more on Instagram.
Tablet users show stronger click-through behavior.
Facebook Mobile campaigns may need optimization.*/


--Q4. Which factors appear to influence campaign performance and user engagement the most?


SELECT 
    ad_platform,
    ROUND(AVG(engagement_score),2) AS avg_engagement,
    ROUND(AVG(conversion) * 100,2) AS conversion_rate,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions),2) AS ctr
FROM social_media_campaign
GROUP BY ad_platform
ORDER BY avg_engagement DESC;

SELECT 
    device_type,
    ROUND(AVG(engagement_score),2) AS avg_engagement,
    ROUND(AVG(conversion) * 100,2) AS conversion_rate
FROM social_media_campaign
GROUP BY device_type
ORDER BY avg_engagement DESC;

SELECT 
    ad_type,
    ROUND(AVG(engagement_score),2) AS avg_engagement,
    ROUND(AVG(conversion) * 100,2) AS conversion_rate
FROM social_media_campaign
GROUP BY ad_type
ORDER BY avg_engagement DESC;

SELECT 
    ad_category,
    ROUND(AVG(engagement_score),2) AS avg_engagement,
    ROUND(AVG(conversion) * 100,2) AS conversion_rate
FROM social_media_campaign
GROUP BY ad_category
ORDER BY avg_engagement DESC;

/*Ad Category — especially Sportswear campaigns
Ad Type — Image ads outperform other formats
Ad Platform — Instagram generates stronger engagement than Facebook
Device Type — has moderate impact, mainly on conversion behavior*/
/*Ad category, ad type, and platform showed
stronger influence on engagement performance,
while device type had comparatively smaller
variation in engagement metrics.*/

