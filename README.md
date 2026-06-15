# ⚽ Football Ticket Booking System — PostgreSQL Database Design

## 📌 Project Overview

This project is a relational database system designed for a Football Ticket Booking Platform. It models the core operations of a ticketing system where users can view football matches, book tickets, select seats, and track payment status.

The system is implemented using PostgreSQL and follows proper relational database design principles, including primary/foreign keys, constraints, and structured relationships between entities.

---

## Objective

The main objective of this project is to design and implement a scalable and consistent database that can:

- Manage user accounts (fans and ticket managers)
- Store football match details
- Handle ticket bookings for specific matches and seats
- Ensure data integrity through constraints and relationships
- Support real-world booking rules such as seat uniqueness and payment tracking

---

## Database Design

The system consists of three core entities:

### 1. Users

This table stores all registered users of the platform, including both football fans and administrative staff.

Key features:
- Unique user identification
- Role-based access control using predefined roles
- Contact information storage

Roles are defined using an ENUM type:
- Ticket Manager
- Football Fan

---

### 2. Matches

This table contains information about football matches available for booking.

It includes:
- Match fixture details (teams playing)
- Tournament category (e.g., Champions League)
- Match status (e.g., Available, Sold Out, Completed)
- Match date and scheduling information
- Base ticket price for each match

This table acts as the central reference for all bookings.

---

### 3. Bookings

This is a transactional table that connects users and matches.

It records every ticket purchase made by a user for a specific match and seat.

Key features:
- Each booking is linked to exactly one user
- Each booking is linked to exactly one match
- Seat selection is stored per booking
- Payment status tracking using controlled values
- Total cost calculation per booking

A key business rule enforced in this table is:
> A specific seat for a given match can only be booked once.

This is ensured using a composite unique constraint on:
- match_id
- seat_number

Payment status is implemented using an ENUM type with values:
- Pending
- Confirmed
- Cancelled
- Refunded

---

## 🔗 Relationships Between Tables

The database follows a clear relational structure:

- One User can have many Bookings
- One Match can have many Bookings
- Each Booking belongs to exactly one User and one Match

This design ensures that the Bookings table acts as a junction table while also storing transactional information.

---

## Data Integrity & Constraints

To ensure reliability and correctness of data, the following constraints are applied:

- Primary keys for unique identification of records
- Foreign keys to enforce relational integrity
- ENUM types for controlled categorical values
- NOT NULL constraints for required fields
- UNIQUE constraint to prevent double booking of seats
- CHECK constraints for validating numeric values such as cost

---

## Key Database Concepts Used

This project demonstrates practical use of:

- Relational database modeling
- Entity-Relationship (ER) design principles
- Foreign key relationships
- Composite unique constraints
- ENUM data types in PostgreSQL
- Transactional table design
- Business rule enforcement at database level
