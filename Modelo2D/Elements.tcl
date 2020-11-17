#Definimos los elementos

#Pilares
element nonlinearBeamColumn 1 1 2 $np $Sv2fibra $Trcol;
element nonlinearBeamColumn 2 2 3 $np $Sv2fibra $Trcol;
element nonlinearBeamColumn 3 4 5 $np $Sv2fibra $Trcol;
element nonlinearBeamColumn 4 5 6 $np $Sv2fibra $Trcol;


#Vigas
element elasticBeamColumn 	5 	2 	5 	$ASv1 	$Es 	$IzSv1 	$Trb;
element elasticBeamColumn 	6 	3 	6 	$ASv1 	$Es 	$IzSv1 	$Trb;

#Rotulas plasticas [-dof Dx Dy Dz Rx Ry Rz] "Tanto para 2D como para 3D"
element zeroLength 7 2 7 -mat $::Muelle -dir 6;
element zeroLength 8 5 9 -mat $::Muelle -dir 6;
element zeroLength 9 3 8 -mat $::Muelle -dir 6;
element zeroLength 10 6 10 -mat $::Muelle -dir 6;