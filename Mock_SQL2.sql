# Solution
with cte1 as
(
    select u.user_id, u.favorite_brand, i.item_id, i.item_brand, o.order_date, 
    rank() over(partition by u.user_id order by o.order_date) as ranks
    from Users u
    left join Orders o
    on u.user_id = o.seller_id
    left join Items i
    on i.item_id = o.item_id
), cte2 as
(
    select * 
    from cte1
    where ranks = 2 and favorite_brand = item_brand 
)
select c1.user_id as seller_id, (case when count(c2.ranks) >= 2 then 'yes' else 'no' end) as '2nd_item_fav_brand'
from cte1 c1
left join cte2 c2
on c1.user_id = c2.user_id
group by seller_id