%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   CLASE 15            %%%%%
%%%%%   Prof: Hermes Ponce  %%%%%
%%%%%   Fecha: 27/10/2020   %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;

Reloj = clock;                      % Nos devuelve un vector con la fecha y hora
Archivo_trabajo = pwd;              % Fijamos la carpeta actual de trabajo
diary off; 
delete('CommandWindows.txt');       % Eliminamos el fichero creado anteriormente
diary('CommandWindows.txt');        % Generamos un fichero que escribirá todo lo que aparezca en la ventana de comandos

%% EJECUTADOR DE OPENSEES
disp('Ejecutando OpenSees...')
disp(['Fecha de inicio: ',num2str(Reloj(3)),'/',num2str(Reloj(2)),'/',num2str(Reloj(1))])
disp(['Hora de inicio: ',num2str(Reloj(4)),':',num2str(Reloj(5))])

tic
!OpenSees_3.2.2 run.tcl        
Tiempo = toc;

fprintf('Tiempo de cálculo: %6.2f s\n',Tiempo)
diary off;                          % Cerramos el diario
