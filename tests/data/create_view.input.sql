create view active_users as select u.id as user_id, u.name as user_name, o.total from users u inner join orders o on u.id = o.user_id where o.total > 100;
