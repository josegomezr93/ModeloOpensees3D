 element nonlinearBeamColumn 	1 		1 	   2 		$np 		$Sv2 		  $Try;	
 element nonlinearBeamColumn 	2 		4 	   5 		$np 		$Sv2 		  $Try;
 element nonlinearBeamColumn 	3 		7 	   8 		$np 		$Sv2 		  $Try;	
 element nonlinearBeamColumn 	4 		10 	   11 		$np 		$Sv2 		  $Try;
 element nonlinearBeamColumn 	5 		2 	   3 		$np 		$Sv2 		  $Try;	
 element nonlinearBeamColumn 	6 		5 	   6 		$np 		$Sv2 		  $Try;
 element nonlinearBeamColumn 	7 		8 	   9 		$np 		$Sv2 		  $Try;	
 element nonlinearBeamColumn 	8 		11 	   12 		$np 		$Sv2 		  $Try;
 element elasticBeamColumn 	  9 	 14	 	15 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  10 	 18	 	19 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  11 	 23	 	22 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  12 	 27	 	26 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  13 	 30	 	31 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  14 	 34	 	35 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  15 	 39	 	38 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element elasticBeamColumn 	  16 	 43	 	42 	  $ASv1 $Es $Gs $ItSv1 $IySv1 $IzSv1 $Trz;
 element zeroLength  17 2 13 -mat $::Muelle -dir 5;
 element zeroLength 18 5  14 -mat $::Muelle -dir 5;
 element zeroLength 19 8 15 