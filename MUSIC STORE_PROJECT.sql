/* ============================================================ 1. DATABASE CREATION ============================================================ */ 
-- CREATE DATABASE IF NOT EXISTS 
USE MUSIC_STORE;
/* ============================================================ 2. TABLE CREATION ============================================================ */
/* ------------------------------------------------------------ 2.1 GENRE TABLE ------------------------------------------------------------ */ 
CREATE TABLE Genre ( genre_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(120) );

/* ------------------------------------------------------------ 2.2 MEDIA TYPE TABLE ------------------------------------------------------------ */ 
CREATE TABLE MediaType ( media_type_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(120) );

/* ------------------------------------------------------------ 2.3 EMPLOYEE TABLE ------------------------------------------------------------ */ 
CREATE TABLE Employee 
( employee_id INT PRIMARY KEY AUTO_INCREMENT,
 last_name VARCHAR(120), 
 first_name VARCHAR(120),
 title VARCHAR(120), 
 reports_to INT, 
 levels VARCHAR(255), 
 birthdate DATE, 
 hire_date DATE, 
 address VARCHAR(255),
 city VARCHAR(100), 
 state VARCHAR(100),
 country VARCHAR(100), 
 postal_code VARCHAR(20),
 phone VARCHAR(50), 
 fax VARCHAR(50),
 email VARCHAR(100), 
 FOREIGN KEY (reports_to) REFERENCES Employee(employee_id) 
 ON DELETE SET NULL ON UPDATE CASCADE ); 
 
 /* ------------------------------------------------------------ 2.4 CUSTOMER TABLE ------------------------------------------------------------ */ 
 CREATE TABLE Customer 
 ( customer_id INT PRIMARY KEY AUTO_INCREMENT,
 first_name VARCHAR(120), 
 last_name VARCHAR(120), 
 company VARCHAR(120), 
 address VARCHAR(255), 
 city VARCHAR(100), 
 state VARCHAR(100),
 country VARCHAR(100),
 postal_code VARCHAR(20), 
 phone VARCHAR(50), 
 fax VARCHAR(50), 
 email VARCHAR(100), 
 support_rep_id INT,
 FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id)
 ON DELETE SET NULL ON UPDATE CASCADE );
 
 /* ------------------------------------------------------------ 2.5 ARTIST TABLE ------------------------------------------------------------ */ 
 CREATE TABLE Artist 
 ( artist_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(120) );
 
 /* ------------------------------------------------------------ 2.6 ALBUM TABLE ------------------------------------------------------------ */ 
 CREATE TABLE Album
 ( album_id INT PRIMARY KEY AUTO_INCREMENT,
 title VARCHAR(160),
 artist_id INT, 
 FOREIGN KEY (artist_id) REFERENCES Artist(artist_id) 
 ON DELETE CASCADE ON UPDATE CASCADE );


/* ------------------------------------------------------------ 2.7 TRACK TABLE ------------------------------------------------------------ */ 
CREATE TABLE Track 
( track_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(200), 
 album_id INT, 
 media_type_id INT,
 genre_id INT,
 composer VARCHAR(220), 
 milliseconds INT, 
 bytes INT,
 unit_price DECIMAL(10,2), 
 FOREIGN KEY (album_id) REFERENCES Album(album_id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id) ON DELETE CASCADE ON UPDATE CASCADE, 
 FOREIGN KEY (genre_id) REFERENCES Genre(genre_id) ON DELETE CASCADE ON UPDATE CASCADE );
 
 
 /* ------------------------------------------------------------ 2.8 INVOICE TABLE ------------------------------------------------------------ */ 
 CREATE TABLE Invoice
 ( invoice_id INT PRIMARY KEY AUTO_INCREMENT,
 customer_id INT, invoice_date DATE,
 billing_address VARCHAR(255), 
 billing_city VARCHAR(100),
 billing_state VARCHAR(100),
 billing_country VARCHAR(100), 
 billing_postal_code VARCHAR(20), 
 total DECIMAL(10,2),
 FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE );


