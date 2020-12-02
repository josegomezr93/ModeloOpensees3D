clear all, clc, close all;
cd('..\Modelo\SpaceFrame\Beams');
       %Depuracion en el nodo 1
       idfile = 'ele1gp1force.out';
       fichero = fopen(idfile, 'r');
       i = 1;
       linea = 1;
       tline1 = fgetl(fichero);
       var1 = length(split(string(tline1)));
       fichero = fopen(idfile,'r');
       varCompr = 0;
       
        while (~feof(fichero))
            tline = fgetl(fichero);
            tline = string(tline);
            tline = split(tline);
            var = length(tline);
                if (var1 == var)
                    for j = 1:var
                        datos(i,j) = str2num(tline(j));
                    end
                elseif (var == 0)
                    display(linea);
                    i = i-1;
                elseif (var < var1)
                    display(linea)
                    i = i-1;
                end
            i = i+1;
            linea = linea + 1;
        end
        tamanio = size(datos);
        for k = 2: tamanio(1)
            if datos(k,1) < datos(k-1,1)
                display(k);
                datos(k:end) = [];
            end
        end
        x1 = datos(:,3);
        