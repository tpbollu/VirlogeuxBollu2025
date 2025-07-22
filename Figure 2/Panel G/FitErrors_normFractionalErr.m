%%
clear 
load MMFR_Computed;

i = 1;

for j = 1:3   
    qvect = MMFR_Ctrl{j};
    qvect = sort(qvect);
    index_max = numel(qvect);
    lgnorm_naive = fitdist(qvect,'lognormal');
    qvect_th = icdf('lognormal',[1/(index_max+1):(1/(index_max+1)):1],lgnorm_naive.mu,lgnorm_naive.sigma);
    qvect_th = qvect_th';
    
    linmodel = fitlm(qvect(1:end),qvect_th(1:end-1)); %,'RobustOpts','on');
    rmse_pre(i) = linmodel.RMSE;
    rsq_pre(i) = linmodel.Rsquared.Adjusted;
    
    predict_qvect = predict(linmodel,[qvect]);
    e = abs(qvect_th(1:end-1)-predict_qvect)./qvect_th(1:end-1);
    
    error_dist{j,i} = e;    
    median_error(j,i) = median(e);
    median_error_pos(j,i) = prctile(e,75);
    median_error_neg(j,i) = prctile(e,25);;    
end

i = 2;
for j = 1:3   
    qvect = MMFR_Ctrl{j};
    qvect = sort(qvect);
    index_max = numel(qvect);
    weibull_naive = fitdist(qvect,'weibull');
    qvect_th = icdf('weibull',[1/(index_max+1):(1/(index_max+1)):1],weibull_naive.A,weibull_naive.B);
    qvect_th = qvect_th';
    
    linmodel = fitlm(qvect(1:end),qvect_th(1:end-1)); %,'RobustOpts','on');
    rmse_pre(i) = linmodel.RMSE;
    rsq_pre(i) = linmodel.Rsquared.Adjusted;
    
    predict_qvect = predict(linmodel,[qvect]);
    e = abs(qvect_th(1:end-1)-predict_qvect)./qvect_th(1:end-1);
    
    error_dist{j,i} = e;    
    median_error(j,i) = median(e);
    median_error_pos(j,i) = prctile(e,75);
    median_error_neg(j,i) = prctile(e,25);    
end

i = 3;
for j = 1:3   
    qvect = MMFR_Ctrl{j};
    qvect = sort(qvect);
    index_max = numel(qvect);
    gamma_naive = fitdist(qvect,'gamma');
    qvect_th = icdf('gamma',[1/(index_max+1):(1/(index_max+1)):1],gamma_naive.a,gamma_naive.b);
    qvect_th = qvect_th';
    
    linmodel = fitlm(qvect(1:end),qvect_th(1:end-1)); %,'RobustOpts','on');
    rmse_pre(i) = linmodel.RMSE;
    rsq_pre(i) = linmodel.Rsquared.Adjusted;
    
    predict_qvect = predict(linmodel,[qvect]);
    e = abs(qvect_th(1:end-1)-predict_qvect)./qvect_th(1:end-1);
    
    error_dist{j,i} = e;    
    median_error(j,i) = median(e);
    median_error_pos(j,i) = prctile(e,75);
    median_error_neg(j,i) = prctile(e,25);
end

%%
speedstr{3} = '200 mm/s';
speedstr{2} = '400 mm/s';
speedstr{1} = '800 mm/s';

for i = 1:1    
    figure;errorbar([1:3],median_error(i,:),median_error(i,:)-median_error_neg(i,:),median_error_pos(i,:)-median_error(i,:),'ko')
    xlim([0.5 3.5]);
    ylim([0 0.8]);
    xticks([1 2 3]);
    xticklabels({'lognormal','Weibull','gamma'});
    title(strcat('Stimulus speed'," ",speedstr(i)));
    ylabel('Normalized Fit Error')
end

%
%%
for i = 1:3      
    cellFormat2{i,1} = strcat(num2str(median_error(i,1),'%.2f')," ",'[',num2str(median_error_neg(i,1),'%.2f')," ",num2str(median_error_pos(i,1),'%.2f'),']');    
    cellFormat2{i,2} = strcat(num2str(median_error(i,2),'%.2f')," ",'[',num2str(median_error_neg(i,2),'%.2f')," ",num2str(median_error_pos(i,2),'%.2f'),']');    
    cellFormat2{i,3} = strcat(num2str(median_error(i,3),'%.2f')," ",'[',num2str(median_error_neg(i,3),'%.2f')," ",num2str(median_error_pos(i,3),'%.2f'),']');            
end


