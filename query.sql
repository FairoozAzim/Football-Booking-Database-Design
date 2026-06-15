-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE TYPES
-- =========================================================================

CREATE TYPE role_type AS enum(
  'Ticket Manager', 
  'Football Fan');

CREATE TYPE match_status_type AS enum(
  'Available',
  'Selling Fast',
  'Sold Out',
  'Postponed'
);

CREATE TYPE payment_status_type AS enum(
  'Pending',
  'Confirmed', 
  'Cancelled', 
  'Refunded'
  );
-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
  user_id int PRIMARY KEY,
  full_name varchar(100) NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  role role_type NOT NULL,
  phone_number varchar(20)
    
    -- Write your constraint to make 'user_id' the Primary Key
    -- Write your constraint to ensure 'email' values are never duplicated
    -- Write your check constraint to restrict 'role' to specific allowed strings
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
  match_id int PRIMARY KEY,
  fixture varchar(200) NOT NULL,
  tournament_category varchar(100) NULL,
  base_ticket_price numeric(10,2),
  match_status match_status_type NOT NULL 
    
    -- Write your constraint to make 'match_id' the Primary Key
    -- Write your check constraint to prevent negative ticket prices
    -- Write your check constraint to restrict 'match_status' values
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
  booking_id int PRIMARY KEY,
  user_id int NOT NULL,
  match_id int NOT NULL,
  seat_number varchar(20) NOT NULL,
  payment_status payment_status_type NULL ,
  total_cost numeric(10,2) NOT NULL
  CHECK (total_cost >= 0)
  ,

  FOREIGN KEY (user_id) 
  REFERENCES users(user_id),

  FOREIGN KEY (match_id) 
  REFERENCES matches(match_id),
  
  UNIQUE (match_id, seat_number)
    
    -- Write your constraint to make 'booking_id' the Primary Key
    -- Write your Foreign Key constraint linking 'user_id' to the Users table
    -- Write your Foreign Key constraint linking 'match_id' to the Matches table
    -- Write your check constraint to ensure 'total_cost' is non-negative
    -- Write your check constraint to restrict 'payment_status' values
);


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan',NULL),
(5, 'Mehedi Hasan', 'mehedi@mail.com', 'Football Fan', '+8801744444444'),
(6, 'Nabila Islam', 'nabila@mail.com', 'Ticket Manager', '+8801755555555'),
(7, 'Rafiq Uddin', 'rafiq@mail.com', 'Ticket Manager', '+8801766666666'),
(8, 'Farzana Akter', 'farzana@mail.com', 'Football Fan', NULL),
(9, 'Imran Hossain', 'imran@mail.com', 'Ticket Manager', '+8801777777777'),
(10, 'Tanvir Ahmed', 'tanvirahmed@mail.com', 'Football Fan', '+88017998899');


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Manchester United vs Liverpool', 'Premier League', 120.00, 'Available'),
(103, 'Bayern Munich vs Borussia Dortmund', 'Bundesliga', 110.00, 'Available'),
(104, 'PSG vs Inter Milan', 'Champions League', 140.00, 'Sold Out'),
(105, 'Juventus vs AC Milan', 'Serie A', 100.00, 'Selling Fast'),
(106, 'Arsenal vs Chelsea', 'Premier League', 130.00, 'Available'),
(107, 'Atletico Madrid vs Sevilla', 'La Liga', 90.00, 'Postponed'),
(108, 'Ajax vs Feyenoord', 'Eredivisie', 80.00, 'Selling Fast'),
(109, 'Benfica vs Porto', 'Primeira Liga', 85.00, 'Sold Out');



-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 2, 101, 'A-13', 'Confirmed', 150.00),
(503, 3, 102, 'B-05', 'Pending', 120.00),
(504, 4, 103, 'C-01', NULL, 110),
(505, 5, 104, 'D-10', 'Cancelled', 140.00),
(506, 6, 105, 'E-07', 'Confirmed', 100.00),
(507, 7, 106, 'F-02', 'Confirmed', 130.00),
(508, 8, 107, 'G-11', NULL, 90.00),
(509, 9, 108, 'H-08', 'Confirmed', 80.00);


-- =========================================================================
-- Queries 1-7
-- =========================================================================

--  Query1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'

select * from matches 
  where tournament_category = 'Champions League'
  and match_status = 'Available'

--  Query2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).

select * from users 
  where full_name ilike 'Tanvir%' 
  or full_name ilike '%Haque%'

--- Query 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required
select booking_id, user_id, match_id, seat_number, 
   COALESCE(payment_status :: text, 'Action Required') as payment_status 
   from bookings
   where payment_status is NULL

---Query 4: Retrieve match booking details along with the User's full name and the scheduled Match fixture teams.
select booking_id, full_name, fixture, total_cost from bookings 
inner join users 
  on bookings.user_id = users.user_id
inner join matches 
  on bookings.match_id = matches.match_id

--- Query 5: Display a comprehensive list of all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed.
select * from users 
left join bookings on users.user_id = bookings.user_id

--- Query 6: Find all ticket bookings where the total cost is strictly higher than the average cost of all ticket bookings.
select booking_id, round(total_cost) from bookings 
  where total_cost > (
  select avg(total_cost)
    from bookings
)

--- Query 7: Retrieve the top 2 most expensive matches sorted by base ticket price, skipping the absolute highest premium match.
select match_id, fixture, tournament_category, base_ticket_price 
  from matches
  order by base_ticket_price DESC
  limit 2 offset 1;   