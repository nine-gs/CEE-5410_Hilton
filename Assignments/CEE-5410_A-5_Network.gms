$onText
CEE 5410 Water Resource System Analysis
Assignment 5: Network Shipping Problem
9/30/2025

DIMENSIONS:
Manufacturers: Arnold, Super Shelf
Suppliers: Thomas, Wash-Burn
Recipient Firms: Zrox, Hewes, Rock-Wright

DECISION VARIABLES:
    1. Deliveries from Manufactures --> Suppliers (shelving units) (4 paths)
        xAT: shelving units shipped from Arnold to Thomas
        xAW: shelving units shipped from Arnold to Wash-Burn
        xST: shelving units shipped from Super Shelf to Thomas
        xSW: shelving units shipped from Super Shelf to Wash-Burn
        
    2. Deliveries from Suppliers --> Recipient Firms (shelving units) (6 paths)
        xTZ: shelving units shipped from Thomas to Zrox
        xTH: shelving units shipped from Thomas to Hewes
        xTR: shelving units shipped from Thomas to Rock-Wright
        xWZ: shelving units shipped from Wash-Burn to Zrox
        xWH: shelving units shipped from Wash-Burn to Hewes
        xWR: shelving units shipped from Wash-Burn to Rock-Wright

OBJECTIVE EQUATION:
    Minimize the cost of shipping shelving units from manufacturers to recipient firms.
    Specific Form : Min C = 5*xAT + 8*xAW + 7*xST + 4*xSW + 1*xTZ + 5*xTH + 8*xTR + 3*xWZ + 4*xWH + 4*xWR
    General Form:   Min C = SUM(cost*x[origin][dest])  **this could be split into separate summations for the two distinct stages of transport.


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


SETS routes /xAT, xAW, xST, xSW, xTZ, xWZ, xTH, xWH, xTR, xWR/
     nodes  /mA, mS, bT, bW, dZ, dH, dR/;
     
PARAMETERS
    c(routes)
       /xAT 5,
        xAW 8,
        xST 7,
        xSW 4,
        xTZ 1,
        xWZ 5,
        xTH 5,
        xWH 4,
        xTR 8,
        xWR 4/
        
    mfg(nodes)
       /mA 75,
        mS 75/
        
    demand(nodes)
       /dZ 50,
        dH 60,
        dR 40/;

TABLE A(routes,nodes) entering shelving units are negative and exiting units are positive
        mA  mS  bT  bW  dZ  dH  dR
xAT     1   0   -1  0   0   0   0
xAW     1   0   0   -1  0   0   0
xST     0   1   -1  0   0   0   0
xSW     0   1   0   -1  0   0   0
xTZ     0   0   1   0   -1  0   0
xTH     0   0   1   0   0   -1  0
xTR     0   0   1   0   0   0   -1
xWZ     0   0   0   1   -1  0   0
xWH     0   0   0   1   0   -1  0
xWR     0   0   0   1   0   0   -1;


   
VARIABLES X(routes) number of packages moved on route
          VCOST     total cost (USD);
          
POSITIVE VARIABLES X;

EQUATIONS
    COST
    FLOW_BAL(nodes);
    
*   Pro
    COST..      VCOST =E= SUM(routes, c(routes)*X(routes));
    
*   Sets a constraint if there is flow in or out of a node, excluding where there is no flow
    FLOW_BAL(nodes).. SUM(routes, A(routes,nodes)*X(routes)) =L= (mfg(nodes)$mfg(nodes)) - (demand(nodes)$demand(nodes));


MODEL OPTIMALNETWORK /ALL/;
SOLVE OPTIMALNETWORK USING LP MINIMIZING VCOST;

DISPLAY FLOW_BAL.L, FLOW_BAL.M;

