class CategoryOrdersQuery
  def self.most_selled_products # rubocop:disable Metrics/MethodLength
    # SUM(quantity) instead count(*)
    query = <<-SQL
    SELECT categories.name as category_name, products.title as product_title, COALESCE(max_count_orders,0) as count_orders
    FROM
    (
      SELECT categories.id as category_id, orders.product_id, SUM(quantity) as count_orders
      FROM "orders"
      INNER JOIN "category_products" ON "category_products"."product_id" = "orders"."product_id"
      INNER JOIN "categories" ON "categories"."id" = "category_products"."category_id"
      group by categories.id, orders.product_id) as sum
      INNER JOIN (
        SELECT category_id, max(count_orders) as max_count_orders FROM
          (SELECT categories.id as category_id, orders.product_id, SUM(quantity) as count_orders
           FROM "orders"
           INNER JOIN "category_products" ON "category_products"."product_id" = orders.product_id
           INNER JOIN "categories" ON "categories"."id" = "category_products"."category_id"
           group by categories.id, orders.product_id) as sum2
        group by category_id) as max
    on sum.category_id = max.category_id
    and sum.count_orders = max.max_count_orders
    -- get product/category names
    INNER JOIN "products" ON "products"."id" = "product_id"
    RIGHT OUTER JOIN "categories" ON "categories"."id" = "sum"."category_id"
    SQL
    ActiveRecord::Base.connection.select_all(query)
  end

  def self.most_collected_products # rubocop:disable Metrics/MethodLength
    query = <<-SQL
    SELECT category_name, product_title, amount
    FROM (
      SELECT categories.name AS category_name, products.title AS product_title, SUM(orders.price) AS amount,
         ROW_NUMBER() OVER(PARTITION BY categories.id ORDER BY SUM(orders.price) DESC) AS ranking
      FROM categories
      JOIN category_products ON categories.id = category_products.category_id
      JOIN products ON category_products.product_id = products.id
      JOIN orders ON products.id = orders.product_id
      GROUP BY categories.id, products.id
    ) AS ranking_table
    WHERE ranking <= 3
    ORDER BY category_name, amount DESC
    SQL
    ActiveRecord::Base.connection.select_all(query)
  end
end
