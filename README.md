# SQL Practice Projects 📊

This repository contains a collection of small **SQL* projects I created to practice and improve my skills in database querying, design, and data analysis. Each project focuses on different SQL concepts and use cases.

---

## 🔧 Tools & Technologies
- **Database**: MySQL
- **Language**: SQL
- **Platform**: Local MySQL Workbench
- **Concepts Covered**: Joins, Aggregations, Window Functions

---

## 📁 Projects

## 1. 🛒 E-Commerce Database Project

**Concepts:** Joins, Aggregations, Window Functions

**Tables Created:**  
`Users`, `Orders`, `Products`, `Categories`, `Payments`, `Order_Items`

### 🔧 Tasks Performed:

- Top 5 selling products
- Users with highest spending
- Daily revenue tracking
- Returning vs. new customer analysis
- Use of window functions: `RANK()`, `ROW_NUMBER()`

---

### 📌 Query Highlights:

**i) Top 5 Selling Products**  
Join `order_items` and `products`, group by product, sum quantity, sort, and limit.

**ii) Users with Highest Spending**  
Join `users`, `orders`, and `payments`. Group by user, sum the amount, and sort.

**iii) Daily Revenue**  
Join `orders` and `payments`, group by order date, and sum the revenue.

**iv) Returning vs. New Customers**  
Check users with 1 vs. more than 1 order using `COUNT()` and subqueries.

**v) Window Functions**  
Use `RANK()` or `ROW_NUMBER()` to:
- Rank users by total spending
- Rank products by total sales

---
