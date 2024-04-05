SELECT 
  src.prd_type_id, 
  src.emp_id, 
  src.month, 
  2023 AS year,
  ROUND(
    CASE 
      WHEN src.emp_id IN (21, 22) THEN src.amount * 1.05
      ELSE src.amount * 1.10
    END, 
    2
  ) AS plan_sales
FROM (
  SELECT 
    emp_id, 
    month,
    prd_type_id,
    amount
  FROM (
    SELECT DISTINCT emp_id, month FROM all_sales WHERE year = 2022
  ) emp_month
  CROSS JOIN (
    SELECT DISTINCT prd_type_id FROM all_sales WHERE year = 2022
  ) prd_type
  INNER JOIN all_sales 
  USING (emp_id, month, prd_type_id)
) src;
