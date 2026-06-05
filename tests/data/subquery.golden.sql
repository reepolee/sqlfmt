SELECT id, (
    SELECT max(price) FROM orders o WHERE o.user_id = u.id
) AS max_order FROM users u WHERE u.active = 1;
