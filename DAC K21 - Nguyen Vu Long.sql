-- Q1
/* - To handle the problem, first we use PARSE_DATE to change 'date' from string to date
   - Then, FORMAT_DATE to change the 'date' to desired format
   - By viewing the schema, it is clear that all the necessary fields can be selected from 'totals'. Use SUM() on each of those fields and GROUP BY month to calculate total visits, total pageviews and total transactions
   - The final query is as below  */
SELECT FORMAT_DATE("%Y%m", PARSE_DATE("%Y%m%d",date)) AS month 
      ,SUM(totals.visits) AS visits
      ,SUM(totals.pageviews) AS pageviews
      ,SUM(totals.transactions) AS transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`  
WHERE _table_suffix BETWEEN '0101' AND '0331'
GROUP BY month
ORDER BY month;
--correct

-- Q2
/* - Based the prolem, we first need to calculate the total visits and total bounces by using SUM() on total.visits and total.bounces
   - After that, total bounces divide by total visits and multiply 100.0 (since 100.0 is float) 
   - Filter by using HAVING to avoid the null values from total bounces (by testing) 
   - GROUP BY sources and ORDER BY total visits as required  */
SELECT trafficSource.source
      ,SUM(totals.visits) AS total_visits 
      ,SUM(totals.bounces) AS total_no_of_bounces  
      ,(SUM(totals.bounces)*100.0/ SUM(totals.visits)) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*` 
GROUP BY trafficSource.source 
HAVING SUM(totals.bounces) IS NOT NULL 
ORDER BY total_visits DESC;
--correct

-- Q3
/* - First, UNNEST hits and product to access productRevenue. Then, choose fields as required (date data is process as above)
   - Filter productRevenue to avoid obtaining null values. GROUP BY datetime and sources
   - The same logic is applied on 'month type_time'. Next, we UNION ALL the queries
   - Put the two queries inside a subquery of FROM and ORDER BY productRevenue (use ORDER BY after UNION ALL to avoid logical errors) */
SELECT * 
FROM 
      (SELECT 'week' AS type_time, 
            FORMAT_DATE('%Y%W',PARSE_DATE('%Y%m%d',date)) AS time, 
            trafficSource.source, 
            SUM(product.productRevenue)/1000000 AS Prd_Revenue 
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`, 
            UNNEST (hits) hits, 
            UNNEST (hits.product) product 
      WHERE product.productRevenue IS NOT NULL 
      GROUP BY FORMAT_DATE('%Y%W',PARSE_DATE('%Y%m%d',date)) 
            ,trafficSource.source 
UNION ALL 
      SELECT 'month' AS type_time 
            ,FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) AS time 
            ,trafficSource.source 
            ,SUM(product.productRevenue)/1000000 AS Prd_Revenue 
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`, 
            UNNEST (hits) hits, 
            UNNEST (hits.product) product 
      WHERE product.productRevenue IS NOT NULL 
      GROUP BY FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) 
            ,trafficSource.source) 
ORDER BY Prd_Revenue DESC;
--correct

-- Q4
/* -  Calculate number of pageviews by purchase type seperately by creating 2 tables
   -  In both tables, UNNEST the hits and product to access productRevenue
   -  Filter table suffix to limit the period of data (june and July). For purchaser, total transaction must be equal or greater than 1 and productRevenue is not null (because someone buys some item >>> there will be revenue and she creates at least 1 transaction - same logic is applied on non-purchaser)
   -  COUNT(DISTINCT visitorId) to make sure that number of user is unique (1 ID can make multiple transactions >>> create repetitions)
   -  Calculate average pageviews as required then join two tables by using time field (both tables are now the subqueries of FROM)
   -  SELECT required fields */
SELECT p1.time
      , p1.avg_pageviews_purchase
      , p2.avg_pageviews_non_purchase 
