# OUTPUTS

	# Displacements
# 	file mkdir $Outputs/Displacement
# 	recorder Node -file $Outputs/Displacement/nodesdisp.out -time  -nodeRange 1 "$::NodeEnd" -dof 1 2 3 4 5 6  disp;
# 	recorder Node -file $Outputs/Displacement/disp10.out    -node 10 -dof 1 2 3 4 5 6  disp; 
	
# 	# Accelerations
# 	file mkdir $Outputs/Acceleration
# 	recorder Node -file $Outputs/Acceleration/acc5.out  -time   -node 5 -dof  1 2 3 4 5 6  accel;
# 	recorder Node -file $Outputs/Acceleration/acc10.out  -time   -node 10 -dof  1 2 3 4 5 6  accel;
	
# Reactions
file mkdir $Outputs/Reactions
recorder Node -file $Outputs/Reactions/node1reac.out  -node 1 -dof 1 2 3 4 5 6 reaction 
recorder Node -file $Outputs/Reactions/node4reac.out  -node 4 -dof 1 2 3 4 5 6 reaction
recorder Node -file $Outputs/Reactions/node7reac.out  -node 7 -dof 1 2 3 4 5 6 reaction
recorder Node -file $Outputs/Reactions/node10reac.out  -node 10 -dof 1 2 3 4 5 6 reaction
	
# 	# Section Forces
# 	file mkdir $Outputs/SectionForce
# 	recorder Element -file $Outputs/SectionForce/ele1sec1force.out   -time   -ele 1 force; 	
# 	recorder Element -file $Outputs/SectionForce/ele2sec1force.out   -time   -ele 2 force; 	
# 	recorder Element -file $Outputs/SectionForce/ele3sec1force.out   -time   -ele 3 force; 
	
# Section Forces
file mkdir $Outputs/Beams
recorder Element -file $Outputs/Beams/ele1gp1force.out -ele 1 section 1 force; 
recorder Element -file $Outputs/Beams/ele1gp1def.out -ele 1 section 1 deformation;
recorder Element -file $Outputs/Beams/ele1gp1Localforce.out -time -ele 1 localForce;
#recorder Element -file $Outputs/Beams/ele1gp1fiber.txt -ele 1 section $secNum fiber $y $z stressStrain
recorder Element -file $Outputs/Beams/ele5gp1force.out -ele 5 section 1 force; 
recorder Element -file $Outputs/Beams/ele5gp1def.out -ele 5 section 1 deformation; 


# Salida de matriz de modos de vibración:	
file mkdir $Outputs/Modos

# # Salida de matrices de masas y rigideces:	
# 	file mkdir $Outputs/Matrices

