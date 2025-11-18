$onText
CEE 6410 - Water Resources Systems Analysis
Assignment 4 - GAMS solution for hay/grain and truck/sedan problems

TRUCKS AND SEDANS

A motor vehicle company is planning production for the coming year. The company makes
Trucks and Sedans. The company will produce 10,000 vehicles total for the year. Vehicles
have the following components:

The company has purchased 14,000 fuel tanks. Trucks are made with 2 fuel tanks per vehicle; sedans have just one tank.
The company has purchased 18,000 rows of seats. Trucks have 1 row of seats per vehicle; sedans have two rows per vehicles.
The company has purchased 6,000 four-wheel drive systems. Trucks are built with 1 four-wheel drive system per vehicle. Sedans have none.
Trucks generate $100/vehicle while Sedans generate $110/vehicle.
$offText

* STEP 1: SET DEFINITIONS *

SETS vehicles number produced /truck, sedan/
     parts supply of parts /fuelTanks, seatRows, 4WDs, quota/;


* STEP 2: INPUT DATA *

PARAMETERS
    c(vehicles) Objective function coeffcients ($ per vehicle)
        /truck 100,
         sedan 110/
     
    b(parts) Right hand constraint values (availible quantity of parts)
        /fuelTanks 14000,
         seatRows  18000,
         4WDs      6000,
         quota     10000/;

TABLE A(vehicles, parts) Left hand side (constraint coefficients)
            fuelTanks   seatRows    4WDs    quota
    truck   2           1           1       1
    sedan   1           2           0       1


* STEP 3: DEFINE VARIABLES *

VARIABLES X(vehicles) vehicles produced (number)
          VPROFIT total profit;
          

* STEP 4: CONSTRAINTS *

* Nonnegaitivy
POSITIVE VARIABLES X;
        
* Supply related constraints
EQUATIONS
    PROFIT Total profit from vehicle production
    PART_CONSTRAIN(parts) Resource Constraints;
    
PROFIT..                VPROFIT =E= SUM(vehicles,c(vehicles) * X(vehicles));
PART_CONSTRAIN(parts).. SUM(vehicles, A(vehicles, parts) * X(vehicles)) =L= b(parts);


* STEP 5: DEFINE AND SOLVE MODEL *

MODEL PRODUCTION /ALL/;
SOLVE PRODUCTION USING LP MAXIMIZING VPROFIT;