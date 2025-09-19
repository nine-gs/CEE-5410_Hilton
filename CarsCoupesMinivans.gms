$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
Modifies Example to add a labor constraint

THE PROBLEM:

A factory can produce two varieties of vehicle: coupes and minivans.
Coupes generate $6000 of profit, and minivans generate $7000.

The factory faces three constraints: it has 4 million pounds of metal, 12000 circuit boards, and 17500 man-hours of labor.
Coupes require 1000 lb of metal, 4 circuit boards, and 5 man-hours.
Minivans require 2000 lb of metal, 3 circuit boards, and 2.5 man hours. See the table below.

                Per Coupe         Per Minivan
Metal           1000 lb           2000 lb
Circuit Boards  4                 3 
Labor           5 hr              2.5 hr          
Profit          $6000             $7000
                
Determine the combination of coupes and minivans that maximizes profit.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

David E Rosenberg
david.rosenberg@usu.edu
September 15, 2015
$offtext

* 1. DEFINE the SETS
SETS vhcl varieties of car /Coupes, Minivans/
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
VARIABLES X(vhcl) vehicles produced (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) from producing cars
   RES_CONSTRAIN(res) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(vhcl, c(vhcl)*X(vhcl));
RES_CONSTRAIN(res) ..    SUM(vhcl, A(vhcl,res)*X(vhcl)) =L= b(res);


** "=E=" is an EQUALS operator. "=L=" is a LESS-THAN operator**

* 5. DEFINE the MODEL from the EQUATIONS
MODEL PRODUCTION /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PRODUCTION /ALL/;


* 6. SOLVE the MODEL
* Solve the PRODUCTION model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PRODUCTION USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
