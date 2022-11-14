%Model Reference Aapative RBF Control
clear all;
close all;
    
u_1=0;
y_1=0;
ym_1=0;

M=2

x=[0,0,0]';
c=[-3 -2 -1 1 2 3;
   -3 -2 -1 1 2 3;
   -3 -2 -1 1 2 3];
b=2*ones(6,1);
w=rands(6,1);

xite=0.35;
alfa=0.05;
h=[0,0,0,0,0,0]';
w_1=w;w_2=w;
c_1=c;c_2=c;
b_1=b;b_2=b;

ts=0.001;
for k=1:1:3000
time(k)=k*ts;

r(k)=0.5*sin(2*pi*k*ts);
ym(k)=0.6*ym_1+r(k);

y(k)=(-0.1*y_1+u_1)/(1+y_1^2);  %Nonlinear plant

for j=1:1:6
    h(j)=exp(-norm(x-c(:,j))^2/(2*b(j)*b(j)));
end
u(k)=w'*h;
      
ec(k)=ym(k)-y(k);
dyu(k)=sign((y(k)-y_1)/(u(k)-u_1));

   d_w=0*w;
   d_b=0*b;
   d_c=0*c;
   for j=1:1:6
      d_w(j)=xite*ec(k)*h(j)*dyu(k);
      d_b(j)=xite*ec(k)*h(j)*dyu(k) * (norm(x-c(:,j))^2/(b(j)*b(j)*b(j)))*w(j);
      for ii=1:1:3
          d_c(ii,j)=xite*ec(k)*h(j)*dyu(k) * ((x(ii)-c(ii,j))/(b(j)*b(j)))*w(j);
      end
   end
   w=w_1+d_w+alfa*(w_1-w_2);
   b=b_1+d_b+alfa*(b_1-b_2);
   c=c_1+d_c+alfa*(c_1-c_2);
   
   u_1=u(k);
   y_1=y(k);
   ym_1=ym(k);
    
   x(1)=r(k);
   x(2)=ec(k);
   x(3)=y(k);   
   
   w_2=w_1;w_1=w;
   b_2=b_1;b_1=b;
   c_2=c_1;c_1=c;
end
hold on;
figure(1);
title('Sine wave tracking (dynamic b,c)')
plot(time,ym,'r',time,y,'b--',linewidth=1);
legend('model', 'real');
xlabel('time(s)');ylabel('ym,y',linewidth=1);
figure(2);
plot(time,ym-y,'r');
title('Sine wave tracking error (dynamic b,c)')
xlabel('time(s)');ylabel('tracking error');