

SELECT YEAR(OrderTable.OrderDate) AS YEAR, MONTH(OrderTable.OrderDate) AS MONTH,

 SUM(OrderTable.ORentCt) AS NRentals, SUM(OrderTable.OPurchCt) AS NPurchases,

 SUM(OrderTable.ItemCt) AS NBooks, count(OrderTable.Oid) AS NOrders,

 CONCAT('$',FORMAT(SUM(OrderTable.ORentRev)/100,2)) AS RentalRev,

 CONCAT('$',FORMAT(SUM(OrderTable.Shipping)/100,2)) AS ShipRevenue,

 CONCAT('$',FORMAT(SUM(OrderTable.OPurchRev)/100,2)) AS PurchRevenue,

 FORMAT(SUM(OrderTable.ItemCt)/count(OrderTable.Oid),2) AS BksPerOrd,

 FORMAT(SUM(OrderTable.ORentalDays)/SUM(OrderTable.ORentCt),2) AS AvgDays,

 CONCAT('$',FORMAT(SUM(OrderTable.ORentRev)/SUM(OrderTable.ORentCt)/100,2)) AS AvgRental,

 CONCAT('$',FORMAT(SUM(OrderTable.ORentRev+OrderTable.Shipping)/count(OrderTable.Oid)/100,2)) AS AvgOrder

 FROM

 (SELECT o.id AS Oid, o.date_ordered AS OrderDate, COUNT(*) AS ItemCt,

  SUM(IF(rental_period LIKE '%buy',0,1)) AS ORentCt,

  SUM(IF(rental_period NOT LIKE '%buy', 0, 1)) AS OPurchCt,

  SUM(IF(rental_period LIKE '%buy',0,li.price)) AS ORentREv,

  SUM(IF(rental_period NOT LIKE '%buy', 0, li.price)) AS OPurchRev,

  SUM(IF(rental_period NOT LIKE '%buy', rental_period, 0)) AS ORentalDays,

  o.shipping_base_cost+o.shipping_additional_cost AS Shipping

  FROM bookrenter_devlopment.line_items AS li

  INNER JOIN bookrenter_devlopment.orders AS o ON li.order_id = o.id

  INNER JOIN bookrenter_devlopment.books AS bk ON bk.isbn = li.isbn

  INNER JOIN bookrenter_devlopment.book_instances AS bi ON bi.id = li.book_instance_id

  WHERE cancel_reason IS NULL # all orders

# && o.bookstore_id IS NULL # retail orders

# (OR)

# && o.bookstore_id IS NOT NULL # stores orders

  GROUP BY o.id) AS OrderTable

GROUP BY YEAR(OrderTable.OrderDate),MONTH