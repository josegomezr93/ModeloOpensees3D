element nonlinearBeamColumn 	1 	1 	2 	$np 	$Sv2fibra 	$Tcol;	
element nonlinearBeamColumn		2 	4 	5 	$np 	$Sv2fibra 	$Tcol;
element nonlinearBeamColumn 	3 	7 	8 	$np 	$Sv2fibra 	$Tcol;	
element nonlinearBeamColumn 	4 	10 	11 	$np 	$Sv2fibra 	$Tcol;
element nonlinearBeamColumn 	5 	2 	3  	$np 	$Sv2fibra 	$Tcol;	
element nonlinearBeamColumn 	6 	5 	6  	$np 	$Sv2fibra 	$Tcol;
element nonlinearBeamColumn 	7 	8 	9  	$np 	$Sv2fibra 	$Tcol;	
element nonlinearBeamColumn 	8 	11 	12  $np 	$Sv2fibra 	$Tcol;

element elasticBeamColumn 	9 	15	16 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
element elasticBeamColumn 	10 	17	18 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;
element elasticBeamColumn 	11 	20	19 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
element elasticBeamColumn 	12 	22	21 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;
element elasticBeamColumn 	13 	23	24 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
element elasticBeamColumn 	14 	25	26 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;
element elasticBeamColumn 	15 	28	27 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
element elasticBeamColumn 	16 	30	29 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;

element zeroLength 17 2 15 -mat $::Muelle -dir 6;
element zeroLength 18 5 16 -mat $::Muelle -dir 6;
element zeroLength 19 5 17 -mat $::Muelle -dir 4;
element zeroLength 20 8 18 -mat $::Muelle -dir 4;
element zeroLength 21 8 19 -mat $::Muelle -dir 6;
element zeroLength 22 11 20 -mat $::Muelle -dir 6;
element zeroLength 23 11 21 -mat $::Muelle -dir 4;
element zeroLength 24 2 22 -mat $::Muelle -dir 4;
element zeroLength 25 3 23 -mat $::Muelle -dir 6;
element zeroLength 26 6 24 -mat $::Muelle -dir 6;
element zeroLength 27 6 25 -mat $::Muelle -dir 4;
element zeroLength 28 9 26 -mat $::Muelle -dir 4;
element zeroLength 29 9 27 -mat $::Muelle -dir 6;
element zeroLength 30 12 28 -mat $::Muelle -dir 6;
element zeroLength 31 12 29 -mat $::Muelle -dir 4;
element zeroLength 32 3 30 -mat $::Muelle -dir 4;


#element beamWithHinges $eleTag $iNode $jNode $secTagI $Lpi $secTagJ $Lpj $E $A $Iz $Iy $G $J $transfTag <-mass $massDens> <-iter $maxIters $tol>

# element beamWithHinges 	9 	2	5  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbz;
# element beamWithHinges 	10 	5	8  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbx;
# element beamWithHinges 	11 	11	8  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbz;
# element beamWithHinges 	12 	2	11  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbx;
# element beamWithHinges 	13 	3	6  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbz;
# element beamWithHinges 	14 	6	9  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbx;
# element beamWithHinges 	15 	12	9  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbz;
# element beamWithHinges 	16 	3	12  $Sv1 $Sv1 $IzSv1 $IySv1 $Gs $Tbx;