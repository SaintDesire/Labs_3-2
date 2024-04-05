SELECT 
  prd_type_id, 
  emp_id, 
  month, 
  2023 AS year,
  ROUND(COALESCE(plan_sales, 0), 2) AS plan_sales
FROM (
  SELECT 
    prd_type_id, 
    emp_id, 
    month, 
    plan_sales
  FROM (
    SELECT 
      prd_type_id, 
      emp_id, 
      month, 
      AVG(amount) OVER (PARTITION BY emp_id ORDER BY month ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS plan_sales
    FROM all_sales 
    WHERE year = 2022
  )
);
