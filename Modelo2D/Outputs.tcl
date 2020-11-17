# OUTPUTS

	# # Displacements
	# file mkdir $Outputs/Displacement
	# recorder Node -file $Outputs/Displacement/nodesdisp.out -time  -nodeRange 1 "$::NodeEnd" -dof 1 2 3 4 5 6  disp;
	# recorder Node -file $Outputs/Displacement/disp10.out    -node 10 -dof 1 2 3 4 5 6  disp; 
	
# Accelerations
file mkdir $Outputs/Acceleration
#recorder Node -file $Outputs/Acceleration/acc5.out  -time   -node 3 -dof  1 2 3 accel;
#recorder Node -file $Outputs/Acceleration/acc10.out  -time   -node 2 -dof  1 2 3 accel;
recorder Node -file $Outputs/Acceleration/acc5.out  -time   -node 3 -dof  1 accel;
	
# Reactions
file mkdir $Outputs/Reactions
#recorder Node -file $Outputs/Reactions/node1reac.out -time -node 1 -dof 1 2 3 reaction
#recorder Node -file $Outputs/Reactions/node4reac.out -time -node 4 -dof 1 2 3 reaction
recorder Node -file $Outputs/Reactions/node1reac.out -time -node 1 4 -dof 1 reaction
	
# 	# Section Forces
# 	file mkdir $Outputs/SectionForce
# 	recorder Element -file $Outputs/SectionForce/ele1sec1force.out   -time   -ele 1 force; 	
# 	recorder Element -file $Outputs/SectionForce/ele2sec1force.out   -time   -ele 2 force; 	
# 	recorder Element -file $Outputs/SectionForce/ele3sec1force.out   -time   -ele 3 force; 
	
# Section Forces
file mkdir $Outputs/Beams
recorder Element -file $Outputs/Beams/ele5gp1force.out -ele 5 force;

# recorder Element -file $Outputs/Beams/ele1gp1def.out -ele 1 section 1 deformation; 
# recorder Element -file $Outputs/Beams/ele5gp1def.out -ele 5 section 1 deformation; 

# Salida de Vector modales
file mkdir $Outputs/Modos

# Salida de matrices de masas y rigideces:	
	#file mkdir $Outputs/Matrices

#Salida de PushOver
file mkdir $Outputs/PushOver
recorder Element -file $Outputs/PushOver/Rotulas_fuerzas.txt -time -ele 7 force;
recorder Element -file $Outputs/PushOver/Rotulas_deformacion.txt -time -ele 7 deformation;
recorder Element -file $Outputs/PushOver/Columnas_fuerzas.txt -time -ele 1 globalForce;
recorder Element -file $Outputs/PushOver/Columnas_rotaciones.txt -time -ele 1 chordRotation;


