clear;
load MMFR_CNO_computed.mat
load MMFR_Naive_computed.mat

SpeedStr{1} = '800 mm/s';
% SpeedStr{2} = '400 mm/s';
% SpeedStr{3} = '200 mm/s';

for i = 1:1
    
    MMFR_tot{1} = MMFR_Ctrl{i};
    MMFR_tot{2} = MMFR_CFA{i};
    MMFR_tot{3} = MMFR_CFA_PostCNO{i};
    MMFR_tot{4} = MMFR_SNI{i};
    MMFR_tot{5} = MMFR_SNI_PostCNO{i};
    
    for j = 1:5
        
        qvect = MMFR_tot{j};
        index_sel = 1:numel(qvect);%randperm(numel(qvect),100);%%
        index_max = numel(index_sel);
        qvect_sel  = qvect(index_sel);
        qvect_sel = sort(qvect_sel);
        
        lgnorm_naive = fitdist(qvect_sel,'lognormal');
        qvect_th = icdf('lognormal',[1/(index_max+1):(1/(index_max+1)):1],lgnorm_naive.mu,lgnorm_naive.sigma);
        qvect_th = qvect_th';
        
        linmodel = fitlm(qvect_sel(1:end),qvect_th(1:end-1)); %,'RobustOpts','on');
        rmse_pre(i) = linmodel.RMSE;
        rsq_pre(i) = linmodel.Rsquared.Adjusted;
        
        predict_qvect = predict(linmodel,[qvect_sel]);
        e = abs(qvect_th(1:end-1)-predict_qvect)./qvect_th(1:end-1);
        error_dist{i,j} = e;
        median_error(i,j) = median(e);
        median_error_pos(i,j) = prctile(e,75);
        median_error_neg(i,j) = prctile(e,25);        
    end
    
    figure;errorbar([1:5],median_error(i,:),median_error(i,:)-median_error_neg(i,:),median_error_pos(i,:)-median_error(i,:),'ko')
    xlim([0.5 5.5])
    xticks([1 2 3 4 5]);    
    xticklabels({'Naive', 'CFA', 'CFA+CNO', 'SNI', 'SNI+CNO'});
    ylabel('Normalized Fit Error');
    title(SpeedStr{i})
end

%%
for i = 1:1  
    
    cellFormat2{i,1} = strcat(num2str(median_error(i,1),'%.2f')," ",'[',num2str(median_error_neg(i,1),'%.2f')," ",num2str(median_error_pos(i,1),'%.2f'),']');    
    cellFormat2{i,2} = strcat(num2str(median_error(i,2),'%.2f')," ",'[',num2str(median_error_neg(i,2),'%.2f')," ",num2str(median_error_pos(i,2),'%.2f'),']');    
    cellFormat2{i,3} = strcat(num2str(median_error(i,3),'%.2f')," ",'[',num2str(median_error_neg(i,3),'%.2f')," ",num2str(median_error_pos(i,3),'%.2f'),']');
    cellFormat2{i,4} = strcat(num2str(median_error(i,4),'%.2f')," ",'[',num2str(median_error_neg(i,4),'%.2f')," ",num2str(median_error_pos(i,4),'%.2f'),']');
    cellFormat2{i,5} = strcat(num2str(median_error(i,5),'%.2f')," ",'[',num2str(median_error_neg(i,5),'%.2f')," ",num2str(median_error_pos(i,5),'%.2f'),']');
    
end

