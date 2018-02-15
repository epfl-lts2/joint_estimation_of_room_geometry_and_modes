function [] = plot_all_poles...
    (frequency_fitted, damping_fitted, ...
    frequency_theoretical, damping_theoretical, ...
    frequency_estimated, damping_estimated)
% compare 3 values:
% 1. theoretical ground truth
% 2. fitted ground truth
% 3. estimated parameters
figure('units','normalized','outerposition',[0 0 1 1])
hold on
plot(frequency_theoretical, abs(damping_theoretical), 'o', 'MarkerFaceColor', 'g', 'Color', 'g')
plot(frequency_fitted, abs(damping_fitted), 'o', 'MarkerFaceColor', 'b', 'Color', 'b')
plot(frequency_estimated, abs(damping_estimated), 'o', 'MarkerFaceColor', 'c', 'Color', 'c', 'MarkerSize', 10)
ylabel('Damping coefficient -\sigma');
xlabel('Frequency (Hz)');
title('Poles location (p_k = -\sigma_k + j\omega_k)');
legend('theoretical ground truth', 'fitted ground truth', 'estimated parameters')
grid on
xlim([30 90])
saveas(gcf, 'results/frequency_and_damping.png')
end