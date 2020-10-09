--1/Create a PL/SQL block which displays the list of customers (all the informations)

DECLARE
v_customer Customer%rowtype;

BEGIN
SELECT * INTO v_customers
FROM Customer
dbms_output.put_line(v_customers.Customer_id ||' '|| v_customers.customer_Name ||' '|| v_customers.customer_Tel);
END;
/

--2/Create a Procedure PS_Customer_Prodcuts which displays the list of product names of a given customer
-- (customer_id)If no result returned (No_Data_Found exception raised), display the following message 
--“No products returned or customer not found”

DECLARE
CREATE OR REPLACE PROCEDURE PS_Customer_Prodcuts(v_customer_id Orders.customer_id%type)IS
CURSOR cur (v_customer_id number) IS 
SELECT product_name FROM Orders  
   INNER JOIN (
        Product ON Product.Product_id = Orders.Product_id,
        Customer ON Customer.Customer_id = Orders.Customer_id
    );
BEGIN

FOR rec IN cur LOOP
 dbms_output.put_line("the name of the product :"||rec.product_name) ;
END LOOP;

 IF(NO_DATA_FOUND) THEN
     dbms_output.put_line("No products returned or customer not found")  ;  
 END IF;
END;

--3/Create a Function FN_Customer_Orders which returns the number of orders of a given customer (customer_id).

CREATE OR REPLACE FUNCTION FN_Customer_Orders(v_customer_id Orders.customer_id%type) RETURN number IS
nb_con number:=0;
BEGIN
  SELECT COUNT(*) INTO nb_con FROM Orders WHERE Orders.customer_id = v_customer_id;
  RETURN nb_con;
END;


--4/Create a trigger TRIG_INS_ORDERS which starts before each INSERT on Orders tables and test
-- if the OrderDate >= SYSDATE. If not the following message is displayed “Order Date must be
-- greater than or equal to today's date”


CREATE TRIGGER TRIG_INS_ORDERS  BEFORE INSERT ON Orders FOR EACH ROW
BEGIN
 IF (:old.OrderDate >= SYSDATE) THEN
    dbms_output.put_line("Order Date must be greater than or equal to today's date");    
 END_IF;
    
END;
