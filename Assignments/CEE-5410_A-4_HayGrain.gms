$ontext
CEE 6410 - Water Resources Systems Analysis
Assignment 4 - GAMS solution for hay/grain and truck/sedan problems

HAY AND GRAIN

An aqueduct constructed to supply water to industrial users has an excess capacity in the months
of j, j, and a of 14,000 acft, 18,000 acft, and 6,000 acft, respectively. It is
proposed to develop not more than 10,000 acres of new land by utilizing the excess aqueduct
capacity for irrigation water deliveries. Two crops, hay and grain, are to be grown. Their
monthly water requirements and expected net returns are given in the following table:

                    Monthly water required (acft/acre)              Return per acre
                    j            j            a          
Hay                 2               1               1               100
Grain               1               2               0               120
Water Supply (acft) 14000           18000           6000
                
Determine the combination of hay and grain that maximizes profit.

$offtext

* STEP 1: SET DEFINITIONS *

SETS crops acres of crop /hay, grain/
     water acft per acre /june, july, august, land/;


* STEP 2: INPUT DATA *

PARAMETERS
   c(crops) Objective function coefficients ($ per acre of crop)
         /hay 100,
          grain 120/
         
   b(water) Right hand constraint values (availible water each month in acft)
          /june 14000,
           july 18000,
           august 6000
           land 10000/;

TABLE A(crops, water) Left hand side constraint coefficients
            june    july    august  land 
 hay        2       1       1       1
 grain      1       2       0       1


* STEP 3: DEFINE VARIABLES

VARIABLES X(crops) acres of crop planted (number)
          VPROFIT  total profit (USD);


* STEP 4: CONSTRAINTS *

* Non-negativity constraints
POSITIVE VARIABLES X;

* SUpply-related constraints
EQUATIONS
   PROFIT Total profit ($) from harvesting crops
   WTR_CONSTRAIN(water) Water Constraints;

PROFIT..                 VPROFIT =E= SUM(crops, c(crops)*X(crops));
WTR_CONSTRAIN(water) ..    SUM(crops, A(crops, water)*X(crops)) =L= b(water);


* 5. DEFINE AND SOLVE MODEL *

MODEL PRODUCTION /ALL/;
SOLVE PRODUCTION USING LP MAXIMIZING VPROFIT;