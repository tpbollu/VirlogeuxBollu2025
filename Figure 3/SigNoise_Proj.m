clear
load SigNoise_proj

speedstr{1} = '800 mm/s';
speedstr{2} = '400 mm/s';
speedstr{3} = '200 mm/s';
%%
for i =  1:3
   
    sCoef_ctrl = cSigCoef_ctrl_proj_all{i};
    nCoef_ctrl = cNoiseCoef_ctrl_proj_all{i};
    
    SigNoise_Ctrl = atan2d(nCoef_ctrl,sCoef_ctrl);
    SigNoise_Ctrl = SigNoise_Ctrl(~isnan(SigNoise_Ctrl));
        
    sCoef_CFA = cSigCoef_CFA_proj_all{i};
    nCoef_CFA = cNoiseCoef_CFA_proj_all{i};
       
    SigNoise_CFA = atan2d(nCoef_CFA,sCoef_CFA);   
    SigNoise_CFA = SigNoise_CFA(~isnan(SigNoise_CFA));
    
    sCoef_SNI = cSigCoef_SNI_proj_all{i};
    nCoef_SNI = cNoiseCoef_SNI_proj_all{i};
       
    SigNoise_SNI = atan2d(nCoef_SNI,sCoef_SNI);   
    SigNoise_SNI = SigNoise_SNI(~isnan(SigNoise_SNI));
 
    hist_vect_Ctrl = histcounts(SigNoise_Ctrl,-180:5:180,'normalization','probability');
    hist_vect_CFA = histcounts(SigNoise_CFA,-180:5:180,'normalization','probability');
    hist_vect_SNI = histcounts(SigNoise_SNI,-180:5:180,'normalization','probability');
          
    figure;
    plot(smooth(hist_vect_Ctrl,3),'k');hold on;
    plot(smooth(hist_vect_CFA,3),'color',[0.5 0 0.5])
    plot(smooth(hist_vect_SNI,3),'color',[0 1 0])
    xlim([1 72]);
    ylim([0 0.075]);
    xlim([1 72]);
    xticks([1 35.5 72]);
    xticklabels({'-180','0','180'});
    legend('Ctrl','CFA','SNI')    
    
end
%%



% % savefig(f_cdf,'sigCoef_out/sigCoef_CDF.fig');
% %%
% figure;plot(smooth(mean(hist_vect_Pre),5));
% hold on;plot(smooth(mean(hist_vect_Pre)-std(hist_vect_Pre),5));
% hold on;plot(smooth(mean(hist_vect_Pre)+std(hist_vect_Pre),5));
% 
% plot(smooth(hist_vect_Post,5));