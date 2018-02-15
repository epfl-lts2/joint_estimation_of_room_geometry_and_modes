function [ P ] = plot_fitted_transfer_functions( f, H, FS, FN_H, num_params )
ind_H = 1:1:size(H,2);
x_axis = [20 110];
figure('units','normalized','outerposition',[0 0 1 1])
axe1 = axes('Units','Normalized','Position',[0.05,0.09,0.93,0.85]);
axe2 = axes('Units','Normalized','Position',[0.05,0.13,0.93,0.85]);
subplot(2, 1, 1)
hold on;
grid on
plot(f,20*log10(abs(H(:,ind_H))));
xlabel('Frequency (Hz)','FontSize',FS,'FontName',FN_H);
ylabel('Magnitude (dB) (re. 1 Pa.s.m^{-1})','FontSize',FS,'FontName',FN_H);
set(gca,'XLim',x_axis,'YLim',[num_params(1) 0],'XMinorTick','Off','FontSize',FS,'Box','On');
title('Amplitude diagram of room transfer functions','FontSize',FS,'FontName',FN_H);
%linkaxes([axe1,axe2],'x');
subplot(2, 1, 2)
hold on;
grid on
plot(f,angle(H(:,ind_H)));
ylabel('Phase (rad)','FontSize',FS,'FontName',FN_H);
set(gca,'XLim',x_axis,'YLim',[-pi pi],'XMinorTick','Off','FontSize',FS,'Box','On');
title('Phase diagram of room transfer functions','FontSize',FS,'FontName',FN_H)


span = find(f > 20 & f < 66);
H_to_fit = H(span,ind_H);
[~,~,~,P1,~] = rfp_multi(f(span),H_to_fit,7,num_params(2));

span = find(f > 49 & f < 85);
H_to_fit = H(span,ind_H);
[~,~,~,P2,~] = rfp_multi(f(span),H_to_fit,6,4);

span = find(f > num_params(3) & f < 109);
H_to_fit = H(span,ind_H);
[~,~,~,P3,~] = rfp_multi(f(span),H_to_fit,6,4);
% PUT ALL THE POLES TOGETHER
P = [P1; P2; P3];
P = unique(P);
end