/* ------------------------------------------------------------ 2.9 INVOICE LINE TABLE ------------------------------------------------------------ */ 
CREATE TABLE InvoiceLine 
( invoice_line_id INT PRIMARY KEY AUTO_INCREMENT, 
invoice_id INT, 
track_id INT, 
unit_price DECIMAL(10,2), 
quantity INT, 
FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (track_id) REFERENCES Track(track_id) ON DELETE CASCADE ON UPDATE CASCADE );
 
 
 /* ------------------------------------------------------------ 2.10 PLAYLIST TABLE ------------------------------------------------------------ */
 CREATE TABLE Playlist 
 ( playlist_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(255) );
 
 /* ------------------------------------------------------------ 2.11 PLAYLIST TRACK TABLE ------------------------------------------------------------ */
 CREATE TABLE PlaylistTrack 
 ( playlist_id INT,
 track_id INT,
 PRIMARY KEY (playlist_id, track_id),
 FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (track_id) REFERENCES Track(track_id) ON DELETE CASCADE ON UPDATE CASCADE );
 
 /* ============================================================ 3. DATA VALIDATION ============================================================ */ 
 /* Check number of records in each table */ 
 SELECT COUNT(*) AS genre_records FROM Genre; 
 
 SELECT COUNT(*) AS media_type_records FROM MediaType;
 
 SELECT COUNT(*) AS employee_records FROM Employee; 
 
 SELECT COUNT(*) AS customer_records FROM Customer; 
 
 SELECT COUNT(*) AS artist_records FROM Artist;
 
 SELECT COUNT(*) AS album_records FROM Album;
 
 SELECT COUNT(*) AS track_records FROM Track;
 
 SELECT COUNT(*) AS invoice_records FROM Invoice;
 
 SELECT COUNT(*) AS invoice_line_records FROM InvoiceLine; 
 
 SELECT COUNT(*) AS playlist_records FROM Playlist; 
 
 SELECT COUNT(*) AS playlist_track_records FROM PlaylistTrack;
 
 /* ============================================================ 4. TASK QUESTIONS ============================================================ */
 /* ======== QUESTION 1 Who is the senior most employee based on job title? =============
 The 'levels' column represents the employee hierarchy.
 Higher level = more senior position. We sort levels in descending order and return the employee with the highest level. 
 */
 
 SELECT employee_id, first_name, last_name, title, levels
 FROM Employee
 ORDER BY CAST(levels AS UNSIGNED)
 DESC LIMIT 1;
 
 /* ========== QUESTION 2 Which countries have the most invoices? =========
 Count the number of invoices for each country and arrange them from highest to lowest.
 */
 
 SELECT billing_country AS country, COUNT(invoice_id) AS total_invoices 
 FROM Invoice 
 GROUP BY billing_country 
 ORDER BY total_invoices DESC;
 
 
 /* ============ QUESTION 3 What are the top 3 values of total invoice? ==========
 Sort invoice totals from highest to lowest and return the first three values. ================*/
 
 SELECT invoice_id, total
 FROM Invoice 
 ORDER BY total 
 DESC LIMIT 3;
 
 /* =============QUESTION 4 Which city has the best customers? 
 Find the city where the store generated the highest total revenue. Return: - City - Total amount spent =========== */
 SELECT billing_city AS city, SUM(total) AS total_revenue 
 FROM Invoice 
 GROUP BY billing_city
 ORDER BY total_revenue
 DESC LIMIT 1;
 
 
 
 /* =========== QUESTION 5 Who is the best customer?
 The customer who has spent the most money is considered the best customer. 
 Join Customer and Invoice tables and calculate the total invoice amount for each customer. ========= */
 
 
 SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(i.total) AS total_spent 
 FROM Customer c 
 JOIN Invoice i ON c.customer_id = i.customer_id 
 GROUP BY c.customer_id, c.first_name, c.last_name 
 ORDER BY total_spent 
 DESC LIMIT 1;
 
 
 /* =============QUESTION 6 Find all Rock Music listeners.
 Return: - Email - First Name - Last Name - Genre Order alphabetically by email. ================ */
 
 SELECT DISTINCT c.email, c.first_name, c.last_name, g.name AS genre 
 FROM Customer c 
 JOIN Invoice i ON c.customer_id = i.customer_id 
 JOIN InvoiceLine il ON i.invoice_id = il.invoice_id 
 JOIN Track t ON il.track_id = t.track_id 
 JOIN Genre g ON t.genre_id = g.genre_id 
 WHERE g.name = 'Rock' 
 ORDER BY c.email ASC;
 
 
 /* ============ QUESTION 7 Top 10 rock artists/bands Find the artists who have created the highest number of Rock tracks. 
 Return: - Artist name - Total Rock track count ============ */
 
 SELECT ar.name AS artist_name, COUNT(t.track_id) AS total_rock_tracks 
 FROM Artist ar 
 JOIN Album al ON ar.artist_id = al.artist_id 
 JOIN Track t ON al.album_id = t.album_id 
 JOIN Genre g ON t.genre_id = g.genre_id 
 WHERE g.name = 'Rock' 
 GROUP BY ar.artist_id, ar.name 
 ORDER BY total_rock_tracks DESC 
 LIMIT 10;
 
 
 /* ============QUESTION 8 Tracks longer than the average song length
 Return: - Track name - Milliseconds Only tracks whose duration is greater than the average duration should be returned.
 Longest tracks should appear first. ========== */
 
 
 SELECT name, milliseconds 
 FROM Track 
 WHERE milliseconds > ( SELECT AVG(milliseconds) FROM Track )
 ORDER BY milliseconds DESC;
 
 
 
 /* ============ QUESTION 9 How much amount is spent by each customer on artists? 
 Return: - Customer name - Artist name - 
 Total amount spent Revenue is calculated using: unit_price × quantity from InvoiceLine. ==============*/
 
 SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, ar.name AS artist_name, SUM(il.unit_price * il.quantity) AS total_spent 
 FROM Customer c 
 JOIN Invoice i 
 ON c.customer_id = i.customer_id 
 JOIN InvoiceLine il 
 ON i.invoice_id = il.invoice_id 
 JOIN Track t 
 ON il.track_id = t.track_id 
 JOIN Album al 
 ON t.album_id = al.album_id 
 JOIN Artist ar 
 ON al.artist_id = ar.artist_id 
 GROUP BY c.customer_id, c.first_name, c.last_name, ar.artist_id, ar.name 
 ORDER BY customer_name, total_spent DESC;
 
 
 /* =========QUESTION 10 Most popular music Genre for each country Popularity is determined by the highest number of purchases.
 Steps: 1. Count purchases for each country and genre. 
 2. Find the maximum purchase count for every country.
 3. Return all genres that have that maximum count. This also handles ties. ============*/
 
 /* Step 1: Calculate purchases by country and genre. */ 
 WITH country_genre_purchases AS 
 ( SELECT i.billing_country AS country, g.name AS genre, COUNT(il.invoice_line_id) AS purchase_count 
 FROM Invoice i 
 JOIN InvoiceLine il 
 ON i.invoice_id = il.invoice_id 
 JOIN Track t 
 ON il.track_id = t.track_id 
 JOIN Genre g 
 ON t.genre_id = g.genre_id 
 GROUP BY i.billing_country, g.name ),
 /* Step 2: Find the highest purchase count for each country. */ 
 country_max_purchases AS ( SELECT country, MAX(purchase_count) AS max_purchase_count
 FROM country_genre_purchases 
 GROUP BY country ) 
 /* Step 3: Return all genres matching the maximum count. */ 
 SELECT cgp.country, cgp.genre, cgp.purchase_count 
 FROM country_genre_purchases cgp 
 JOIN country_max_purchases cmp 
 ON cgp.country = cmp.country 
 AND cgp.purchase_count = cmp.max_purchase_count 
 ORDER BY cgp.country, cgp.genre;
 
 
 /* ================= QUESTION 11 Customer who spent the most on music for each country 
 Return: - Country - Top customer - Amount spent If multiple customers have the same maximum amount, return all of them.============ */
 
 
 /* Step 1: Calculate total spending for every customer in every country. */
 WITH customer_country_spending AS 
 ( SELECT c.country, c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(i.total) AS total_spent
 FROM Customer c 
 JOIN Invoice i 
 ON c.customer_id = i.customer_id 
 GROUP BY c.country, c.customer_id, c.first_name, c.last_name ), 
 /* Step 2: Find the maximum amount spent in each country. */ 
 country_max_spending AS ( SELECT country, MAX(total_spent) AS max_spent 
 FROM customer_country_spending 
 GROUP BY country ) 
 
 /* Step 3: Return all customers whose spending equals the maximum spending for their country. */
 SELECT ccs.country, ccs.customer_name, ccs.total_spent
 FROM customer_country_spending ccs 
 JOIN country_max_spending cms 
 ON ccs.country = cms.country 
 AND ccs.total_spent = cms.max_spent
 ORDER BY ccs.country, ccs.customer_name;
 
 
 
 
 /* ============== END OF MUSIC STORE DATA ANALYSIS PROJECT =============== */