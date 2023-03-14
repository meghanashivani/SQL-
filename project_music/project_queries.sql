use music_store_db;
## Question Set 1
## 1. Who is the senior most employee based on job title?
SELECT levels, concat(first_name,' ',last_name) as employee_name, title
FROM employee
ORDER BY levels DESC
LIMIT 1;
## ANSWER: Based on Job Title, Mohan Madan is the senior most employee

## 2. Which countries have the most Invoices?
SELECT * FROM Invoice;
SELECT billing_country, count(*) as Invoices 
FROM Invoice
GROUP BY billing_country
ORDER BY invoices desc;
## ANSWER: Countries like USA, Canada, Brazil, France, etc. have most invoices respectively

## 3. What are top 3 values of total invoice?
select * from invoice order by total desc limit 3; 

## 4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
## Write a query that returns one city that has the highest sum of invoice totals. 
## Return both the city name & sum of all invoice totals
SELECT billing_city as City, sum(Total) as InvoiceTotals
FROM Invoice
GROUP BY billing_city
ORDER BY InvoiceTotals desc
LIMIT 1;
## ANSWER: Prague City has the best customers, with a total of 273.24 invoices.

## 5. Who is the best customer? The customer who has spent the most money will be declared the best customer. 
## Write a query that returns the person who has spent the most money
select concat(first_name,' ',last_name) as customer_name from customer 
where customer_id= ( select customer_id from invoice 
group by customer_id order by sum(total) desc limit 1);
## ANSWER: FrantiÅ¡ek WichterlovÃ is observed to be the 

## Question Set 2
## 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
## Return your list ordered alphabetically by email starting with A
select distinct email,first_name,last_name from customer 
inner join genre  where genre.name='Rock' 
order by email asc;

## 2.Let's invite the artists who have written the most rock music in our dataset. 
## Write a query that returns the Artist name and total track count of the top 10 rock bands
SELECT Artist.Name AS name,
COUNT(Track.Name) AS track_count
FROM Artist JOIN Album 
ON Album.Artist_Id = Artist.Artist_Id JOIN Track 
ON Album.Album_Id = track.album_Id JOIN genre 
ON Track.Genre_Id = genre.genre_Id 
WHERE Genre.Name = 'Rock' 
GROUP BY 
Artist.Name,
Genre.Name 
ORDER BY track_count DESC 
LIMIT 10;

## 3.Return all the track names that have a song length longer than the average song length. 
## Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
 select name , milliseconds from track
 where milliseconds >  (select avg(milliseconds) from track)
 order by milliseconds ;
 
## Question Set 3
## 1. Find how much amount spent by each customer on artists? 
## Write a query to return customer name, artist name and total spent
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

## 2. We want to find out the most popular music Genre for each country. 
## We determine the most popular genre as the genre with the highest amount of purchases. 
## Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres.
WITH CountryGenPopularityList AS
(SELECT count(*) as Popularity, gen.name as GenreName, i.billing_country as Country
FROM invoice_line il
JOIN track trk ON trk.track_id=il.track_id
JOIN genre gen ON gen.genre_id=trk.genre_id
JOIN invoice i ON il.invoice_id = i.invoice_id
GROUP BY Country, gen.genre_id)
SELECT cgpl.Country, cgpl.GenreName, cgpl.Popularity 
FROM CountryGenPopularityList cgpl
WHERE cgpl.Popularity = (SELECT max(Popularity) FROM CountryGenPopularityList 
WHERE cgpl.Country=Country
GROUP BY Country)
ORDER BY Country;

## 3. Write a query that determines the customer that has spent the most on music for each country. 
## Write a query that returns the country along with the top customer and how much they spent. 
## For countries where the top amount spent is shared, provide all customers who spent this amount
WITH RECURSIVE 
	customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3 DESC),

	country_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customter_with_country
		GROUP BY billing_country)
SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customter_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;