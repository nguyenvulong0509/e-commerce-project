# e-commerce-project
## This project aims to get the important metrics from the dataset of an e-commerce company by using SQL

### Dataset
I use the dataset from Google Bigquery "ga_sessions_20170801". Here is the link to table description: https://support.google.com/analytics/answer/3437719?hl=en
To access the dataset: 
- Log in to your Google Cloud Platform account and create a new project.
- Navigate to the BigQuery console and select your newly created project.
- In the navigation panel, select "Add Data" and then "Search a project".
- Enter the project ID "bigquery-public-data.google_analytics_sample.ga_sessions" and click "Enter".
- Click on the "ga_sessions_" table to open it.

### Business questions
The company wants to know about:
1. Total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
2. Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit - Order from the lastest month)
3. Revenue by traffic source by week, by month in June 2017
4. Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017
5. Average number of transactions per user that made a purchase in July 2017
6. Average amount of money spent per session. Only include purchaser data in July 2017
7. Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017.
8. Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017.

### Exploring the dataset
For more details about the results of the queries, please follow the link: https://console.cloud.google.com/bigquery?sq=693427545403:7febc104dbcf4647953c6d409d1b5263
1. Total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
   
   <img width="368" alt="Q1" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/2136c095-50b4-4d9e-ba58-7d9e306955de">

   
   - Result:
   
   <img width="471" alt="R1" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/6bfbe2ac-646f-4432-9355-3090b88e3183">

2. Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit - Order from the lastest month)

   <img width="385" alt="Q2" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/8d9fc5df-8faf-4179-b089-05de257c8ea0">


   - Result:
  
   <img width="473" alt="R2" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/5132ce13-c99b-466d-a4b5-f3be5c034351">

3. Revenue by traffic source by week, by month in June 2017

    <img width="423" alt="Q3" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/ca551f89-4e19-4026-a670-f853d7e54501">


   - Result:

    <img width="586" alt="R3" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/4773e802-83d5-4712-931c-51e41c97cc22">

4. Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017

   <img width="542" alt="Q4" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/6f4d5a50-a269-4bbd-9a0a-b3e9e2d29238">

   - Result:

   <img width="380" alt="R4" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/e910a1d8-51a3-4f4e-952e-881a4563d594">

5. Average number of transactions per user that made a purchase in July 2017

   <img width="516" alt="Q5" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/89e95157-ef7b-4804-ad30-fab73e984097">

   - Result:
  
   <img width="287" alt="R5" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/6f9f9fa9-7dfb-41ae-be4c-206eee345536">

6. Average amount of money spent per session. Only include purchaser data in July 2017

   <img width="574" alt="Q6" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/cc58d651-25ac-4e1f-8478-a9ff20802486">

   - Result:
  
   <img width="287" alt="R6" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/508cec18-54f6-44eb-9215-f0e2d4832356">

7. Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017.

   <img width="559" alt="Q7" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/2bcc7a9f-9511-45da-933d-9bd6c9548651">

   - Result:
  
   <img width="289" alt="R7" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/e0bce2cb-ab13-4f0b-98ce-4eca2c8cc36b">

8. Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017.

   - <img width="354" alt="Q8 1" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/c6b38bff-c5ca-43a7-a137-6c41da92a2cd">

   - <img width="369" alt="Q8 2" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/4dba6828-e8d4-4b2e-80e9-c4614466dcb2">

   - Result:
  
   <img width="661" alt="R8" src="https://github.com/nguyenvulong0509/e-commerce-project/assets/116187817/888e6767-7c31-446e-b654-cc7f821388c2">


### Conclusion
- In conclusion, my exploration of the eCommerce dataset using SQL on Google BigQuery based on the Google Analytics dataset has revealed several interesting insights.
- By exploring eCommerce dataset, I have gained valuable information about total visits, pageview, transactions, bounce rate, and revenue per traffic source,.... which could inform future business decisions.
- To deep dive into the insights and key trends, the next step will visualize the data with some software like Power BI,Tableau,...
- Overall, this project has demonstrated the power of using SQL and big data tools like Google BigQuery to gain insights into large datasets.
















