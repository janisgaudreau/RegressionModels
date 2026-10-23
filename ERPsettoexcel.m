%% ============================================================
% Export Grand Average ERP Sets
% Separate Excel sheets by condition/bin
% Rows = Electrodes
% Columns = Time points
% ============================================================

clear;
clc;


%% Folder

folder = 'D:\NASPEM\PALACE EEG Analysis\epoch_1000_base_200\722';


%% ERP files

erpFiles = { ...
  
   '722_NT_NoGo.erp'
   
   };


%% Output

outfile = fullfile(folder,'727_sheets.xlsx');



%% Bin labels

NoGoBinLabels = {
'TigerPres_Corr'
'TigerPres_Incorr'
'TigerResp_Corr'
'TigerResp_Incorr'
'LionPres_Corr'
'LionPres_Incorr'
'LionResp_Corr'
'LionResp_Incorr'
};



%% Loop through ERP files

for f = 1:length(erpFiles)


    fprintf('\nLoading %s\n',erpFiles{f});


    ERP = pop_loaderp( ...
        'filename',erpFiles{f}, ...
        'filepath',folder);



    %% Electrode names

    electrodeNames = strings(ERP.nchan,1);


    for e = 1:ERP.nchan


        if ~isempty(ERP.chanlocs(e).labels)

            % remove E if present
            electrodeNames(e) = erase( ...
                string(ERP.chanlocs(e).labels),'E');


        else

            electrodeNames(e) = string(e);

        end


    end



    %% File name without .erp

    [~,baseName] = fileparts(erpFiles{f});



    %% Loop through bins

    for b = 1:ERP.nbin



        %% Extract bin

        data = ERP.bindata(:,:,b);



        %% Create table

        T = array2table(data);



        %% Time labels

        timeNames = compose('t_%g',ERP.times);

        timeNames = matlab.lang.makeValidName(timeNames);

        T.Properties.VariableNames = cellstr(timeNames);



        %% Add electrode names

        T = addvars( ...
            T,...
            electrodeNames,...
            'Before',1,...
            'NewVariableNames','Electrode');



        %% Bin name

        if b <= length(NoGoBinLabels)

binName = NoGoBinLabels{b};

        else

            binName = sprintf('Bin%d',b);

        end



        %% Sheet name

        sheetName = sprintf('%s_%s',baseName,binName);


        % Excel limit

        if length(sheetName) > 31
            sheetName = sheetName(1:31);
        end



        %% Export

        writetable( ...
            T,...
            outfile,...
            'Sheet',sheetName);



        fprintf('Exported %s\n',sheetName);



    end


end



fprintf('\n====================================\n');
fprintf('ERP export complete!\n');
fprintf('%s\n',outfile);
fprintf('====================================\n');