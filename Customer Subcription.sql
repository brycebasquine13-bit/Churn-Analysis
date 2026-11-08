
-- How many customers are leaving each month?
-- Which customers are likely to leave? 
-- How muchs money is the business loosing because of it?

SELECT *
FROM customerschurnworking6;

SELECT signup_date
FROM customerschurnworking6;

SELECT COUNT(signup_date) as count_signup, STRFTIME('%m', signup_date) AS signup_month
FROM customerschurnworking6
GROUP BY signup_month;
-- Customer signup decreases by half during summer to early winter 


SELECT COUNT(signup_date) as cancelled_signup, STRFTIME('%m', signup_date) AS signup_month, active_cancelled
FROM customerschurnworking6
WHERE active_cancelled = 'cancelled'
GROUP BY signup_month;


SELECT
    month,
	COUNT(customer_id) AS total_subscriptions,
	SUM(CASE
        WHEN active_cancelled = 'cancelled' THEN 1
        ELSE 0
    	END) AS total_cancelled_subscriptions,
    ROUND(
        100.0 * SUM(CASE
            WHEN active_cancelled = 'cancelled' THEN 1
            ELSE 0
        	END) / COUNT(customer_id), 2
    ) 		AS cancellation_percentage
FROM customerschurnworking6
GROUP BY month;
-- Shows the percentage of customers leaving each month, 
--  we can see that the highest percentage of customers leave in July,
--  and the lowest percentage of customers leave in November. 

WITH cancel_percentage AS (
    SELECT
      month,
      COUNT(customer_id) AS total_subscriptions,
      SUM(CASE
          WHEN active_cancelled = 'cancelled' THEN 1
          ELSE 0
          END) AS total_cancelled_subscriptions,
      ROUND(
          100.0 * SUM(CASE
              WHEN active_cancelled = 'cancelled' THEN 1
              ELSE 0
              END) / COUNT(customer_id), 2
      ) 		AS cancellation_percentage
  FROM customerschurnworking6
  GROUP BY month
)
SELECT ROUND(AVG(cancellation_percentage),2) AS average_cancellation
FROM cancel_percentage;
-- On average we are loosing about 16.61% of our subscriptions each month. 



SELECT month,
        SUM(CASE 
            WHEN active_cancelled = 'cancelled' THEN 1
            ELSE 0
            END) AS total_cancelled,
         SUM(monthly_fee) AS revenue_lost
FROM customerschurnworking6
WHERE active_cancelled = 'cancelled'
GROUP BY month;
-- This shows how much revenue was lost by month


WITH average_loss AS(
    SELECT month,
          SUM(CASE 
              WHEN active_cancelled = 'cancelled' THEN 1
              ELSE 0
              END) AS total_cancelled,
           SUM(monthly_fee) AS revenue_lost
  FROM customerschurnworking6
  WHERE active_cancelled = 'cancelled'
  GROUP BY month
)
SELECT AVG(revenue_lost)
FROM average_loss;
-- On average we are loosing about $3500 of revenue from subscriptions each month. 





