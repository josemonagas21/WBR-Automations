-- monthly usert type 2 data 
-- USER TYPE MBR 

WITH base AS (
  SELECT 
      DATE_TRUNC(c.date, MONTH) AS date,
      user_type_2,
      COUNT(DISTINCT c.user_id) AS users,
      COUNT(c.pageview_id) AS pageviews,
      SUM(pclicks) AS clicks,
      COUNT(DISTINCT concat(session_index,c.agent_id)) as sessions


  FROM  `nyt-bigquery-beta-workspace.wirecutter_data.channel` c
      LEFT JOIN `nyt-bigquery-beta-workspace.wirecutter_data.user_type` ut ON ut.pageview_id = c.pageview_id
      LEFT JOIN `nyt-bigquery-beta-workspace.stuart_data.wc_clicks`  pc ON pc.pageview_id = c.pageview_id

WHERE c.date BETWEEN '2020-06-01' AND '2023-01-31'
GROUP BY 1,2
)


SELECT 
      * 
FROM base
WHERE user_type_2 IS NOT NULL 
ORDER BY 1, CASE 
                WHEN user_type_2 = "Single Product Sub" THEN 1
                WHEN user_type_2 = "Multi Product Sub" THEN 2
                WHEN user_type_2 = "Regi" THEN 3
                WHEN user_type_2 = "Bundle Sub" THEN 4
                WHEN user_type_2 = "Wirecutter Sub" THEN 5
                WHEN user_type_2 = "Bundle Wirecutter Sub" THEN 6
                ELSE 7 END 