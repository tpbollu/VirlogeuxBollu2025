    
    StimDurVect = [200 400 800];
    
    dirlist(1).name = '..\ExampleScriptsCore\exampleData\WT_BL6_031023_Gr\Site_01';
    
    for i = 1:3
        params.StimDuration = StimDurVect(i);
        params.StimDir = 1;
        params.ModOnly = 0;
                
        [sigCorr_ctrl{i}] = NoiseCorrelations(dirlist,params);
        [noiseCorr_ctrl{i}] = SignalCorrelations(dirlist,params);
        
    end