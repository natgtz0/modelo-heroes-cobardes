clear; clc; close all;


num_agents   = 70;         
modo         = 'mixed';    
step_size    = 0.05;     
num_ticks    = 500;      
world_size   = 10;          

x = (rand(num_agents, 1) - 0.5) * 2 * world_size;
y = (rand(num_agents, 1) - 0.5) * 2 * world_size;

switch lower(modo)
    case 'brave'
        is_brave = true(num_agents, 1);
    case 'coward'
        is_brave = false(num_agents, 1);
    case 'mixed'
        is_brave = rand(num_agents, 1) < 0.5;
    otherwise
        error('Modo no válido. Usar: brave, coward o mixed.');
end

friend = zeros(num_agents, 1);
enemy  = zeros(num_agents, 1);
for i = 1:num_agents
    posibles_amigos = setdiff(1:num_agents, i);
    friend(i) = posibles_amigos(randi(length(posibles_amigos)));
    
    posibles_enemigos = setdiff(1:num_agents, [i, friend(i)]);
    enemy(i) = posibles_enemigos(randi(length(posibles_enemigos)));
end

figure('Name', 'Modelo de Héroes y Cobardes', 'Color', 'w');

for tick = 1:num_ticks
    new_x = x;
    new_y = y;
    
    for i = 1:num_agents
        fx = x(friend(i));   fy = y(friend(i)); 
        ex = x(enemy(i));    ey = y(enemy(i));  
        
        if is_brave(i)
            target_x = (fx + ex) / 2;
            target_y = (fy + ey) / 2;
        else
            target_x = fx + (fx - ex);
            target_y = fy + (fy - ey);
        end
        
        dx = target_x - x(i);
        dy = target_y - y(i);
        dist = sqrt(dx^2 + dy^2);
        
        if dist > 1e-6
            new_x(i) = x(i) + step_size * dx / dist;
            new_y(i) = y(i) + step_size * dy / dist;
        end
    end
    
    x = new_x;
    y = new_y;

    clf;
    hold on;
    valientes = is_brave;
    cobardes  = ~is_brave;
    scatter(x(valientes), y(valientes), 60, 'b', 'filled', 'MarkerEdgeColor', 'k');
    scatter(x(cobardes),  y(cobardes),  60, 'r', 'filled', 'MarkerEdgeColor', 'k');
    
    margin = 1;
    xlim([min(x)-margin, max(x)+margin]);
    ylim([min(y)-margin, max(y)+margin]);
    axis equal;
    grid on;
    box on;
    title(sprintf('Tick: %d | Modo: %s | N = %d  (Azul = Valiente, Rojo = Cobarde)', ...
        tick, modo, num_agents));
    xlabel('X'); ylabel('Y');
    
    drawnow;
    pause(0.01);
end

fprintf('\n=== Simulación terminada ===\n');
fprintf('Modo: %s\n', modo);
fprintf('Número de agentes: %d\n', num_agents);
fprintf('Valientes: %d  |  Cobardes: %d\n', sum(is_brave), sum(~is_brave));
fprintf('Iteraciones realizadas: %d\n', num_ticks);
