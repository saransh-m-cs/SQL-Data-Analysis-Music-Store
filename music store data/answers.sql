/* Q1: Who is the senior most employee based on job title? */


SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1;


/* Q2: Which countries have the most Invoices? */


SELECT billing_country, COUNT(*) AS invoice_count FROM invoice
GROUP BY billing_country ORDER BY invoice_count DESC;


/* Q3: What are top 3 values of total invoice? */


SELECT * FROM invoice
ORDER BY total DESC
LIMIT 3;


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */


SELECT SUM(total) AS TOTAL_IN_CITY, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY TOTAL_IN_CITY DESC
LIMIT 1;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/


SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) as total
FROM customer
JOIN
invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
LIMIT 1;


/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */


SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice on customer.customer_id = invoice.customer_id
JOIN invoice_line on invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
		SELECT track_id from track
		JOIN genre on track.genre_id = genre.genre_id
		WHERE genre.name LIKE 'Rock')
ORDER BY email;


/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */


SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS total_songs
FROM artist
JOIN
album ON artist.artist_id = album.artist_id
JOIN track on album.album_id = track.album_id
WHERE track_id IN(
			SELECT track_id from track
			JOIN
			genre on track.genre_id = genre.genre_id
			WHERE genre.name LIKE 'Rock'
) GROUP BY artist.artist_id
ORDER BY total_songs DESC
LIMIT 10;


/*METHOD 2*/

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;


/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */


SELECT name, milliseconds
FROM track
WHERE milliseconds>
		(SELECT	AVG(milliseconds) AS avg_track_length
		 FROM track)
ORDER BY milliseconds DESC;


/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */


SELECT 
CONCAT_WS(' ',customer.first_name, customer.last_name) AS customer_name,
artist.name, SUM(invoice_line.unit_price * invoice_line.quantity) AS money_spent
FROM customer
JOIN invoice on customer.customer_id = invoice.customer_id
JOIN invoice_line on invoice.invoice_id = invoice_line.invoice_id
JOIN track on invoice_line.track_id = track.track_id
JOIN album on track.album_id = album.album_id
JOIN artist on album.artist_id = artist.artist_id
GROUP BY customer.first_name, customer.last_name, artist.name
ORDER BY money_spent DESC
 