FROM ( 
            SELECT  
                  FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) AS time, 
                  SUM(Totals.pageviews)/COUNT(DISTINCT fullVisitorId) AS avg_pageviews_purchase,      
            FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`, 
                  UNNEST (hits) hits, 
                  UNNEST (hits.product) product 
            WHERE _table_suffix BETWEEN '0601' AND '0731' 
                  AND totals.transactions >=1 
                  AND productRevenue IS NOT NULL 
            GROUP BY  FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date))) AS p1 
 
LEFT JOIN ( 
            SELECT  
                  FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) AS time, 
                  SUM(Totals.pageviews)/count(distinct fullVisitorId) as avg_pageviews_non_purchase,      
            FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`, 
                  UNNEST (hits) hits, 
                  UNNEST (hits.product) product 
            WHERE _table_suffix BETWEEN '0601' AND '0731' 
                  AND totals.transactions IS NULL 
                  AND productRevenue IS NULL 
            GROUP BY  FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date))) AS p2 
ON p1.time = p2.time;

--cũng đc, nhưng cách ghi này nó sẽ ok khi e đang đi làm rồi
--câu 4 này lưu ý là mình nên dùng left join hoặc full join, bởi vì trong câu này, phạm vi chỉ từ tháng 6-7, nên chắc chắc sẽ có pur và nonpur của cả 2 tháng
--mình inner join thì vô tình nó sẽ ra đúng. nhưng nếu đề bài là 1 khoảng thời gian dài hơn, 2-3 năm chẳng hạn, nó cũng tháng chỉ có nonpur mà k có pur
--thì khi đó inner join nó sẽ làm mình bị mất data, thay vì hiện số của nonpur và pur thì nó để trống

-- Q5
/* -  Adjust the dataset to limit the period to only July. UNNEST the hits and product to access productRevenue
   -  As we are calculating the average total transactions/user, there shouldn't be any null values on productRevenue and the number of transaction should be at least equal to 1
   -  the average total transactions/user = total transactions/users
   -  COUNT(DISTINCT visitorId) to make sure that number of user is unique (1 ID can make multiple transactions >>> create repetitions) */
SELECT    
      FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) AS time, 
      SUM(totals.transactions)/count(distinct fullVisitorId) AS Avg_total_transactions_per_user 
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`, 
      UNNEST (hits) hits, 
      UNNEST (hits.product) product 
WHERE totals.transactions >=1 
      AND product.productRevenue IS NOT NULL 
GROUP BY 1 --FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date))
;


-- Q6 (result = xx.86 ¬ sample result = xx.85 - bit different)
/* -  Adjust the dataset to limit the period to only July. UNNEST the hits and product to access productRevenue
   -  There should be revenue and transactions per session as the users purchase something > Filter transaction and revenue is not null
   -  the average revenue by user/visit = (total revenue/total visits)/1000000
   -  Use ROUND to round up the results */
SELECT    
      FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) AS time, 
      ROUND((SUM(product.productRevenue)/COUNT(totals.visits))/1000000,2) AS avg_revenue_by_user_per_visit 
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`, 
      UNNEST (hits) hits, 
      UNNEST (hits.product) product 
WHERE totals.transactions IS NOT NULL 
      AND product.productRevenue IS NOT NULL 
GROUP BY 1 --FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date))
;


-- Q7
/* -  Adjust the dataset to limit the period to only July. UNNEST the hits and product to access productRevenue
   -  As we are calculating the average total transactions/user, there shouldn't be any null values on productRevenue and the number of transaction should be at least equal to 1
   -  Filter the Product name in subquery of WHERE customers purchase "YouTube Men's Vintage Henley"
   -  Outside the subquery, filter productname different from "YouTube Men's Vintage Henley" to obtain other products */
SELECT 
      product.v2ProductName, 
      SUM(product.productQuantity) AS Quantity 
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`, 
      UNNEST (hits) hits,   
      UNNEST (hits.product) product 
 
WHERE fullVisitorId IN ( 
                        SELECT fullVisitorId 
                        FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,   
                              UNNEST (hits) hits,   
                              UNNEST (hits.product) product 
                              WHERE product.v2ProductName="YouTube Men's Vintage Henley" 
                                    AND product.productRevenue IS NOT NULL AND totals.transactions >=1) 
      AND product.v2ProductName !="YouTube Men's Vintage Henley" 
      AND product.productRevenue IS NOT NULL 
      AND totals.transactions >=1 
GROUP BY product.v2ProductName 
ORDER BY Quantity DESC;
--correct

-- Q8
/* -  We will write 3 CTEs and join them to solve the problem. UNNEST the hits to access the action_type (In the 3rd CTE, it's essential to UNNEST the product to access the productRevenue since we need the condition to filter the purchase type)
   -  SELECT required fields and perform the calculation to obtain the results */
WITH p1 AS( 
      SELECT  
            FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d',date)) AS month, 
            COUNT(eCommerceAction.action_type) AS num_product_view 
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`, 
            UNNEST (hits) hits 
      WHERE _table_suffix BETWEEN '0101' AND '0331' 
            AND eCommerceAction.action_type = '2' 
      GROUP BY FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d',date))) 
 
