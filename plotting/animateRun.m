function animateRun(data, p, name, file)

    f = figure();
    for i = 1:length(data.t)

        l = 0.2;
        h = 0.075;

        xa = data.x_truth(1,i);

        xc = data.x_truth(1,i) + p.lc*sin(data.x_truth(3,i));
        yc = p.lc*cos(data.x_truth(3,i));
        
        hold off
        % Goal
        xg = data.inputs.xd(1);
        plot([xg, xg], [-0.1, 0.25], 'b--', 'LineWidth', 5); hold on;
        plot([xg, xg, xg+ 0.1, xg], [0.2, 0.3, 0.25, 0.2], 'b-', 'LineWidth', 5)

        plot(data.x_truth(1,i), 0, 'ro'); % Base
        rectangle('position',[xa-l/2 -h l h], 'Curvature', 0.2, 'FaceColor','white')% Box
%         plot(data.x_truth(1,i) + p.lc*sin(data.x_truth(3,i)), p.lc*cos(data.x_truth(3,i)), 'bo') % Mass C
        circle(xc,yc,0.05);
        plot([data.x_truth(1,i), data.x_truth(1,i) + p.lc*sin(data.x_truth(3,i))], [0, p.lc*cos(data.x_truth(3,i))], 'color', 'black', 'LineWidth', 5) % Mass b
        xlim([data.x_truth(1,i)-p.lc, data.x_truth(1,i)+p.lc]);
%         ylim([-p.lc, p.lc])

        % Wheels
        circle(xa - l/3,-h,0.025);
        circle(xa + l/3,-h,0.025);

        % Floor
        plot([-10, 10], [-0.105, -0.105], 'Color', 'black', 'LineWidth', 5)

        ylim([-0.2, 0.5]);
        text(data.x_truth(1,i)-p.lc, 0.45, strjoin(['Time: ' string(data.t(i))]))
        grid on;
        title(name)
        
        figure(f)
        pause(.0005)

        if nargin >= 4
            exportgraphics(gcf,file,'Append',true);
        end
    end
end
function circle(x,y,r)
    ang=0:0.01:2*pi; 
    xp=r*cos(ang);
    yp=r*sin(ang);
    plot(x+xp,y+yp, 'color', 'black');
end