element nonlinearBeamColumn 	1 	1 	2 	$np 	$Sv2fibra 	$Tcol;	
element nonlinearBeamColumn		2 	4 	5 	$np 	$Sv2fibra 	$Tcol;
element nonlinearBeamColumn 	3 	7 	8 	$np 	$Sv2fibra 	$Tcol;	
element nonlinearBeamColumn 	4 	10 	11 	$np 	$Sv2fibra 	$Tcol;
element nonlinearBeamColumn 	5 	2 	3  	$np 	$Sv2fibra 	$Tcol;	
element nonlinearBeamColumn 	6 	5 	6  	$np 	$Sv2fibra 	$Tcol;
element nonlinearBeamColumn 	7 	8 	9  	$np 	$Sv2fibra 	$Tcol;	
element nonlinearBeamColumn 	8 	11 	12  $np 	$Sv2fibra 	$Tcol;

element elasticBeamColumn 	9 	2	5 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
element elasticBeamColumn 	10 	5	8 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;
element elasticBeamColumn 	11 	11	8 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
element elasticBeamColumn 	12 	2	11 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;
element elasticBeamColumn 	13 	3	6 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
element elasticBeamColumn 	14 	6	9 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;
element elasticBeamColumn 	15 	12	9 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
element elasticBeamColumn 	16 	3	12 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;

element zeroLength 17 15 2 -mat $::Muelle -dir 6;
element zeroLength 18 16 5 -mat $::Muelle -dir 6;
element zeroLength 19 17 5 -mat $::Muelle -dir 4;
element zeroLength 20 18 8 -mat $::Muelle -dir 4;
element zeroLength 21 19 8 -mat $::Muelle -dir 6;
element zeroLength 22 20 11 -mat $::Muelle -dir 6;
element zeroLength 23 21 11 -mat $::Muelle -dir 4;
element zeroLength 24 22 2 -mat $::Muelle -dir 4;
element zeroLength 25 23 3 -mat $::Muelle -dir 6;
element zeroLength 26 24 6 -mat $::Muelle -dir 6;
element zeroLength 27 25 6 -mat $::Muelle -dir 4;
element zeroLength 28 26 9 -mat $::Muelle -dir 4;
element zeroLength 29 27 9 -mat $::Muelle -dir 6;
element zeroLength 30 28 12 -mat $::Muelle -dir 6;
element zeroLength 31 29 12 -mat $::Muelle -dir 4;
element zeroLength 32 30 3 -mat $::Muelle -dir 4;


#element beamWithHinges $eleTag $iNode $jNode $secTagI $Lpi $secTagJ $Lpj $E $A $Iz $Iy $G $J $transfTag <-mass $massDens> <-iter $maxIters $tol>

# element beamWithHinges 	9 	2	5  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbz;
# element beamWithHinges 	10 	5	8  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbx;
# element beamWithHinges 	11 	11	8  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbz;
# element beamWithHinges 	12 	2	11  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbx;
# element beamWithHinges 	13 	3	6  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbz;
# element beamWithHinges 	14 	6	9  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbx;
# element beamWithHinges 	15 	12	9  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbz;
# element beamWithHinges 	16 	3	12  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbx;