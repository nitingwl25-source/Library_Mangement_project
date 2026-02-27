-- LIBRARY_PROJECT


CREATE TABLE branch (
    branch_id      VARCHAR(10) PRIMARY KEY,
    manager_id     VARCHAR(10),
    branch_address VARCHAR(55),
    contact_no     VARCHAR(10)
);

ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR(30);


SELECT * FROM branch;


DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id    VARCHAR(10) PRIMARY KEY,
    emp_name  VARCHAR(25),
    position  VARCHAR(15),
    salary    INT,
    branch_id VARCHAR(25)
);

ALTER TABLE employees
ALTER COLUMN salary TYPE FLOAT;


CREATE TABLE books (
    isbn         VARCHAR(25) PRIMARY KEY,
    book_title   VARCHAR(100),
    category     VARCHAR(35),
    rental_price FLOAT,
    status       VARCHAR(15),
    author       VARCHAR(50),
    publisher    VARCHAR(100)
);


DROP TABLE IF EXISTS members;

CREATE TABLE members (
    member_id      VARCHAR(20) PRIMARY KEY,
    member_name    VARCHAR(50),
    member_address VARCHAR(75),
    reg_date       DATE
);


CREATE TABLE issued_status (
    issued_id        VARCHAR(20) PRIMARY KEY,
    issued_member_id VARCHAR(50),
    issued_book_name VARCHAR(75),
    issued_date      DATE,
    issued_book_isbn VARCHAR(30),
    issued_emp_id    VARCHAR(10)
);


CREATE TABLE return_status (
    return_id        VARCHAR(20) PRIMARY KEY,
    issued_id        VARCHAR(20),
    return_book_name VARCHAR(75),
    return_date      DATE,
    return_book_isbn VARCHAR(20)
);


-- add constaints
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_return_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);


SELECT * FROM return_status;


-- Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books (
    isbn,
    book_title,
    category,
    rental_price,
    status,
    author,
    publisher
)
VALUES (
    '978-1-60129-456-2',
    'To Kill a Mockingbird',
    'Classic',
    6.00,
    'yes',
    'Harper Lee',
    'J.B. Lippincott & Co.'
);

SELECT * FROM books;


-- Task 2: Update an Existing Member's Address
SELECT * FROM members;

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';


-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status;

DELETE FROM issued_status
WHERE issued_id = 'IS121';


-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT *
FROM issued_status
WHERE issued_emp_id = 'E101';


-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT
    issued_emp_id,
    COUNT(issued_book_isbn) AS total_books_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_book_isbn) > 1;


-- . CTAS (Create Table As Select)
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results
-- each book and total book_issued_cnt**

CREATE TABLE no_of_book_issued AS
SELECT
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) AS total_book_count
FROM books AS b
JOIN issued_status AS ist
    ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title
ORDER BY total_book_count DESC;


SELECT * FROM no_of_book_issued;


-- Task 7. Retrieve All Books in a Specific Category:

SELECT *
FROM books
WHERE category = 'Classic';

SELECT
    category,
    COUNT(book_title) AS total_books
FROM books
GROUP BY category;


-- Task 8: Find Total Rental Income by Category:

SELECT
    b.category,
    SUM(b.rental_price) AS total_rental,
    COUNT(*) AS total_no_of_books
FROM books AS b
JOIN issued_status AS ist
    ON ist.issued_book_isbn = b.isbn
GROUP BY b.category
ORDER BY total_rental DESC;


-- 9 List Members Who Registered in the Last 180 Days:

SELECT
    member_id,
    member_name
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';


-- 10 List Employees with Their Branch Manager's Name and their branch details:

SELECT
    e.*,
    e2.emp_name,
    b.manager_id AS manager
FROM branch b
JOIN employees e
    ON e.branch_id = b.branch_id
JOIN employees e2
    ON e2.emp_id = b.manager_id;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold (7):

CREATE TABLE books_greater_than_7 AS
SELECT *
FROM books
WHERE rental_price > 7;

SELECT * FROM books_greater_than_7;