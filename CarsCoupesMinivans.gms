$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
Modifies Example to add a labor constraint

THE PROBLEM:

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
September 15, 2015
$offtext

* 1. DEFINE the SETS
SETS vhcl crops growing /Coupes, Minivans/
     res resources /Metal, CircBds, Labor/;

* 2. DEFINE input data
PARAMETERS
   c(vhcl) Objective function coefficients ($ per vehicle)
         /Coupes 6000,
         Minivans 7000/
         
   b(res) Right hand constraint values (per resource)
          /Metal 4000000,
           CircBds 12000,
           Labor  17500/;

TABLE A(vhcl,res) Left hand side constraint coefficients
               Metal     CircBds   Labor 
 Coupes        1000      4         5
 Minivans      2000      3         2.5;

* 3. DEFINE the variables
VARIABLES X(vhcl) plants planted (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(res) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(vhcl, c(vhcl)*X(vhcl));
RES_CONSTRAIN(res) ..    SUM(vhcl, A(vhcl,res)*X(vhcl)) =L= b(res);


* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;


* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANTING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
