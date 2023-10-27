% Limpieza inicial
clc
clear
clf

% Crear la figura de la interfaz de usuario
fig = uifigure('Name', 'Simulación del Volcán', 'Position', [100 100 500 500]);
fig.Color = [0.8 0.8 0.8]; % Cambia el color de fondo a gris claro

% Crear un panel para los controles de entrada
inputPanel = uipanel(fig, 'Title', 'Parámetros de entrada', 'Position', [20 340 200 150]);
inputPanel.BackgroundColor = [0.9 0.9 0.9]; % Cambia el color de fondo del panel a gris más claro

% Crear los controles de entrada
v0Edit = uieditfield(inputPanel, 'numeric', 'Position', [100 100 100 20], 'Value', 138.9);
u0Edit = uieditfield(inputPanel, 'numeric', 'Position', [100 70 100 20], 'Value', 5426);
angEdit = uieditfield(inputPanel, 'numeric', 'Position', [100 40 100 20], 'Value', 60);
dEdit = uieditfield(inputPanel, 'numeric', 'Position', [100 10 100 20], 'Value', 0.4);

% Crear las etiquetas para los controles de entrada
v0Label = uilabel(inputPanel, 'Text', 'Velocidad inicial:', 'Position', [10 100 90 20]);
u0Label = uilabel(inputPanel, 'Text', 'Altura inicial:', 'Position', [10 70 90 20]);
angLabel = uilabel(inputPanel, 'Text', 'Ángulo de disparo:', 'Position', [10 40 90 20]);
dLabel = uilabel(inputPanel, 'Text', 'Diámetro de la roca:', 'Position', [10 10 90 20]);

% Crear un botón para iniciar la simulación
startButton = uibutton(fig, 'push',...
    'ButtonPushedFcn', @(btn,event) startSimulation(v0Edit.Value, u0Edit.Value, angEdit.Value, dEdit.Value),...
    'Position',[70,300,100,22],...
    'Text','Iniciar Simulación');
startButton.BackgroundColor = [0.2,0.6,1]; % Cambia el color del botón a azul
startButton.FontColor = [1,1,1]; % Cambia el color del texto del botón a blanco

% Definir la función que se ejecuta cuando se presiona el botón
function startSimulation(v0, y0, ang, d)
    clf; % Limpia la figura antes de dibujar un nuevo volcán
    
    % Aquí va el código de tu simulación utilizando los valores ingresados en la interfaz gráfica.
    % Por ejemplo:
    g=9.8;
    c=0.25*d^2;
    v0x=v0*cosd(ang);
    v0y=v0*sind(ang);
    m=55;
    
    n = 5;
    diam = 250;
    base = n * diam;
    
    % Dibujo del volcán
    x_volcan = [0 (base/2) - (diam/2) (base/2) + (diam/2) base];
    y_volcan = [0 y0 y0 0];
    fill(x_volcan,y_volcan,[0.5 0.5 0.5]) % Color gris para el volcán

    hold on

    d1 = (base/2) - (diam/2);
    d2 = (base/2) + (diam/2);

    x0 = randi([d1 d2]);

    % Inicialización de vectores
    t0=0;
    tf=90;
    dt=0.01;
    t=t0:dt:tf;
    np=length(t);
    y=zeros(1,np);
    x=zeros(1,np);
    vy=zeros(1,np);
    vx=zeros(1,np);

   %Valores iniciales
   y(1)=y0;
   vx(1)=v0x;
   x(1)=x0;
   vy(1)=v0y;

   % Método de Euler
   for j=1:np-1
       vx(j+1)=vx(j)+(dt*((-c/m)*vx(j)*sqrt((vx(j)^2)+(vy(j)^2))));
       x(j+1)=x(j)+dt*vx(j);

       vy(j+1)=vy(j)+(dt*((-c/m)*vy(j)*sqrt((vx(j)^2)+(vy(j)^2))-g));
       y(j+1)=y(j)+dt*vy(j);

       if y(j+1) < 0
           y(j+1) = 0;
       end
   end

   comet(x,y)

   for j=1:np-1
       vx(j+1)=vx(j);
       x(j+1)=x(j)+dt*vx(j);

       vy(j+1)=vy(j)-dt*g;
       y(j+1)=y(j)+dt*vy(j);

       if y(j+1) < 0
           y(j+1) = 0;
           x(j+1) = x(j);
       end
   end

   comet(x,y)
end
