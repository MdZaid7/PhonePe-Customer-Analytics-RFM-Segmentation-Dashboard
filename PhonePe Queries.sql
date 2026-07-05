-- Null Check - Users

-SELECT
    SUM(CASE WHEN User_ID IS NULL THEN 1 ELSE 0 END) AS User_ID_Nulls,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Name_Nulls,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Nulls,
    SUM(CASE WHEN Join_Date IS NULL THEN 1 ELSE 0 END) AS Join_Date_Nulls
FROM Users;


-- Null Check - Transactions

SELECT
    SUM(CASE WHEN Transaction_ID IS NULL THEN 1 ELSE 0 END) AS Transaction_ID_Nulls,
    SUM(CASE WHEN User_ID IS NULL THEN 1 ELSE 0 END) AS User_ID_Nulls,
    SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS Amount_Nulls,
    SUM(CASE WHEN Service IS NULL THEN 1 ELSE 0 END) AS Service_Nulls,
    SUM(CASE WHEN Service_Type IS NULL THEN 1 ELSE 0 END) AS Service_Type_Nulls,
    SUM(CASE WHEN Payment_Status IS NULL THEN 1 ELSE 0 END) AS Payment_Status_Nulls,
    SUM(CASE WHEN Reason IS NULL THEN 1 ELSE 0 END) AS Reason_Nulls,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_Nulls
FROM Transactions;



-- Duplicate Users

SELECT
    User_ID,
    COUNT(*) AS Duplicate_Count
FROM Users
GROUP BY User_ID
HAVING COUNT(*) > 1;


-- Duplicate Transactions

SELECT
    Transaction_ID,
    COUNT(*) AS Duplicate_Count
FROM Transactions
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;


-- Orphan Transactions

SELECT
    t.User_ID
FROM Transactions t
LEFT JOIN Users u
ON t.User_ID = u.User_ID
WHERE u.User_ID IS NULL;


-- Invalid Age

SELECT *
FROM Users
WHERE Age < 18
   OR Age > 100;


-- Invalid Amount

SELECT *
FROM Transactions
WHERE Amount <= 0;


-- Payment Status Validation

SELECT
    Payment_Status,
    COUNT(*) AS Total
FROM Transactions
GROUP BY Payment_Status
ORDER BY Total DESC;


-- Reason Validation

SELECT
    Reason,
    COUNT(*) AS Total
FROM Transactions
GROUP BY Reason
ORDER BY Total DESC;


-- Service Validation

SELECT DISTINCT Service
FROM Transactions;


-- Service Type Validation

SELECT DISTINCT Service_Type
FROM Transactions;


-- Transaction Date Range

SELECT
    MIN(Date) AS First_Transaction,
    MAX(Date) AS Last_Transaction
FROM Transactions;


-- User Join Date Range

SELECT
    MIN(Join_Date) AS First_User,
    MAX(Join_Date) AS Latest_User
FROM Users;


-- Standardize Payment Status

UPDATE Transactions
SET Payment_Status = 'Failed'
WHERE Payment_Status IN
(
    'Wrong PIN',
    'Server error',
    'Insufficient amount'
);


-- Verify Payment Status

SELECT
    Payment_Status,
    COUNT(*) AS Total
FROM Transactions
GROUP BY Payment_Status;


-- Top 10 Highest Spending Users

SELECT TOP 10
    u.User_ID,
    u.Name,
    SUM(t.Amount) AS Total_Spend
FROM Users u
JOIN Transactions t
ON u.User_ID = t.User_ID
GROUP BY
    u.User_ID,
    u.Name
ORDER BY Total_Spend DESC;


-- Top 10 Users by Transaction Count

SELECT TOP 10
    u.User_ID,
    u.Name,
    COUNT(*) AS Total_Transactions
FROM Users u
JOIN Transactions t
ON u.User_ID = t.User_ID
GROUP BY
    u.User_ID,
    u.Name
ORDER BY Total_Transactions DESC;


-- Failed Transaction Reasons

SELECT
    Reason,
    COUNT(*) AS Total_Failures
FROM Transactions
WHERE Payment_Status = 'Failed'
GROUP BY Reason
ORDER BY Total_Failures DESC;



-- Users with More Than 5 Failed Transactions

SELECT
    u.User_ID,
    u.Name,
    COUNT(*) AS Failed_Transactions
FROM Users u
JOIN Transactions t
ON u.User_ID = t.User_ID
WHERE Payment_Status = 'Failed'
GROUP BY
    u.User_ID,
    u.Name
HAVING COUNT(*) > 5
ORDER BY Failed_Transactions DESC;


-- Highest Single Transaction

SELECT TOP 1 *
FROM Transactions
ORDER BY Amount DESC;


-- Top 10 User Lifetime Value
SELECT top 10
    u.User_ID,
    u.Name,
    COUNT(t.Transaction_ID) AS Total_Transactions,
    SUM(t.Amount) AS Lifetime_Value
FROM Users u
JOIN Transactions t
ON u.User_ID=t.User_ID
GROUP BY
    u.User_ID,
    u.Name
ORDER BY Lifetime_Value DESC;


-- Repeat Customers

SELECT
COUNT(*) AS Repeat_Customers
FROM
(
SELECT
User_ID
FROM Transactions
GROUP BY User_ID
HAVING COUNT(*)>1
)x;