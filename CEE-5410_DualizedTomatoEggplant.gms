$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
Modifies Example to add a labor constraint

Formulate and solve the PRIMAL and DUALs of THE PROBLEM:

An irrigated farm can be planted in two crops:  eggplants and tomatoes.  Data are as fol-lows:

Seasonal Resource
Inputs or Profit        Crops        Resource
Availability
        Eggplant        Tomatoes
Water        1x103 gal/plant        2x103 gal/plant      4x106 gal/year
Land        4 ft2/plant        3 ft2/plant               1.2x104 ft2
Labor         5hr/plant        2.5/hr plant              17,500 hours
Profit/plant        $6        $7
                Determine the optimal planting for the two crops.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

David E Rosenberg
david.rosenberg@usu.edu
September 20, 2020
$offtext

* 1. DEFINE the SETS
SETS plnt crops growing /Eggplant, Tomatoes/
     res resources /Water, Land, Labor/;

* 2. DEFINE input data
PARAMETERS
   c(plnt) Objective function coefficients ($ per plant)
         /Eggplant 6,
         Tomatoes 7/
   b(res) Right hand constraint values (per resource)
          /Water 4000000,
           Land  12000,
           Labor 17500 /;

TABLE A(plnt,res) Left hand side constraint coefficients
                 Water    Land  Labor     
 Eggplant        1000      4      5         
 Tomatoes        2000      3      2.5 ;     

* 3. DEFINE the variables
VARIABLES X(plnt) plants planted (Number)
          VPROFIT  total profit ($)
          Y(res)  value of resources used (units specific to variable)
          VREDCOST total reduced cost ($);

* Non-negativity constraints
POSITIVE VARIABLES X,Y;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT_PRIMAL Total profit ($) and objective function value
   RES_CONS_PRIMAL(res) Resource constraints
   REDCOST_DUAL Reduced Cost ($) associated with using resources
   RES_CONS_DUAL(plnt) Profit levels ;

*Primal Equations
PROFIT_PRIMAL..                 VPROFIT =E= SUM(plnt,c(plnt)*X(plnt));
RES_CONS_PRIMAL(res) ..    SUM(plnt,A(plnt,res)*X(plnt)) =L= b(res);

*Dual Equations
REDCOST_DUAL..                 VREDCOST =E= SUM(res,b(res)*Y(res));
RES_CONS_DUAL(plnt)..          sum(res,A(plnt,res)*Y(res)) =G= c(plnt);

X.LO(plnt) = 5;

* 5. DEFINE the MODELS
*PRIMAL model
MODEL PLANT_PRIMAL /PROFIT_PRIMAL, RES_CONS_PRIMAL/;
*Set the options file to print out range of basis information
PLANT_PRIMAL.optfile = 1;

*DUAL model
MODEL PLANT_DUAL /REDCOST_DUAL, RES_CONS_DUAL/;

* 6. SOLVE the MODELS
* Solve the PLANTING PRIMAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANT_PRIMAL USING LP MAXIMIZING VPROFIT;

* Solve the PLANTING DUAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANT_DUAL USING LP MINIMIZING VREDCOST;
*Order does not matter!

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file

* 7 . Dump all data and results to GAMS proprietary file storage .gdx and to Excel
Execute_Unload "Ex2-1Dual.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls Ex2-1Dual.gdx"
* To open the GDX file in the GAMS IDE, select File => Open.
* In the Open window, set Filetype to .gdx and select the file.