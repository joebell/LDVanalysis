function plotMap(out)


    figure; 
    colormap(fireAndIce);
    %colormap(jet);
    NaNs = 1*(1-isnan(out.mean));
    scale = 10^3/(1.93*10^-12);
    scale = 10^3/(4.29*10^-12);
    
    out.mean = 1*out.mean - scale.*out.meanStim;
    h = image(out.posBins,out.velBins,out.mean,'CDataMapping','scaled','AlphaData',NaNs);
    set(gca,'YDir','normal');
    set(h, 'ButtonDownFcn', {@figureClick, out});
    xlabel('X (mm)'); ylabel('dX/dt (mm/sec)');
    %title('Mean Acceleration');
    colorbar;
    hold on;
    
    caxis([-1 1]*max(abs(caxis())));

    
%     nList = 64 + [2:-1:-2]*10;
%     for n=nList
%         line(xlim(),[1 1]*out.velBins(n),'Color',[1 1 1]*.75);
%     end
%     for n=nList
%         line([1 1]*out.posBins(n),ylim(),'Color',[1 1 1]*.75);
%     end
    
end




function figureClick(obj, event, system)
    cp = get(gca,'CurrentPoint');
    xO = cp(1,1);
    yO = cp(1,2);
    integrateSystem(xO,yO,system);
    %alignFromMap(xO,yO,system);    
end
    
function integrateSystem(xO, yO, system)
    disp('Started integration...');
    t = linspace(0,.002,200);
    options = odeset('AbsTol',[.0001,.00001]);
    [T,Y] = ode45(@(t,y) vdp(t,y,system),t,[xO yO],options);
    plot(Y(:,1),Y(:,2),'k'); hold on;
    scatter(Y(1,1),Y(1,2),'.k');
    disp('Finished integration.');
end

function dy = vdp(t, y, system)
    %t
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