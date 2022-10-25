% Fuzzy Control for washer
ctlr = mamfis('Name', 'washer');

% Add Input Variable 'st' to fuzzy system
ctlr = addInput(ctlr,[0 100],"Name","st");

% Set Membership Function of the language variable 'st' Stain
ctlr = addMF(ctlr, "st", 'trimf', [0,0,50],     "Name", 'SD');
ctlr = addMF(ctlr, "st", 'trimf', [0,50,100],   "Name", 'MD');
ctlr = addMF(ctlr, "st", 'trimf', [50,100,100], "Name", 'LD');

% Add Input Variable 'ax' to fuzzy system
ctlr = addInput(ctlr,[0 100],"Name","ax");

% Set Membership Function of the language variable 'ax' Axunge
ctlr = addMF(ctlr, "ax", 'trimf', [0,0,50],     "Name", 'NG');
ctlr = addMF(ctlr, "ax", 'trimf', [0,50,100],   "Name", 'MG');
ctlr = addMF(ctlr, "ax", 'trimf', [50,100,100], "Name", 'LG');

% Add Output Variable 'u' to fuzzy system
ctlr = addOutput(ctlr,[0 60],"Name","u");

% Set Membership Function of the language variable 'u' Time
ctlr = addMF(ctlr, "u", 'trimf', [0,0,10]  , "Name", 'VS');
ctlr = addMF(ctlr, "u", 'trimf', [0,10,25] , "Name", 'S' );
ctlr = addMF(ctlr, "u", 'trimf', [10,25,40], "Name", 'M' );
ctlr = addMF(ctlr, "u", 'trimf', [25,40,60], "Name", 'L' );
ctlr = addMF(ctlr, "u", 'trimf', [40,60,60], "Name", 'VL');

% Set Rule base
rulelist=[1 1 1 1 1;                            %Edit rule base
   		  1 2 3 1 1;
          1 3 4 1 1;
          
          2 1 2 1 1;
          2 2 3 1 1;
          2 3 4 1 1;
          
          3 1 3 1 1;
          3 2 4 1 1;
          3 3 5 1 1];

ctlr = addRule(ctlr, rulelist);

showrule(ctlr)

% Use Centroid Defuzz Method
ctlr.DefuzzificationMethod = 'mom';
ctlr.DefuzzificationMethod

% Write
writeFIS(ctlr, 'wash');

figure(1);
hold on;

plotfis(ctlr);
figure(2);
plotmf(ctlr,'input',1);
title('stain membership function');
xlabel('stain(g)');
grid on;
figure(3);
plotmf(ctlr,'input',2);
title('axunge membership function');
xlabel('axunge(g)');
grid on;
figure(4);
plotmf(ctlr,'output',1);
title('washing time membership function');
xlabel('washing time(min)');
grid on;