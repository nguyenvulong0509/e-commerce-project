# e-commerce-project
## This project aims to get the important metrics from the dataset of an e-commerce company by using SQL
I use the dataset from Google Bigquery "ga_sessions_20170801". Here is the link to table description: https://support.google.com/analytics/answer/3437719?hl=en
For more details about the results of the queries, please follow the link: https://console.cloud.google.com/bigquery?sq=693427545403:7febc104dbcf4647953c6d409d1b5263
The company wants to know about:
1. Total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
2. Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit - Order from the lastest month)
3. Revenue by traffic source by week, by month in June 2017
4. Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017
5. Average number of transactions per user that made a purchase in July 2017
6. Average amount of money spent per session. Only include purchaser data in July 2017
7. Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017.
8. Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017.
