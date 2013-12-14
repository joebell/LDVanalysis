function out = plotAccel(data)

    out = mapAccel(data);

    figure;
    NaNs = 1-isnan(out.mean);
    h = image(out.posBins,out.velBins,(out.mean),'CDataMapping','scaled','AlphaData',NaNs);
    set(gca,'YDir','normal');
    set(h, 'ButtonDownFcn', {@figureClick, out});
    xlabel('X (mm)'); ylabel('dX/dt (mm/sec)');
    title('Mean Acceleration');
    colorbar;
    hold on;
end




function figureClick(obj, event, system)
    cp = get(gca,'CurrentPoint');
    xO = cp(1,1);
    yO = cp(1,2);
    integrateSystem(xO,yO,system);
end
    
function integrateSystem(xO, yO, system)
    disp('Started integration...');
    t = linspace(0,.02,100);
    [T,Y] = ode45(@(t,y) vdp(t,y,system),t,[xO yO]);
    plot(Y(:,1),Y(:,2),'k'); hold on;
    scatter(Y(1,1),Y(1,2),'ok');
    disp('Finished integration.');
end

function dy = vdp(t, y, system)
    t
    posN = dsearchn(system.posBins', y(1));    
    velN = dsearchn(system.velBins', y(2));
        
    dy = zeros(2,1);    % a column vector
    dy(1) = y(2);
    dy(2) = system.mean(velN,posN);
end