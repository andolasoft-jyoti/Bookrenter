SELECT YEAR(cc.date) AS YEAR, MONTH(cc.date) AS MONTH,

   CONCAT('$',FORMAT(SUM(IF(ac.charge_type LIKE '%extension', ac.amount,0))/100,2)) AS Extensions,

   CONCAT('$',FORMAT(SUM(IF(ac.charge_type LIKE '%buy', ac.amount,0))/100,2)) AS Buyouts,

   CONCAT('$',FORMAT(SUM(IF(ac.charge_type = 'full', ac.amount,0))/100,2)) AS BNRs,

   CONCAT('$',FORMAT(SUM(IF(ac.charge_type = 'late', ac.amount,0))/100,2)) AS Late,

   CONCAT('$',FORMAT(SUM(IF(ac.charge_type = 'restocking', ac.amount,0))/100,2)) AS Restocking,

   CONCAT('$',FORMAT(SUM(ac.amount)/100,2)) AS AllIncOher,

   CONCAT('$',FORMAT(SUM(IF(cc.status = 'declined',cc.amount,0))/100,2)) AS Declined

FROM bookrenter_production.additional_charges AS ac

INNER JOIN bookrenter_production.orders AS o ON o.id = ac.order_id

INNER JOIN bookrenter_production.cc_transactions AS cc ON ac.cc_transaction_id = cc.id

# WHERE o.bookstore_id IS NULL # retail orders

# (OR)

# WHERE o.bookstore_id IS NOT NULL # stores orders

GROUP BY YEAR(cc.date),MONTH(cc.date)