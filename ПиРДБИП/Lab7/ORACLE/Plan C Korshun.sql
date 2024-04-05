WITH max_sales AS (
  SELECT 
    prd_type_id, 
    month,
    MAX(amount) AS max_amount
  FROM all_sales 
  WHERE year = 2022
  GROUP BY prd_type_id, month
),
emp_max_sales AS (
  SELECT 
    a.prd_type_id, 
    a.month, 
    a.emp_id, 
    a.amount AS emp_amount,
    COALESCE(b.max_amount, 0) AS max_amount
  FROM all_sales a
  LEFT JOIN max_sales b ON a.prd_type_id = b.prd_type_id AND a.month = b.month
)
SELECT 
  prd_type_id, 
  emp_id, 
  month, 
  2023 AS year,
  ROUND(
    CASE 
      WHEN emp_amount > max_amount THEN (emp_amount - max_amount) / 2
      ELSE emp_amount
    END,
    2
  ) AS plan_sales
FROM emp_max_sales;
