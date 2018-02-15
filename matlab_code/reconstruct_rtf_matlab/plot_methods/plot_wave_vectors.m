function [] = plot_wave_vectors(wave_dictionary, wave_vectors, ...
    GROUND_TRUTH, frequency)
ground_truth = round(GROUND_TRUTH, 1);
[~, index] = min(abs(ground_truth(:,1) - frequency));
figure('units','normalized','outerposition',[0 0 1 1])
scatter3(wave_dictionary(:,1), wave_dictionary(:,2), wave_dictionary(:,3), 'm')
hold on
scatter3(wave_vectors(:,1), wave_vectors(:,2), wave_vectors(:,3), 'MarkerFaceColor', 'g')
hold on
scatter3(GROUND_TRUTH(:,2), GROUND_TRUTH(:,3), GROUND_TRUTH(:,4), 'MarkerFaceColor', 'b')
xlabel('x')        
ylabel('y')        
zlabel('z')
title(sprintf('Frequency %f', frequency))
legend('uniform samples',  'selected wave vectors', 'theoretical ground truth')
axis equal
hold off
figure_title = sprintf('results/%.2f.png', frequency);
saveas(gcf, figure_title)
end