function [cCoupling,cCouplingIndex] = NoiseCorrelations(dirlist,params_main)
%%
params_default.StimDuration = 200;
params_default.StimDir = 1;
params_default.ModOnly = 0;
params_default.trial_num = [1:190];
params_default.StimDirVect = NaN;
params_default.structName = 'spstruct.mat';
%%
S = fieldnames(params_default);
for i = 1:numel(S)
    if isfield(params_main,S{i})
        eval_str = strcat(S{i},'=',strcat('params_main.',S{i}),';');
        eval(eval_str);
    else
        eval_str = strcat(S{i},'=',strcat('params_default.',S{i}),';');
        eval(eval_str);
    end
end
%%
MMFRTable = table('Size',[1 2],'VariableTypes',{'double','string'});
MMFRTable.Properties.VariableNames = {'stPFR','MouseID'};
%%
kk =0;
stPFR = [];
ll = 0;
mm =0;
    for ii = 1:numel(dirlist)
        
        if ~isnan(StimDirVect)
            StimDir = StimDirVect(ii);          
        end

        NeuralDataFolderPath = dirlist(ii).name;
        load(strcat(NeuralDataFolderPath,'/',structName));

        params.subselect_param_name = [{'duration'},{'StimDir'}];
        params.subselect_param_value = [{StimDuration},{StimDir}];

        params.sort_by = [{'duration'}];
        params.group_by_params = [{'duration'}];

        params.xlim_var = [-0.5 2];
        params.make_pdf = 0;
        params.plot_flag = 0;

        clear psth_mat
        if ModOnly
            cell_list = [];
            for jj = 1:numel(sp_struct)
                output = make_raster_psth_Brush_master(sp_struct(jj),'./',params);
                sp_times = output.SPTimes_by_block;
                sp_times = sp_times{1};
                preStim = [];
                postStim = [];
                for ll = 1:numel(sp_times)
                    preStim(ll) = sum((sp_times{ll}<0)&sp_times{ll}>(-20*(StimDuration)));
                    postStim(ll) = sum((sp_times{ll}>0)&sp_times{ll}<(20*(StimDuration)));
                end
                
                if (sum(preStim)>1)||(sum(postStim)>1)
                    if ttest2(preStim,postStim)
                        cell_list = [cell_list jj];
                    end
                end
                
            end
            
            sp_struct = sp_struct(cell_list);
            clear sp_times;
        end

        neuralindex = 0;
        for jj = 1:numel(sp_struct)
            output = make_raster_psth_Brush_master(sp_struct(jj),'./',params);
            if numel(output)<1
                continue
            end
            neuralindex = neuralindex+1;
            sp_times_temp = output.SPTimes_by_block;            
            sp_trials_temp = output.selected_trial_list;
            sp_times(neuralindex,:) = sp_times_temp{1};
            sp_trials{neuralindex} = sp_trials_temp;
        end        

        
        for jj = 1:neuralindex
            for kk = (jj+1):neuralindex
                sp_times_1 = sp_times(jj,:);
                sp_times_2 = sp_times(kk,:);
                for ll = 1:numel(sp_times_1)
                    sp_times_trial_1(ll) = sum((sp_times_1{ll}>0)&(sp_times_1{ll}<(StimDuration+200)*20));
                    sp_times_trial_2(ll) = sum((sp_times_2{ll}>0)&(sp_times_2{ll}<(StimDuration+200)*20));
                end
                corr_temp = corrcoef(sp_times_trial_2,sp_times_trial_1);
                mm = mm + 1;
                cCoupling(mm) = corr_temp(2);
                cCouplingIndex{mm,1} = {sp_struct(jj).sp_cluster_id sp_struct(kk).sp_cluster_id sp_struct(jj).cell_type sp_struct(kk).cell_type sp_struct(kk).site};
                
%                 if sum((sp_struct(jj).sp_cluster_id == [67])&(sp_struct(kk).sp_cluster_id == [12]))>0
%                     corr_temp(2)
%                 end
%                 if sum((sp_struct(jj).sp_cluster_id == [169 169 169 190 190 74])&(sp_struct(kk).sp_cluster_id == [190 211 74 74 211 211]))>0                    
%                     figure;plot(sp_times_trial_1,sp_times_trial_2,'rx')
%                     ylim([0 10]);xlim([0 15]);
%                     corr_temp(2)
%                 end
            end
        end
        
        clear sp_times sp_times_2 sp_times_1 sp_times_trial_2 sp_times_trial_1

    end
end
