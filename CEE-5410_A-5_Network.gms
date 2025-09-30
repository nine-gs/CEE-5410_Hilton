$onText

Dimensions:
    1. Manufacturers
    2. Suppliers
    3. Recipient Firms
    
Decision Variables:
    1. Deliveries from Manufactures --> Suppliers (shelving units) (4 paths)
    2. Deliveries from Suppliers --> Recipient Firms (shelving units) (6 paths)
    
Objective Function
    Minimize the cost of shipping shelving units from manufacturers to recipient firms.
    Incorporates unit shipping costs.
    
Constraints:
    Recipient firm demand: Zrox = 50, Hewes = 60, Reck-Wright = 40.
    Suppliers must deliver as as much or less than they recieve.
    All shipment quantities need to be >= 0.



DIMENSIONS:
Manufacturers: Arnold, Super Shelf
Suppliers: Thomas, Wash-Burn
Recipient Firms: Zrox, Hewes, Rock-Wright

DECISION VARIABLES:
xAT: shelving units shipped from Arnold to Thomas
xAW: shelving units shipped from Arnold to Wash-Burn
xST: shelving units shipped from Super Shelf to Thomas
xSW: shelving units shipped from Super Shelf to Wash-Burn
xTZ: shelving units shipped from Thomas to Zrox
xTH: shelving units shipped from Thomas to Hewes
xTR: shelving units shipped from Thomas to Rock-Wright
xWZ: shelving units shipped from Wash-Burn to Zrox
xWH: shelving units shipped from Wash-Burn to Hewes
wWR: shelving units shipped from Wash-Burn to Rock-Wright

OBJECTIVE EQUATION:
Min C = 5*xAT + 8*xAW + 7*xST + 4*xSW + 1*xTZ + 5*xTH + 8*xTR + 3*xWZ + 4*xWH + 4*xWR
Min C = SUM(cost*x[origin][dest])  **this could be split into separate summations for the two distinct stages of transport.


CONSTRAINT EQUATIONS:
Specific form.......................General Form................................................Plain Language.................................................

1: xAT + xAW <= 75                  SUM(x[manufacturer][supplier]) <=  supply@manufacturer      Manufacturer form supply: Arnold = 75, Super-Shelf = 75
2: xST + xSW <= 75

3: xTZ + xWZ >= 50                  SUM(x[supplier][recipient]) >= demand@recipient             Recipient firm demand: Zrox = 50, Hewes = 60, Reck-Wright = 40.
4: xTH + xWH >= 60
5: xTR + xWR >= 40

6: xAT + xST >= xTZ + xTH + xTR     SUM(x[supplier][recipient]) >= SUM(x[supplier][recipient])  Suppliers must deliver as as much or less than they recieve.
7: xAW + xSW >= xWZ + xWH + xWR

8-17: [all x] >= 0                  x[origin][destination] >= 0                                 All shipment quantities need to be >= 0. No back shipments.

$offText





    
    
    