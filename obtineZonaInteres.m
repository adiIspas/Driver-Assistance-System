function [ imagine_interes ] = obtineZonaInteres( imagine, start_x, end_x, start_y, end_y )
%obtineZonaInteres 

    portiune = imagine(start_y:end_y,start_x:end_x,:);
    mediaCulorii = mean(mean(portiune(:,:,:)));
    R = mediaCulorii(:,:,1);
    G = mediaCulorii(:,:,2);
    B = mediaCulorii(:,:,3);

    rezultat = ones(size(imagine))*255;
    for i = 1:size(imagine,1)
        for j = 1:size(imagine,2)
            if imagine(i,j,1) >= R - 35 && imagine(i,j,1) <= R + 35
                rezultat(i,j,1) = 0;
            end
            if imagine(i,j,2) >= G - 35 && imagine(i,j,2) <= G + 35
                rezultat(i,j,2) = 0;
            end
            if imagine(i,j,3) >= B - 35 && imagine(i,j,3) <= B + 35
                rezultat(i,j,3) = 0;
            end
        end
    end
    
    imagine_interes = uint8(rezultat);
end

