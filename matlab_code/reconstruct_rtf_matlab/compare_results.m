function [] = compare_results(mic_number, Pearson_correlation, SNR)
low_mic = [14, 16, 19, 23, 28, 34]; % values copied from the paper
low_SNR = [-5, 4, 9, 10, 10, 11.5];  % values copied from the paper

figure('units','normalized','outerposition',[0 0 1 1])
hold on
plot(low_mic, low_SNR, 'Linewidth', 3)
plot(mic_number, SNR, 'Linewidth', 3)
grid on
ylim([-5, 12])
xlabel('microphone number')
ylabel('SNR [dB]')
legend('reference [3]',  'f \in [0, 200]Hz')

figure('units','normalized','outerposition',[0 0 1 1])
plot(mic_number, SNR, 'o')
xlabel('Number of receivers')
ylabel('Signal to noise ratio (SNR)')
title('Results')

figure('units','normalized','outerposition',[0 0 1 1])
plot(mic_number, Pearson_correlation, 'o')
xlabel('Number of receivers')
ylabel('Pearson correlation coefficient')
title('Results')
save('params_300_all.mat', 'SNR', 'Pearson_correlation')