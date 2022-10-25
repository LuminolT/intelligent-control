x = linspace(0, 60, 1000);

M = trimf(x, [10,25,40]);
L = trimf(x, [25,40,60]);
VL = trimf(x, [40,60,60]);

cutM = min(M, 3/5);
cutL = min(L, 2/5);
cutVL = min(VL, 1/5);

figure(1)
hold on;
xlabel('washing time(s)');
ylabel('Degree of membership');
title('Composition Output');

a = plot(x, max(max(cutL, cutVL), cutM), 'b');
a.Color(4) = 0.5;
a.LineWidth = 6;

axis([0 80 0 1])


plot(x, M, 'r--', 'LineWidth', 1);
plot(x, cutM, 'r', 'LineWidth', 1);

plot(x, L, 'g--', 'LineWidth', 1);
plot(x, cutL, 'g', 'LineWidth', 1);

plot(x, VL, 'b--', 'LineWidth', 1);
plot(x, cutVL, 'b', 'LineWidth', 1);

plot([0 31], [0.6 0.6], 'black:');
plot([31 31], [0 0.6],  'black:');
plot([19 19], [0 0.6],  'black:');

grid on;

legend('comp','M','cutM','L','cutL','VL','cutVL');

% figure(2);
% hold on;
% xlabel('washing time(s)');
% ylabel('Degree of membership');
% title('Composition Output');
% axis([0 80 0 1])
% plot(x, max(max(cutL, cutVL), cutM), 'b.');

figure(2);