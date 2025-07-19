-- 1) List the names of all customers in the database.
Select customername from customers;

-- 2) Retrieve the names and prices of all products that cost less than $15.
select ProductName,price from products
where price<15;

-- 3)Display all employees’ first and last names.
select FirstName,Lastname from employees;

-- 4)List all orders placed in the year 1997.
select * from orders
where year(orderDate) = '1997';

-- 5)List all products that have a price greater than $50..
select * from products
where price > 50;

-- 6)Show the names of customers and the names of the employees who handled their orders.
select o.orderId,c.CustomerName,e.FirstName As EmployeeName
from orders o
join customers c on o.customerId = c.customerid
join employees e on o.employeeid = e.employeeid;

-- 7)List each country along with the number of customers from that country.
select country,count(customerID) as No_of_Customers from customers
group by country;

-- 8)Find the average price of products grouped by category
select c.CategoryName,avg(p.price) As AvgPrice
from Products p
join categories c on p.categoryID = c.categoryID
group by c.categoryName;

-- 9)Show the number of orders handled by each employee.
select e.FirstName, e.LastName, count(o.orderID) As NoOfOrders
from orders o
join employees e on o.employeeID = e.employeeID
group by e.employeeID;

-- 10)List the names of products supplied by "Exotic Liquids".
select s.SupplierName, p.ProductName from Products p
join suppliers s 
on p.supplierID = s.SupplierID
where s.supplierID = 1;

-- 11) List the top 3 most ordered products (by quantity)
select * from
(select p.ProductName, o.Quantity, 
dense_rank() over(order by o.quantity desc) as TopProduct
from orderdetails o
join products p on o.productid = p.productid) as top
where TopProduct<=3;

-- 12)Find customers who have placed orders worth more than $10,000 in total.

select c.CustomerName, Sum((P.price * od.quantity)) as TotalPurchase
from customers c
join orders o on c.customerID = o.CustomerID
join orderdetails od on o.orderid = od.orderid
join products p on od.productid = p.productid
group by c.customername having TotalPurchase>10000
order by TotalPurchase desc;

-- 13) Display order IDs and total order value for orders that exceed $2,000 in value.

select o.orderid, Sum((P.price * od.quantity)) as TotalPurchase
from orders o
join orderdetails od on o.orderid = od.orderid
join products p on od.productid = p.productid
group by o.orderid having TotalPurchase>2000
order by TotalPurchase desc;

-- 14) Find the name(s) of the customer(s) who placed the largest single order (by value).

With MaxOrders as(select c.customerID, Max((P.price * od.quantity)) as MaxOrder
from customers c
join orders o on c.customerID = o.CustomerID
join orderdetails od on o.orderid = od.orderid
join products p on od.productid = p.productid
group by customerID
order by maxorder desc),
RankOrder as( Select customerID,MaxOrder, dense_rank() over(order by MaxOrder desc) as Order_Rank
from Maxorders)
select c.customerName from RankOrder ro
join customers c on ro.customerID = c.CustomerID
where Order_Rank =1;

-- 15) Get a list of products that have never been ordered.

select ProductId,ProductName from products 
where ProductID Not In(select Distinct(ProductID) from orderdetails) ;






