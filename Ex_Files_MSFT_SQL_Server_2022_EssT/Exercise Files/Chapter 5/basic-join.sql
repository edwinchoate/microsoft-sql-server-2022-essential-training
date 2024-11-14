SELECT
    Customer.FirstName, 
    Customer.LastName, 
    Orders.Quantity,
    Products.Name
FROM Customers
INNER JOIN Orders 
ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Products
ON Orders.ProductID = Products.ProductID;