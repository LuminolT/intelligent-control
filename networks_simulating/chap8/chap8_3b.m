%Test fuzzy RBF
clear all;
load wfile2 w;

bj=0.50;
c=[-1.5 -1 0 1 1.5;
   -1.5 -1 0 1 1.5;
   -1.5 -1 0 1 1.5];
%N Samples
x=[0.970,0.001,0.001;
   0.000,0.980,0.000;
   0.002,0.000,1.040;
   0.500,0.500,0.500;
   1.000,0.000,0.000;
   0.000,1.000,0.000;
   0.000,0.000,1.000];
NS=7;
for s=1:1:NS 
% Layer1:input
f1=x(s,:);                        
% Layer2:fuzzation
 for i=1:1:3                        
   for j=1:1:5
      net2(i,j)=-(f1(i)-c(i,j))^2/bj^2;
      f2(i,j)=exp(net2(i,j));
   end
end
% Layer3:fuzzy inference(125 rules)
for j1=1:1:5
	for j2=1:1:5
      	for j3=1:1:5
    ff3(j1,j2,j3)=f2(1,j1)*f2(2,j2)*f2(3,j3);    
	    end
    end
end
f3=[ff3(1,:),ff3(2,:),ff3(3,:),ff3(4,:),ff3(5,:)];

% Layer4:output
f4=w'*f3';                      
yn(s,:)=f4;
end
yn