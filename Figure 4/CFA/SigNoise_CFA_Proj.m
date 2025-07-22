load SigNoise

speedstr{1} = '800 mm/s';
speedstr{2} = '400 mm/s';
speedstr{3} = '200 mm/s';
%%
for i =  1:3   
    sCoef_Pre = sCoef_PreVect{i};
    nCoef_Pre = nCoef_PreVect{i};
    
    SigNoise_Pre = atan2d(nCoef_Pre,sCoef_Pre);
    SigNoise_Pre = SigNoise_Pre(~isnan(SigNoise_Pre));        
    
    sCoef_Post = sCoef_PostVect{i};
    nCoef_Post = nCoef_PostVect{i};       
    
    SigNoise_Post = atan2d(nCoef_Post,sCoef_Post);   
    SigNoise_Post = SigNoise_Post(~isnan(SigNoise_Post));
            
    hist_vect_Pre = histcounts(SigNoise_Pre,-180:5:180,'normalization','probability');
    hist_vect_Post = histcounts(SigNoise_Post,-180:5:180,'normalization','probability');
    
    figure;
    sgtitle(strcat('Signal Noise Slope, CFA'," ", speedstr{i}));
    subplot(1,2,1);
    plot(smooth(hist_vect_Post,3),'r');hold on;
    plot(smooth(hist_vect_Pre,3),'k')
    xlim([1 72]);
    xticks([1 35.5 72]);
    xticklabels({'-180','0','180'});
    ylim([0 0.05]);
    legend('CFA+CNO','CFA')
    
    subplot(1,2,2);
    plot(zscore(smooth(hist_vect_Post,3)-smooth(hist_vect_Pre,3)));
    ylim([-4 4]);
    xlim([1 72]);
    xticks([1 35.5 72]);
    xticklabels({'-180','0','180'});
    legend('Zscored Difference')
end
