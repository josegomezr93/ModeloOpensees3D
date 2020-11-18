clear all, clc; close all
%Script para ploteo de resultados
choice = menu('Elige las graficas del analisis realizado', 'Analisis Gravitatorio', 'Pushover', 'Analisis Cronologico');

switch choice
    case 1
        cd('..\Modelo\SpaceFrame\Reactions');
        f1 = load('node1reac.out'); 
        f4 = load('node4reac.out');
        f7 = load('node7reac.out'); 
        f10 = load('node10reac.out');

        fuerzaZ_node1 = f1(:,4);
        fuerzaZ_node4 = f4(:,4);
        fuerzaZ_node7 = f7(:,4);
        fuerzaZ_node10 = f10(:,4);
        
    case 2
        cd('..\Modelo\SpaceFrame\Reactions');
        x1 = load('node1reac.out'); 
        x4 = load('node4reac.out');
        x7 = load('node7reac.out'); 
        x10 = load('node10reac.out');

        x1 = x1(:,2);
        x4 = x4(:,2);
        x7 = x7(:,2);
        x10 = x10(:,2);

        Cortante = x1 + x4 + x7 + x10;
        Cortante = -Cortante;
        
        cd('..\');
        cd('..\SpaceFrame\Displacement');
        nodeControl = load('nodesdispContr.out');
        nodeControl = nodeControl(:,2);

        figure()
        plot(nodeControl, Cortante);
        xlabel('Desplazamiento en el nodo Control [mm]'); ylabel('Cortante Basal [N]');
        title('Curva Pushover');
        grid on;
        
    case 3
        cd('..\Modelo\SpaceFrame\Reactions');
        x1 = load('node1reac.out'); 
        x4 = load('node4reac.out');
        x7 = load('node7reac.out'); 
        x10 = load('node10reac.out');

        x1 = x1(:,2);
        x4 = x4(:,2);
        x7 = x7(:,2);
        x10 = x10(:,2);

        Cortante = x1 + x4 + x7 + x10;
        Cortante = -Cortante;
        
        cd('..\');
        cd('..\SpaceFrame\Displacement');
        nodeControl = load('nodesdispContr.out');
        nodeControl = nodeControl(:,2);

        figure()
        plot(nodeControl, Cortante);
        xlabel('Desplazamiento en el nodo Control [mm]'); ylabel('Cortante Basal [N]');
        title('Curva de Histeresis (Fuerza - Desplazamiento)');
        grid on;

        cd('..\');
        cd('..\SpaceFrame\Acceleration');
        accNodeControl = load('nodesaccContr.out');
        accNodeControl = accNodeControl(:,2);

        figure()
        plot(accNodeControl,Cortante);
        xlabel('Aceleraciones [mm/s2]'); ylabel('Cortante Basal');
        title('Curva de Histeresis (Fuerza - Aceleraciones)');
        grid on;  
end

cd('..\..\'); %Me regreso a la carpeta de lectura de datos
cd('..\Resultados_Matlab');