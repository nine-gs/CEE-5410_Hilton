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
* Max R() = SUM(rFx * vFx + rHx * vHx) for all x

* CONSTRAINT EQUATIONS *
* Reservoir Mass Balance:       VRx-1 + VIx - VHx - VSx = VRx
* Hydropower Ceiling:           VHm <= 4 for all x
* Flow at Point A:              VAx >= 1 for all x
* Reservoir Capacity:           VSx <= 9 for all x
* Diversion Mass Balance:       VIx + VAx = VSx + VHx
* Final Month's Storage:        VR6 >= VR0
* Starting Reservoir Volume:    VR0 = 5
* Non-negativity:               

* In total, there are 30 decision variables and 62 unique constraint equations for this problem!

             
* STEP ONE: Define Sets *
SETS    locations = /inflow, resStorage, hydro, irrig, pointA/
        months = /1, 2, 3, 4, 5, 6/
        hydroPrice = /1.6, 1.7, 1.8, 1.9, 2, 2/
        irrigPrice = /1.0, 1.2, 1.9, 2, 2.2, 2.2/;

* STEP TWO: Define input data *

PARAMETERS  c(vol) = hydroProject  



     
