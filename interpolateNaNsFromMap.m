function map = interpolateNaNsFromMap(map)

[row,col] = find(isnan(map.mean));


for n=randperm(length(row))
    n
    reach = 5;
    accelList = [];
    while (length(accelList) < 1)
        pList = -reach:reach;
        vList = -reach:reach;
        pOrder = randperm(2*reach+1);
        vOrder = randperm(2*reach+1);
        for dP = pList(pOrder)
            for dV = vList(vOrder)

                if (  ((row(n)+dV) > 0) &&...
                      (row(n)+dV < size(map.mean,1)) && ...
                      ((col(n)+dP)>0) && ...
                      (col(n)+dP < size(map.mean,2)))
                    accel = map.mean(row(n)+dV,col(n)+dP);
                    if ~isnan(accel)
                        accelList = [accelList,accel];
                    end
                end
            end
        end
        reach = reach+1;
    end
    map.mean(row(n),col(n)) = mean(accelList);

    
end


