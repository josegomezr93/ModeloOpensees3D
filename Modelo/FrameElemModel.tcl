 #Elementos de plasticidad distribuida ---- Columnas
 element nonlinearBeamColumn 	1 	1 	2 	$np 	$Sv2 	$Tcol;	
 element nonlinearBeamColumn	2 	4 	5 	$np 	$Sv2 	$Tcol;
 element nonlinearBeamColumn 	3 	7 	8 	$np 	$Sv2 	$Tcol;	
 element nonlinearBeamColumn 	4 	10 	11 	$np 	$Sv2 	$Tcol;
 element nonlinearBeamColumn 	5 	2 	3  	$np 	$Sv2 	$Tcol;	
 element nonlinearBeamColumn 	6 	5 	6  	$np 	$Sv2 	$Tcol;
 element nonlinearBeamColumn 	7 	8 	9  	$np 	$Sv2 	$Tcol;	
 element nonlinearBeamColumn 	8 	11 	12  $np 	$Sv2 	$Tcol;

 #Elementos elasticos que se tomara en la plasticidad concentrada
 element elasticBeamColumn 	9 	14 	15 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
 element elasticBeamColumn 	10 	18 	19 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;
 element elasticBeamColumn 	11 	23 	22 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
 element elasticBeamColumn 	12 	27 	26 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;
 element elasticBeamColumn 	13 	30 	31 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
 element elasticBeamColumn 	14 	34 	35 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;
 element elasticBeamColumn 	15 	39 	38 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbz;
 element elasticBeamColumn 	16 	43 	42 	$ASv1 	$Es 	$Gs 	$ItSv1 	$IySv1 	$IzSv1 	$Tbx;

#element zeroLength $eleTag $iNode $jNode -mat $matTag1 $matTag2 ... -dir $dir1 $dir2 ...<-doRayleigh $rFlag> <-orient $x1 $x2 $x3 $yp1 $yp2 $yp3>
 
 element zeroLength 17 2 13 -mat $::Muelle -dir 6; 
 element zeroLength 18 5 16 -mat $::Muelle -dir 6;
 element zeroLength 19 5 17 -mat $::Muelle -dir 6;
 element zeroLength 20 8 20 -mat $::Muelle -dir 6;
 element zeroLength 21 8 21 -mat $::Muelle -dir 6;
 element zeroLength 22 11 24 -mat $::Muelle -dir 6;
 element zeroLength 23 11 25 -mat $::Muelle -dir 6;
 element zeroLength 24 2 28 -mat $::Muelle -dir 4;
 element zeroLength 25 3 29 -mat $::Muelle -dir 6;
 element zeroLength 26 6 26 -mat $::Muelle -dir 6;
 element zeroLength 27 6 27 -mat $::Muelle -dir 6;
 element zeroLength 28 9 28 -mat $::Muelle -dir 6;
 element zeroLength 29 9 29 -mat $::Muelle -dir 6;
 element zeroLength 30 12 40 -mat $::Muelle -dir 6;
 element zeroLength 31 12 41 -mat $::Muelle -dir 6;
 element zeroLength 32 3 44 -mat $::Muelle -dir 6;
