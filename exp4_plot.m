close all;
figure(1);
plot(t,y(:,1),'r',t,y(:,2),'k:','linewidth',2);
title('position tracking')
xlabel('time(s)');ylabel('yd,y');
legend('Ideal position signal','position tracking');

delta_y = y(:,1) - y(:,2);

figure(2);
plot(t,delta_y);
title('relative error')
xlabel('time(s)');ylabel('error'); 