,p2 AS( 
      SELECT  
            FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d',date)) AS month, 
            COUNT(eCommerceAction.action_type) AS num_addtocart 
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`, 
            UNNEST (hits) hits 
      WHERE _table_suffix BETWEEN '0101' AND '0331' 
            AND eCommerceAction.action_type = '3' 
      GROUP BY FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d',date))) 
 
,p3 AS( 
      SELECT  
            FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d',date)) AS month, 
            COUNT(eCommerceAction.action_type) AS num_purchase 
      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`, 
            UNNEST (hits) hits, 
            UNNEST (hits.product) product 
      WHERE _table_suffix BETWEEN '0101' AND '0331' 
            AND eCommerceAction.action_type = '6' 
            AND product.productRevenue IS NOT NULL 
      GROUP BY FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d',date))) 
 
 
SELECT 
      p1.*, p2.num_addtocart, p3.num_purchase, 
      ROUND((p2.num_addtocart/p1.num_product_view)*100.0,2) AS add_to_cart_rate, 
      ROUND((p3.num_purchase/p1.num_product_view)*100.0,2) AS purchase_rate 
FROM p1 
LEFT JOIN p2 
      USING (month) 
LEFT JOIN p3 
      USING (month) 
ORDER BY p1.month;

--bài yêu cầu tính số sản phầm, mình nên count productName hay productSKU thì sẽ hợp lý hơn là count action_type
--k nên xài inner join, nếu table1 có 10 record,table2 có 5 record,table3 có 1 record, thì sau khi inner join, output chỉ ra 1 record

--Cách 1:dùng CTE
with
product_view as(
SELECT
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  count(product.productSKU) as num_product_view
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
AND hits.eCommerceAction.action_type = '2'
GROUP BY 1
),

add_to_cart as(
SELECT
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  count(product.productSKU) as num_addtocart
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
AND hits.eCommerceAction.action_type = '3'
GROUP BY 1
),

purchase as(
SELECT
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  count(product.productSKU) as num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
AND hits.eCommerceAction.action_type = '6'
and product.productRevenue is not null   --phải thêm điều kiện này để đảm bảo có revenue
group by 1
)

select
    pv.*,
    num_addtocart,
    num_purchase,
    round(num_addtocart*100/num_product_view,2) as add_to_cart_rate,
    round(num_purchase*100/num_product_view,2) as purchase_rate
from product_view pv
left join add_to_cart a on pv.month = a.month
left join purchase p on pv.month = p.month
order by pv.month;

--bài này k nên inner join, vì nếu như bảng purchase k có data thì sẽ k mapping đc vs bảng productview, từ đó kết quả sẽ k có luôn, mình nên dùng left join

--Cách 2: bài này mình có thể dùng count(case when) hoặc sum(case when)

with product_data as(
select
    format_date('%Y%m', parse_date('%Y%m%d',date)) as month,
    count(CASE WHEN eCommerceAction.action_type = '2' THEN product.v2ProductName END) as num_product_view,
    count(CASE WHEN eCommerceAction.action_type = '3' THEN product.v2ProductName END) as num_add_to_cart,
    count(CASE WHEN eCommerceAction.action_type = '6' and product.productRevenue is not null THEN product.v2ProductName END) as num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
,UNNEST(hits) as hits
,UNNEST (hits.product) as product
where _table_suffix between '20170101' and '20170331'
and eCommerceAction.action_type in ('2','3','6')
group by month
order by month
)

select
    *,
    round(num_add_to_cart/num_product_view * 100, 2) as add_to_cart_rate,
    round(num_purchase/num_product_view * 100, 2) as purchase_rate
from product_data;



                                                      --very good---