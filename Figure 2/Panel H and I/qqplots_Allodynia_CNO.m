%% QQ Plot

load MMFR_ALL_Computed;

speedStr{1} = {'800 mm/s'};
speedStr{2} = {'400 mm/s'};
speedStr{3} = {'200 mm/s'};
    
for i = 1:1
    lgnorm_CFA_Pre{i} = fitdist(MMFR_CFA{i},'lognormal');
    lgnorm_CFA_Post{i} = fitdist(MMFR_CFA_PostCNO{i},'lognormal');    
    lgnorm_SNI_Pre{i} = fitdist(MMFR_SNI{i},'lognormal');     
    lgnorm_SNI_Post{i} = fitdist(MMFR_SNI_PostCNO{i},'lognormal');
    
    maxY = 500-(i-1)*100;
    maxX = 500-(i-1)*100;
    
    figure(1);    
    subplot(1,4,4*(i-1)+1);    
    h = qqplot(MMFR_CFA{i},lgnorm_CFA_Pre{i});ylim([0 maxY]);xlim([0 maxX]);    
    h(1).MarkerEdgeColor = [0.5 0 0.5];    
    axis square; title(strcat('CFA', " ", speedStr{i}));
    subplot(1,4,4*(i-1)+2);
    h = qqplot(MMFR_CFA_PostCNO{i},lgnorm_CFA_Post{i});ylim([0 maxY]);xlim([0 maxX]);        
    h(1).MarkerEdgeColor = [1 0 0];
    axis square; title(strcat('CFA+CNO', " ", speedStr{i}));
    subplot(1,4,4*(i-1)+3);    
    h = qqplot(MMFR_SNI{i},lgnorm_SNI_Pre{i});ylim([0 maxY]);xlim([0 maxX]);
    axis square; title(strcat('SNI', " ", speedStr{i}));
    h(1).MarkerEdgeColor = [0 1 0];
    subplot(1,4,4*(i-1)+4);    
    h = qqplot(MMFR_SNI_PostCNO{i},lgnorm_SNI_Post{i});ylim([0 maxY]);xlim([0 maxX]);
    axis square; title(strcat('SNI+CNO', " ", speedStr{i}));
    h(1).MarkerEdgeColor = [1 0 0];
end
