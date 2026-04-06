#use ola;

#1.Retrieve all successfull bookings.
#create view Successfull_Bookings AS select * from bookings
#where Booking_Status='success';
#Select * from Successfull_Bookings;

#2. Find the average ride distance for each vehicle type:
#create view ride_distance_for_each_vehicle as
#select Vehicle_type, avg(Ride_Distance) as avg_distance from bookings group by vehicle_type;   
#select * from ride_distance_for_each_vehicle;
 
#3. Get the total number of canceled rides by customers
#create view canceled_rides_by_customers as
#select COUNT(*) from Bookings 
#where booking_status='canceled by customers';
#select * from canceled_rides_by_customers;

#4. List the top 5 customers who booked the highest number of rides:
#create view top_5_customers as
#select customer_id, count(booking_id) as total_rides from bookings group by customer_id order by total_rides desc limit 5
#select * from top_5_customers 

#5. Get the number of rides canceled by driver due personal car-related issue:
#create view canceled_by_driver as
#select count(*) from bookings where Canceled_Rides_by_Driver = 'Personal & car related issue';
#select * from canceled_by_driver

#6. Find the minimum and maximum driver ratings for prime sedan bookings:
#create view minimum_and_maximum_driver_ratings as
#select max(driver_ratings) as max_rating,
#min(driver_ratings) as min_rating
#from bookings where vehicle_type='prime sedan';
#select * from minimum_and_maximum_driver_ratings; 

#7. Retrieve all rides where payment was made  by UPI:
#create view payment_UPI as
#select * from bookings where payment_method='UPI'; 
#select * from payment_UPI;

#8. Find the average customer rating per vehicle type:
#create view avg_customer_rating as
#select vehicle_type, AVG (Customer_rating) as avg_customer_rating 
#from bookings 
#group by vehicle_type;
#select * from avg_customer_rating;

#9. Calculate the total booking value of rides completed successfully: 
#create view total_successful_ride_value as
#select sum(booking_value)as total_successful_ride_value
#from bookings
#where booking_status='success';
#select * from total_successful_ride_value;

#10. List all the incomplete rides along with the reason:
#create view I_R_R as
#select booking_id, incomplete_rides_reason
#from bookings
#where incomplete_rides='yes';
#select * from I_R_R;

