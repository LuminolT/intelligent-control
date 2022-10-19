% Mamdani Fuzzy System
ctlr = mamfis('Name', 'fuzzf');

% Add Input Variable 'e' to fuzzy system
ctlr = addInput(ctlr,[-0.3 0.3],"Name","e");

% Set Membership Function of the language variable 'e'
ctlr = addMF(ctlr, "e", 'zmf',    [-0.3,-0.1],     "Name", 'NB');
ctlr = addMF(ctlr, "e", 'trimf',  [-0.3,-0.2,0],   "Name", 'NM');
ctlr = addMF(ctlr, "e", 'trimf',  [-0.3,-0.1,0.1], "Name", 'NS');
ctlr = addMF(ctlr, "e", 'trimf',  [-0.2,0,0.2],    "Name", 'ZO');
ctlr = addMF(ctlr, "e", 'trimf',  [-0.1,0.1,0.3],  "Name", 'PS');
ctlr = addMF(ctlr, "e", 'trimf',  [0,0.2,0.3],     "Name", 'PM');
ctlr = addMF(ctlr, "e", 'smf',    [0.1,0.3],       "Name", 'PB');

% Add Input Variable 'ec' to fuzzy system
ctlr = addInput(ctlr,[-0.3 0.3],"Name","ec");

% Set Membership Function of the language variable 'ec'
ctlr = addMF(ctlr, "ec", 'zmf',    [-0.3,-0.1],     "Name", 'NB');
ctlr = addMF(ctlr, "ec", 'trimf',  [-0.3,-0.2,0],   "Name", 'NM');
ctlr = addMF(ctlr, "ec", 'trimf',  [-0.3,-0.1,0.1], "Name", 'NS');
ctlr = addMF(ctlr, "ec", 'trimf',  [-0.2,0,0.2],    "Name", 'ZO');
ctlr = addMF(ctlr, "ec", 'trimf',  [-0.1,0.1,0.3],  "Name", 'PS');
ctlr = addMF(ctlr, "ec", 'trimf',  [0,0.2,0.3],     "Name", 'PM');
ctlr = addMF(ctlr, "ec", 'smf',    [0.1,0.3],       "Name", 'PB');

% Add Output Variable 'u' to fuzzy system
ctlr = addOutput(ctlr,[-30 30],"Name","u");

% Set Membership Function of the language variable 'u'
ctlr = addMF(ctlr, "u", 'zmf',    [-30,-30],    "Name", 'NB');
ctlr = addMF(ctlr, "u", 'trimf',  [-30,-20,0],  "Name", 'NM');
ctlr = addMF(ctlr, "u", 'trimf',  [-30,-10,10], "Name", 'NS');
ctlr = addMF(ctlr, "u", 'trimf',  [-20,0,20],   "Name", 'ZO');
ctlr = addMF(ctlr, "u", 'trimf',  [-10,10,30],  "Name", 'PS');
ctlr = addMF(ctlr, "u", 'trimf',  [0,20,30],    "Name", 'PM');
ctlr = addMF(ctlr, "u", 'smf',    [10,30],      "Name", 'PB');

% Set Rule base
rulelist=[1 1 1 1 1;         %Edit rule base
          1 2 1 1 1;
          1 3 2 1 1;
          1 4 2 1 1;
          1 5 3 1 1;
          1 6 3 1 1;
          1 7 4 1 1;
   
          2 1 1 1 1;
          2 2 2 1 1;
          2 3 2 1 1;
          2 4 3 1 1;
          2 5 3 1 1;
          2 6 4 1 1;
          2 7 5 1 1;
          
          3 1 2 1 1;
          3 2 2 1 1;
          3 3 3 1 1;
          3 4 3 1 1;
          3 5 4 1 1;
          3 6 5 1 1;
          3 7 5 1 1;
          
          4 1 2 1 1;
          4 2 3 1 1;
          4 3 3 1 1;
          4 4 4 1 1;
          4 5 5 1 1;
          4 6 5 1 1;
          4 7 6 1 1;
          
          5 1 3 1 1;
          5 2 3 1 1;
          5 3 4 1 1;
          5 4 5 1 1;
          5 5 5 1 1;
          5 6 6 1 1;
          5 7 6 1 1;
          
          6 1 3 1 1;
          6 2 4 1 1;
          6 3 5 1 1;
          6 4 5 1 1;
          6 5 6 1 1;
          6 6 6 1 1;
          6 7 7 1 1;
       
          7 1 4 1 1;
          7 2 5 1 1;
          7 3 5 1 1;
          7 4 6 1 1;
          7 5 6 1 1;
          7 6 7 1 1;
          7 7 7 1 1];

ctlr = addRule(ctlr, rulelist);

showrule(ctlr)

% Use Centroid Defuzz Method
ctlr.DefuzzificationMethod

% Write
writeFIS(ctlr, 'exp4_controller');

disp('---------------------------------------------------------------');
disp('     fuzzy controller table:e=[-0.3,+0.3],ec=[-0.3,+0.3]       ');
disp('---------------------------------------------------------------');

Ulist=zeros(7,7);

e = zeros(7,1);
ec = zeros(7,1);

for i=1:7
   for j=1:7
      e(i) =-4+i;
      ec(j)=-4+j;
      Ulist(i,j) = evalfis(ctlr, [e(i)*0.099, ec(j)*0.099]);
   end
end

Ulist=ceil(Ulist)

figure(1);
plotfis(ctlr);
figure(2);
plotmf(ctlr,'input',1);
figure(3);
plotmf(ctlr,'input',2);
figure(4);
plotmf(ctlr,'output',1);