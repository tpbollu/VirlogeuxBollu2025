function [sCorrelation,sCorrelationIndex] = SignalCorrelations(dirlist,params_main)
%%
params_default.StimDuration = 200;
params_default.StimDir = 1;
params_default.ModOnly = 0;
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
kk =0;
stPFR = [];
ll = 0;
    for ii = 1:numel(dirlist)
        NeuralDataFolderPath = dirlist(ii).name;
        load(strcat(NeuralDataFolderPath,'\',structName));

        if ~isnan(StimDirVect)
            StimDir = StimDirVect(ii);
        end

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

        for jj = 1:numel(sp_struct)
            output = make_raster_psth_Brush_master(sp_struct(jj),'./',params);
            psth_temp = output.PSTH_by_block;
            psth_mat(jj,:) = psth_temp;
        end        

        for jj = 1:numel(sp_struct)
            for kk = (jj+1):numel(sp_struct)
                 ll = ll+1;
                 ccoef_mat = corrcoef(psth_mat(jj,:)',psth_mat(kk,:)');
                 sCorrelation(ll) = ccoef_mat(2);
                 sCorrelationIndex{ll} = {sp_struct(jj).sp_cluster_id sp_struct(kk).sp_cluster_id sp_struct(jj).cell_type sp_struct(kk).cell_type};
                 
                 if sum((sp_struct(jj).sp_cluster_id == [67])&(sp_struct(kk).sp_cluster_id == [12]))>0
                 %if sum((sp_struct(jj).sp_cluster_id == [169 169 169 190 190 74])&(sp_struct(kk).sp_cluster_id == [190 211 74 74 211 211]))>0
                     ccoef_mat(2)
                 end
            end
        end 
        flag = 1;
    end
end
