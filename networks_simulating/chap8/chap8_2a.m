%Fuzzy RBF Training for MIMO and one sample
clear all;
close all;

xite=0.50;
alfa=0.05;

bj=0.50;
c=[-1.5 -1 0 1 1.5;
   -1.5 -1 0 1 1.5;
   -1.5 -1 0 1 1.5];
%w=rands(25,2);
w=zeros(125,2);

w_1=w;
w_2=w_1;

E=1.0;
OUT=2;
k=0;
x=[1,0,0];     %Ideal Input
y=[1 0];       %Ideal Output
while E>=1e-050
k=k+1;   
times(k)=k;

% Layer1:input
f1=x;                        
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
f4=w_1'*f3';                      
yn=f4;                   

ey=y-yn';
d_w=xite*ey'*f3;
w=w_1+d_w'+alfa*(w_1-w_2);

E=0;
for m=1:1:OUT
   E=E+0.5*(y(m)-yn(m))^2;    %Output error
end
  
w_2=w_1;
w_1=w;
Ek(k)=E;
end   %End of while
figure(1);
plot(times,Ek,'-or','linewidth',2);
xlabel('k');ylabel('E');

save wfile1 w;