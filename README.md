# 📊 End-to-End Business Revenue & Customer Retention Analysis (MySQL)

## 📌 Project Overview
This project analyzes multi-city business transactions to uncover revenue drivers, quantify financial losses from cancelled orders (revenue leakage), and segment customers into actionable marketing tiers using *MySQL*.

## 🗄️ Database Architecture
* *Customers Table:* Tracks customer profiles, city locations (Pune, Mumbai, Bengaluru, Delhi), and onboarding dates.
* *Sales Table:* Tracks order transactions, product categories (Software, Hardware, Consulting, Support), revenue, and order statuses (Completed vs. Cancelled).

## 🔍 Key Business Questions Solved
1. *Regional Revenue Performance:* Identified top revenue-generating cities using INNER JOIN and GROUP BY.
2. *Revenue Leakage Analysis:* Calculated total financial loss from cancelled orders across product categories.
3. *VIP Client Identification:* Ranked top-spending customers using ORDER BY and LIMIT.
4. *Customer Tier Segmentation:* Classified customers into *VIP, Regular, and Basic* tiers using CASE WHEN statements.
5. *City-Level Top Performers:* Used a *CTE (WITH)* and *RANK() Window Function* to extract the #1 customer in each city.
6. *Cancellation Rate Metrics:* Applied conditional aggregation to calculate exact cancellation percentages per category.
7. *Month-over-Month (MoM) Growth:* Used the *LAG() Window Function* to track monthly revenue growth trends.
8. *Automated Reporting:* Created a reusable *SQL View (Executive_Sales_Summary)* and a parameterized *Stored Procedure (GetCityPerformance)* for on-demand reporting.

## 💡 Key Business Insights
* *Top Markets:* Pune and Mumbai generate the highest completed revenue.
* *Revenue Leakage:* Cancelled orders resulted in *₹92,000* in lost revenue, driven primarily by a *66.67% cancellation rate in the Hardware category*.
* *Growth Spikes:* Monthly sales peaked with a *525% MoM growth* in April.

## 🛠️ Tools & SQL Concepts Used
* *Database:* MySQL Workbench
* *SQL Techniques:* Relational Schema Design (Primary & Foreign Keys), INNER JOIN, GROUP BY, CASE WHEN, CTEs (WITH), Window Functions (RANK(), LAG()), Views, and Stored Procedures.
