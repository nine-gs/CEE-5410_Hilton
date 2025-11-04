$ontext

Water Resource System Analysis - Bishop et al, 1999
Problem 7.1 - BOD removal optimization

    "We desire to minimize total cost of meeting  BOD level requirements at a point immediately 
    below each of five municipal wastewater treatment plants, as shown in Figure 7.1.  Treatment 
    may be either primary (50 percent BOD removal), secondary (80 percent removal), or tertiary 
    (95 percent removal).  Oxidation within the river will be ignored.  Cost and BOD requirement 
    data are given in Table 7.1.""
    
    Table 7.1:  BOD Waste Loading and Cost Data 
 
    City    BOD Load    Max. Allowed Residual            Cost($/lb BOD)
            lb/day      lb/day                  Primary     Secondary   Tertiary
            
    1       1200        300                     0.15        0.25        0.60 
    2       600         350                     0.20        0.35        0.75 
    3       2000        300                     0.12        0.18        0.55 
    4       500         350                     0.20        0.35        0.75 
    5       1000        400                     0.16        0.27        0.63
    

    City 1 -----> City 2 --\
                            }----> City 5 ----> Out
    City 3 -----> City 4 --|
    

$offText

SETS cities  /c1, c2, c3, c4, c5/
     bod     /load, maxBOD/
     treatmt /prim, sec, tert/;

PARAMETER quality /0.5, 0.8, 0.95/;

TABLE   A(cities, bod)
    load    maxBOD      
c1  1200    300         
c2  600     350         
c3  2000    300         
c4  500     350         
c5  1000    400;         

TABLE   B(cities,treatmt)
    prim    sec     tert
c1  0.15    0.25    0.60
c2  0.20    0.35    0.75
c3  0.12    0.18    0.55
c4  0.20    0.35    0.75
c5  0.16    0.27    0.63;
    



VARIABLES X(cities,treatmt)
          VCOST total cost;

POSITIVE VARIABLES X;

    COST
    LOAD_ALLOW
    PLANTS;
    
    COST..          VCOST =E= SUM(A(cities, "load") * (quality * B(cities,treatmt) * X(cities)))
    
    LOAD_ALLOW..    A(cities,load) * (1 - quality )