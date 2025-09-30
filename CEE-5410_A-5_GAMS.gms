* CEE 5410: Water Resources System Analysis *
* ASSIGNMENT 5: Hydropower and Irrigation Optimization via GAMS *
* 9/23/2025 *

* INPUT DATA *
* Monthly - inflow volume             - VIx
* Monthly - hydropower unit price     - rHx
* Monthly - irrigation unit price     - rFx

* MONTH (x)     INFLOW (VIx)   HYDROPOWER PRICE (rHx)   IRRIGATION PRICE (rFx)
* 1             
* 2         
* 3         
* 4         
* 5         
* 6         

* DECISION VARIABLES *
* Volume to irrigation     - VFx
* Volume through turbine   - VHx
* Volume through spillway  - VSx
* Volume through A         - VAx
* Volume in reservoir      - VRx

* OBJECTIVE FUNCTION *
* Maximize revenue from irrigation and hydropower.
* Max R() = SUM(rFx * vFx + rPx * vPx) for all x

* CONSTRAINT EQUATIONS *
* Reservoir Mass Balance:       VRx-1 + VIx - VPx - VSx = VRx
* Hydropower Ceiling:           VPm <= 4 for all x
* Flow at Point A:              VAx >= 1 for all x
* Reservoir Capacity:           VSx <= 9 for all x
* Diversion Mass Balance:       VIx + VAx = VSx + VHx
* Final Month's Storage:        VR6 >= VR0
* Starting Reservoir Volume:    VR0 = 5
* Non-negativity:               

* In total, there are 30 decision variables and 62 unique constraint equations for this problem!

             
* STEP ONE: Define Sets *
SETS    location /inflow, storage, turbine, spillway, irrig, pointA, pointC/
        month /mth1*mth6/;

* STEP TWO: Define input data *
SCALAR  TURBINEMAX Maximum flow through turbine per month /4/
        AFLOWMIN Minimum flow through point A per month /1/
        RESMAX Maximum storage capacity of reservoir /9/;

PARAMETERS  powerPrice(month)
               /mth1 1.6
                mth2 1.7
                mth3 1.8
                mth4 1.9
                mth5 2
                mth6 2/
                
            irrigPrice(month)
               /mth1 1.0
                mth2 1.2
                mth3 1.9
                mth4 2
                mth5 2.2
                mth6 2.2/
                
            inflow(month) Right hand constraints (avilible units of water each month)
               /mth1 2,
                mth2 2,
                mth3 3,
                mth4 4,
                mth5 3,
                mth6 2/
                
            storage(month)
               /;           
            
    
* STEP TWO: Define variables *

VARIABLES   X(location, month) ALl volume per month
            PROFIT Objective function value ($)

POSITIVE VARIABLES X;



* STEP 4: Use variables and data to set constraints

EQUATIONS
    PROFIT      Total profit ($) aka the objective function value.
    RESBALANCE  Volume of reservoir during months 1 to 5.
    RESFINAL    Minimum volume in storage at end of month 6;

    PROFIT..                VPROFIT =E= SUM(month, powerPrice(month)*X("turbine", months) + irrigPrice(month)*X("irrig", months))
    TURBINEMAX(month)..     X("turbine", month) =L= TURBINEMAX
    AMINFLOW(month)..       X("pointA", month)  =G= AFLOWMIN
    RESBALANCE(month)$(ord(month) lt 6)..     X("storage", month) + inflow(month) - X("turbine", month) =E= X("storage", month+1)
    RESBALANCE("mth6")..        X("storage", "mth6") + inflow("mth6") - X("turbine", "mth6") - X("spillway", "mth6") =E= 
    

     
