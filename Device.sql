SELECT 
    DATE_TRUNC(DATE(_pt), WEEK(monday)) + 6 AS week_end,

    COUNT(DISTINCT CASE
            WHEN agent.device.is_mobile IS TRUE AND agent.device.is_tablet IS FALSE 
                    THEN COALESCE(cast(combined_regi_id AS STRING), agent_id) END) AS Mobile,

    COUNT(DISTINCT CASE 
            WHEN et.source_app = 'amp-wirecutter' AND agent.device.is_mobile IS TRUE AND agent.device.is_tablet IS FALSE 
                THEN COALESCE(cast(combined_regi_id AS STRING),agent_id) END) AS Mobile_Amp,

    COUNT(DISTINCT CASE 
            WHEN et.source_app = 'wirecutter' AND agent.device.is_mobile IS TRUE AND agent.device.is_tablet IS FALSE
                THEN COALESCE(cast(combined_regi_id AS STRING),agent_id) END) AS Mobile_Web,

    COUNT(DISTINCT CASE
            WHEN agent.device.is_computer IS TRUE THEN COALESCE(cast(combined_regi_id AS STRING),agent_id)END) AS Desktop,
    
    COUNT(DISTINCT CASE
            WHEN agent.device.is_tablet IS TRUE THEN COALESCE(cast(combined_regi_id AS STRING),agent_id)END) AS Tablet


FROM `nyt-eventtracker-prd.et.page` AS et

WHERE source_app LIKE '%wirecutter%' 
        -- AND agent_id is NULL -- filtering for anon users 
    AND DATE(_pt) >= DATE_TRUNC(DATE_TRUNC(CURRENT_DATE, WEEK(monday)) - 1, WEEK(monday))   AND DATE(_pt) < DATE_TRUNC(CURRENT_DATE, WEEK(monday))

      
    GROUP BY 1
    ORDER BY 1