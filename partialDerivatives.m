function partialDerivatives(map)

    scale = -10^3/(1.93*10^-12);
    %scale = -10^3/(4.29*10^-12);
    map.mean = 1*map.mean + scale.*map.meanStim;

    nList = 64 + [2:-1:-2]*10;

    colormap(fireAndIce);

    dAdP = (map.mean(1:end,2:end) - map.mean(1:end,1:(end-1)))/(map.posBins(2)-map.posBins(1));
    dAdP(:,end+1) = NaN.*zeros(size(map.mean,1),1);
    
    dAdV = (map.mean(2:end,1:end) - map.mean(1:(end-1),1:end))/(map.velBins(2)-map.velBins(1));
    dAdV(end+1,:) = NaN.*zeros(1,size(map.mean,1));
    
    dAdPNaNs = 1 - isnan(dAdP);
    dAdVNaNs = 1 - isnan(dAdV);
    
    subplot(2,1,1);
    h = image(map.posBins,map.velBins,-dAdP,'CDataMapping','scaled','AlphaData',dAdPNaNs);
    set(gca,'YDir','normal'); hold on;
    set(h, 'ButtonDownFcn', {@figureClick, map});
    maxLim = 3*10^7;
    caxis([-1 1].*maxLim);
    xlabel('X (mm)'); ylabel('dX/dt (mm/sec)');
    title('Stiffness -(mm/s^2)/(mm) = -1/s^2');
    axis square;
    

    
    subplot(2,1,2);
    h = image(map.posBins,map.velBins,-dAdV,'CDataMapping','scaled','AlphaData',dAdVNaNs);
    set(gca,'YDir','normal'); hold on;
    set(h, 'ButtonDownFcn', {@figureClick, map});
    maxLim = 2*10^4;
    caxis([-1 1].*maxLim)
    xlabel('X (mm)'); ylabel('dX/dt (mm/sec)');
    title('Damping (mm/s^2)/(mm/s) = 1/s');  
    axis square;

    
end
    

function figureClick(obj, event, system)
    cp = get(gca,'CurrentPoint');
    xO = cp(1,1);
    yO = cp(1,2);
    integrateSystem(xO,yO,system);
end
    
function integrateSystem(xO, yO, system)
    disp('Started integration...');
    t = linspace(0,.01,200);
    options = odeset('AbsTol',[.001,.00002]);
    [T,Y] = ode45(@(t,y) vdp(t,y,system),t,[xO yO],options);
    plot(Y(:,1),Y(:,2),'k'); hold on;
    scatter(Y(1,1),Y(1,2),'.k');
    disp('Finished integration.');
end

function dy = vdp(t, y, system)
    t
    posN = dsearchn(system.posBins', y(1));    
    velN = dsearchn(system.velBins', y(2));
    
    % If you don't find a valid accelleration, reach out into
    % surrounding cells and average them.
    reach = 0;
    accelList = [];
    while (length(accelList) < 1)
        for dP = -reach:reach
            for dV = -reach:reach
                if (  ((velN+dV) > 0) &&...
                      (velN+dV < size(system.mean,1)) && ...
                      ((posN+dP)>0) && ...
                      (posN+dP < size(system.mean,2)))
                    accel = system.mean(velN+dV,posN+dP);
                    if ~isnan(accel)
                        accelList = [accelList,accel];
                    end
                end
            end
        end
        reach = reach+1;
    end
    accel = mean(accelList);
        
    dy = zeros(2,1);    % a column vector
    dy(1) = y(2);
    dy(2) = accel;
end