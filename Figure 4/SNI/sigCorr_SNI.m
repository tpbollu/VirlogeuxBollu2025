clear

load SigCoeff_SNI

speedstr{1} = '800 mm/s';
speedstr{2} = '400 mm/s';
speedstr{3} = '200 mm/s';
%%
for i =  1:3  
    totCoef = [SigCoef_PreVect{i},SigCoef_PostVect{i}];
    
    for j = 1:1000
        num_index = randperm(numel(totCoef),numel(SigCoef_PreVect{i}));
        num_index2 = setdiff(1:numel(totCoef),num_index);
        vect1 = histcounts(totCoef(num_index),[-1:0.01:1])/numel(num_index);
        vect2 = histcounts(totCoef(num_index2),[-1:0.01:1])/numel(num_index2);
        null_diff(j) = 0.5*(norm(vect1-vect2,1));
    end
    
    vect1 = histcounts(SigCoef_PreVect{i},[-1:0.01:1])/numel(SigCoef_PreVect{i});
    vect2 = histcounts(SigCoef_PostVect{i},[-1:0.01:1])/numel(SigCoef_PostVect{i});
    actual_diff = 0.5*(norm(vect1-vect2,1));
    
    temp = find(actual_diff>sort(null_diff));
    prct_out = 1-temp(1)/1000;
    
    figure(1);
    subplot(1,3,i)
    boxplot(null_diff,'Labels','NullDistribution'); hold on;
    plot(1,actual_diff,'ro');
    ylim([0 0.5]);
    title(strcat('Signal Correlations, SNI'," ",speedstr{i}))
    
    legend('observed difference');
        
    figure;
    histogram(SigCoef_PreVect{i},[-1:0.01:1],'normalization','cdf','DisplayStyle','stairs','edgecolor','K');
    hold on
    histogram(SigCoef_PostVect{i},[-1:0.01:1],'normalization','cdf','DisplayStyle','stairs','edgecolor','r');
    
    legend('SNI','SNI+CNO');
    ylim([0 1])
    xlim([-1 1])
    sgtitle(strcat('Signal Correlations, SNI'," ",speedstr{i}))        
end
