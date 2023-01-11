
-- DATA IS STORED IN `nyt-bigquery-beta-workspace.jose_data.wbr-device` 

WITH base AS (

         SELECT 
                DISTINCT
            DATE_TRUNC(DATE(_pt), WEEK(monday)) + 6 AS week_end,
            CASE 
                WHEN agent.device.is_mobile IS TRUE AND agent.device.is_tablet IS FALSE AND source_app = 'amp-wirecutter' THEN "Mobile Amp"
                WHEN agent.device.is_mobile IS TRUE AND agent.device.is_tablet IS FALSE AND source_app = 'wirecutter' THEN "Mobile Web" 
                WHEN agent.device.is_computer IS TRUE THEN "Desktop" 
                WHEN agent.device.is_tablet IS TRUE THEN "Tablet" END AS device,
            CASE
                WHEN combined_regi_id IS NULL THEN agent_id
                ELSE cast(combined_regi_id as string) END AS users,
                CONCAT(COALESCE(cast(combined_regi_id AS STRING),agent_id),'-',session_index) AS session_id,
            pageview_id 
            
        FROM `nyt-eventtracker-prd.et.page` AS et

WHERE 
    source_app LIKE '%wirecutter%' 
    AND DATE(_pt) >= DATE_TRUNC(DATE_TRUNC(CURRENT_DATE, WEEK(monday)) - 1, WEEK(monday))   AND DATE(_pt) < DATE_TRUNC(CURRENT_DATE, WEEK(monday))
    AND agent.device IS NOT NULL
GROUP BY 1,2,3,4,5

)
SELECT 
        b.week_end,
        device,
        COUNT(DISTINCT users) AS users,
        COUNT(DISTINCT session_id) AS sessions,
        COUNT(DISTINCT b.pageview_id) AS pageviews,
        SUM(pclicks) AS plicks
  
    FROM base AS b
    LEFT JOIN `nyt-bigquery-beta-workspace.stuart_data.wc_clicks`  c ON c.pageview_id = b.pageview_id
    WHERE device IS NOT NULL
GROUP BY 1,2
