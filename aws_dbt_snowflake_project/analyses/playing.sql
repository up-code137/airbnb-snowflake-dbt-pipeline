 






select * from {{ ref("bronze_bookings")}}
where nights_booked > 1


