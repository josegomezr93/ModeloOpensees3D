set masaViga [expr $massSv1 * $vano];
set masaPilar [expr $massSv2 * $h];

mass 1 0.0 0.0 0.0 0.0 0.0 0.0;
mass 2 [expr $masaViga + $masaPilar] 0.0 [expr $masaViga + $masaPilar] 0.0 0.0 0.0;
mass 3 [expr $masaViga + $masaPilar/2.0] 0.0 [expr $masaViga + $masaPilar/2.0] 0.0 0.0 0.0;
mass 4 0.0 0.0 0.0 0.0 0.0 0.0;
mass 5 [expr $masaViga + $masaPilar] 0.0 [expr $masaViga + $masaPilar] 0.0 0.0 0.0;
mass 6 [expr $masaViga + $masaPilar/2.0] 0.0 [expr $masaViga + $masaPilar/2.0] 0.0 0.0 0.0;
mass 7 0.0 0.0 0.0 0.0 0.0 0.0;
mass 8 [expr $masaViga + $masaPilar] 0.0 [expr $masaViga + $masaPilar] 0.0 0.0 0.0;
mass 9 [expr $masaViga + $masaPilar/2.0] 0.0 [expr $masaViga + $masaPilar/2.0] 0.0 0.0 0.0;
mass 10 0.0 0.0 0.0 0.0 0.0 0.0;
mass 11 [expr $masaViga + $masaPilar] 0.0 [expr $masaViga + $masaPilar] 0.0 0.0 0.0;
mass 12 [expr $masaViga + $masaPilar/2.0] 0.0 [expr $masaViga + $masaPilar/2.0] 0.0 0.0 0.0;
mass 13 12.0 0.0 12.0 0.0 0.0 0.0;
mass 14 9.0 0.0 9.0 0.0 0.0 0.0;

mass 15 0.0 0.0 0.0 0.0 0.0 0.0;
mass 16 0.0 0.0 0.0 0.0 0.0 0.0;
mass 17 0.0 0.0 0.0 0.0 0.0 0.0;
mass 18 0.0 0.0 0.0 0.0 0.0 0.0;
mass 19 0.0 0.0 0.0 0.0 0.0 0.0;
mass 20 0.0 0.0 0.0 0.0 0.0 0.0;
mass 21 0.0 0.0 0.0 0.0 0.0 0.0;
mass 22 0.0 0.0 0.0 0.0 0.0 0.0;

mass 23 0.0 0.0 0.0 0.0 0.0 0.0;
mass 24 0.0 0.0 0.0 0.0 0.0 0.0;
mass 25 0.0 0.0 0.0 0.0 0.0 0.0;
mass 26 0.0 0.0 0.0 0.0 0.0 0.0;
mass 27 0.0 0.0 0.0 0.0 0.0 0.0;
mass 28 0.0 0.0 0.0 0.0 0.0 0.0;
mass 29 0.0 0.0 0.0 0.0 0.0 0.0;
mass 30 0.0 0.0 0.0 0.0 0.0 0.0;