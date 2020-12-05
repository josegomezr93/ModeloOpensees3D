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

        fuerzaY_node1 = f1(:,3);
        fuerzaY_node4 = f4(:,3);
        fuerzaY_node7 = f7(:,3);
        fuerzaY_node10 = f10(:,3);
        pesoTotal = fuerzaY_node1 + fuerzaY_node7 + fuerzaY_node10;
        fprintf('Peso total [N]: %.3f\n', pesoTotal(end,1));
        
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
       cd('..\Modelo');
       registroAcc = load('Calitri_f200HzDirX.txt');
       nFilas = length(registroAcc);
       fMuestreo = input('Inserte la frecuencia de muestro del registro de Aceleraciones [Hz]: ');
       dt = 1/fMuestreo;
       tiempoFinal = (nFilas*dt) - dt;
       registroTiempo = [0:dt:tiempoFinal];
       
       figure()
       plot(registroTiempo, registroAcc);
        xlabel('Tiempo [s]'); ylabel('Aceleraciones [g]');
       title('Registro del acelerograma');
       grid on;
       
       cd('SpaceFrame\Reactions');
       reac1 = load('node1reac.out');
       reac4 = load('node4reac.out');
       reac7 = load('node7reac.out');
       reac10 = load('node10reac.out');
       x1 = reac1(:,2);
       x4 = reac4(:,2);
       x7 = reac7(:,2);
       x10 = reac10(:,2);
       Cortante = x1 + x4 + x7 + x10;
       Cortante = -Cortante;
       
       cd('..\');
       cd('..\SpaceFrame\Displacement');
       nodeControl = load('nodesdispContr.out');
       nodedisp14 = load('nodesdisp14.out');
       tiempo = nodeControl(:,1);
       nodedisp14 = nodedisp14(:,2);
       nodeControl = nodeControl(:,2);

       figure()
       plot(nodeControl, Cortante);
       xlabel('Desplazamiento en el nodo Control [mm]'); ylabel('Cortante Basal [N]');
       title('Curva de Histeresis (Fuerza - Desplazamiento)');
       grid on;
       
       figure()
       plot(tiempo, nodeControl);
       xlabel('Tiempo [s]'); ylabel('Desplazamiento en el nodo Control [mm]');
       title('Desplazamiento del nodo Control (Nodo 3)');
       grid on;
       
       
       cd('..\');
       cd('..\SpaceFrame\Acceleration');
       accNodeControl = load('nodesaccContr.out');
       accNodeControl = accNodeControl(:,2);
end

cd('..\..\'); %Me regreso a la carpeta de lectura de datos
cd('..\Resultados_Matlab');
