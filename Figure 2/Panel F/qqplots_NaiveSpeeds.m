%% QQ Plot

load MMFR_ALL_Computed;

speedStr{1} = {'800 mm/s'};
speedStr{2} = {'400 mm/s'};
speedStr{3} = {'200 mm/s'};
    
for i = 1:3
    lgnorm_Naive{i} = fitdist(MMFR_Ctrl{i},'lognormal');
    lgnorm_CFA_Post{i} = fitdist(MMFR_CFA_PostCNO{i},'lognormal');    
    lgnorm_SNI_Pre{i} = fitdist(MMFR_SNI{i},'lognormal');     
    lgnorm_SNI_Post{i} = fitdist(MMFR_SNI_PostCNO{i},'lognormal');
    
    maxY = 500-(i-1)*100;
    maxX = 500-(i-1)*100;
    
    figure(1);    
    subplot(3,1,i);    
    h = qqplot(MMFR_Ctrl{i},lgnorm_Naive{i});ylim([0 maxY]);xlim([0 maxX]);    
    h(1).MarkerEdgeColor = [0 0 0];    
    axis square; title(strcat('CFA', " ", speedStr{i}));

end
