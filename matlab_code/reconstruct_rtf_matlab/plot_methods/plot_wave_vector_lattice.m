function [] = plot_wave_vector_lattice(theoretical_ground_truth, wave_vectors_set, wave_numbers_set)
figure('units','normalized','outerposition',[0 0 1 1])
scatter3(theoretical_ground_truth(:,2), theoretical_ground_truth(:,3), ...
    theoretical_ground_truth(:,4), 60, 'ob')
hold on
frequency = sqrt(theoretical_ground_truth(:,2).^2+theoretical_ground_truth(:,3).^2+theoretical_ground_truth(:,4).^2)*346/2/pi;
textCell = arrayfun(@(x) sprintf('%3.2f',x),frequency,'un',0);
text(abs(theoretical_ground_truth(:,2))+.02, abs(theoretical_ground_truth(:,3))-.02, abs(theoretical_ground_truth(:,4))+.02, textCell,'FontSize',15, 'Color', 'b') 

scatter3(abs(wave_vectors_set(:,1,1)), abs(wave_vectors_set(:,1,2)), ...
    abs(wave_vectors_set(:,1,3)), 40, 'oc', 'MarkerFaceColor', 'k')

frequency = real(wave_numbers_set)*346/2/pi;
damping = imag(wave_numbers_set)*346;

textCell = arrayfun(@(x) sprintf('%3.2f',x),frequency,'un',0);
text(abs(wave_vectors_set(:,1,1))+.02, abs(wave_vectors_set(:,1,2))+.02, abs(wave_vectors_set(:,1,3))+.02, textCell,'FontSize',15) 

title('Wave vectors with frequencies [Hz]')
legend('ground truth', 'estimation')
xlabel('kx')
ylabel('ky')
zlabel('kz')
end