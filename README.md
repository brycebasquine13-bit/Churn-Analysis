# Churn Analysis Project



## Project Overview
This customer churn analysis project focuses on analyzing subscription data using SQL, Excel, and Tableau to identify trends in customer cancellations and retention. The project examines monthly cancellation rates, subscription plan performance, customer tenure, and revenue losses to uncover patterns in customer behavior. The goal is to use data-driven insights to better understand customer churn and help businesses improve customer retention and make informed decisions.



## Project Objective
- Identify patterns in customer acquisition costs and subscription performance.
- Analyze customer subscription data to identify trends in cancellations and customer retention.
- Calculate monthly customer churn rates and identify months with the highest cancellation activity.
- Compare cancellation rates across different subscription plans.
- Develop interactive Tableau dashboards to visualize findings and communicate actionable business insights.



## Key Questions Answered 
- How many customers are leaving each month?
- Which customers are likely to leave? 
- How much money is the business loosing because of it?
- How much money are we loosing each month?



## Dataset Description
This dataset simulates data from a SaaS (Software as a Service) business, including customer profiles, subscription plans, acquisition costs, monthly fees, and revenue details. 



## Tools Used
- SQL (SQLite)
- Excel
- Tableau



## SQL Queries
### Q1: What percentage of customers are leaving each month?
``` sql
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
```

### Q2: On average, how much revenue are we loosing each month?
``` sql
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
```

### Q3: On average, what percentage of subscriptions are we loosing each month?
``` sql
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
```

### Q4: How many subscriptions are being cancelled each month?
``` sql
SELECT COUNT(signup_date) as cancelled_signup, STRFTIME('%m', signup_date) AS signup_month, active_cancelled
FROM customerschurnworking6
WHERE active_cancelled = 'cancelled'
GROUP BY signup_month;
```



## Excel Sample
- This Excel Pivot Table shows the percentage of customers that have an active or cancelled subscription for each month. 
<img width="602" height="366" alt="image" src="https://github.com/user-attachments/assets/4019f076-c268-4338-8fa0-80574759a1e2" />



## Tableau Dashboard
- This dashboard shows:
- Active vs. Cancelled Subscriptions: Active subscriptions significantly outnumber cancelled subscriptions across all 12 months.
- Cancellation Trends: Cancellation counts are generally higher during the first half of the year, with some fluctuations throughout the year.
- Revenue Gain/Loss: Active subscriptions generate $207,950 in monthly fees, while cancelled subscriptions account for $42,000 in lost monthly revenue.
- Total Subscriptions: The dataset contains 1,000 subscriptions, with 832 active customers and 168 cancelled customers.
- Revenue Decline: Monthly revenue decreases noticeably beginning in July, reaching its lowest point in September before gradually recovering.
<img width="602" height="366" alt="image" src="https://github.com/user-attachments/assets/39559b89-e10c-4fe5-b673-e23d0dea8283" />



## Key Insights
- Customer signup decreases by half during summer to early winter.
- The highest percentage of customers leave in July, and the lowest percentage of customers leave in November.
- On average we are loosing about 16.61% of our subscriptions each month.
- On average we are loosing about $3500 of revenue from subscriptions each month.
- The Enterprise plan type generates the most revenue.
- The Basic plan type has the most cancellations. 

