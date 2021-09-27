%% OC2 Pipeline for v9 Data: 3rd Revision. Task split emphasis
%% Setting analysis directory
clear; close all; clc
AnalysisDir = 'E:\Study\University College London\Paul Burgess\Research Project\Cian\V9';
addpath(AnalysisDir)
cd(AnalysisDir)

%% Converting csv to xlsx format (v9)

files = dir('*.csv'); 

for i = 1 : length(files)
    fileName = files(i).name; 
    opts{i} = detectImportOptions(fileName);
    Header{i} = opts{1,i}.VariableNames; 
    Char{i} = setvartype(opts{1,i},'char');
    Raw{i} = readtable(fileName,Char{1,i});
    Raw{i} = table2cell(Raw{i});
    repeat_col = Raw {1,i}(:,10);
    replace_repeat_col = strrep(repeat_col,'repeat-vkap#','');
    Raw {1,i}(:,10) = replace_repeat_col;
   
     if  contains (fileName,'8vkc')
         Exercise_Check = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'9ml3')
         Exercise_Type = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'7ai3')
         Heart_Rate = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'m1qd')
         OMNI_RPE = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'241l')
         Sleep_Question = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'vufd')
         Mood_Test = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'m4ap')
         Task_APS = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'h5pv')
         Task_CRT = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'pmvx')
         Task_XNA = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'pskw')
         Task_SRT = [Header{1,i};Raw{1,i}];         
     end
end

clearvars -except AnalysisDir Exercise_Check Exercise_Type Heart_Rate OMNI_RPE Sleep_Question Mood_Test Task_APS Task_CRT Task_XNA Task_SRT;

%% Exercise check
selected_cols = Exercise_Check(:,[6,10,12,54]);
index_rows = Exercise_Check(:,53); 
index_rows = string(index_rows);
index = ones(1,1);
parfor i = 2:size(index_rows,1)
       text = index_rows(i,1);
       if contains (text,'quantised')
          index = [index,i];
       end
end
 
EC_data_processed = selected_cols(index,:);

%% Exercise Type
selected_cols = Exercise_Type(:,[10,12,54]);
index_rows = Exercise_Type(:,53);
index_rows = string(index_rows);
index = ones(1,1);
parfor i = 2:size(index_rows,1)
       text = index_rows(i,1);
       if strcmp (text,'Exercise condition-text') || strcmp(text,'Exercise condition-quantised')
          index = [index, i];
       end
end

ET_data_processed = selected_cols(index,:);
ET_data_processed = rmmissing(ET_data_processed);
repeat_col = ET_data_processed(:,3);
replace_repeat_col = strrep(repeat_col,'Baseline fitness test','5');
replace_repeat_col = strrep(replace_repeat_col,'Baseline Fitness Test','5');
replace_repeat_col = strrep(replace_repeat_col,'Baseline test','5');
replace_repeat_col = strrep(replace_repeat_col,'base line testing','5');
replace_repeat_col = strrep(replace_repeat_col,'baseline fitness test','5');
replace_repeat_col = strrep(replace_repeat_col,'Test','5');
replace_repeat_col = strrep(replace_repeat_col,'baseline test','5');
ET_data_processed(:,3) = replace_repeat_col;
a = tabulate(ET_data_processed(:,3));

%% OMNI Questionnaire
selected_cols = OMNI_RPE(:,[10,12,63]);
index_rows = OMNI_RPE(:,58); 
index_rows = string(index_rows);
index = ones(1,1);
parfor i = 2:size(index_rows,1)
       text = index_rows(i,1);
       if strcmp (text,'advancementZone')
          index = [index,i];
       end
end
 
OMNI_data_processed = selected_cols(index,:);

%% Heart Rate 
selected_cols = Heart_Rate(:,[10,12,63]);
index_rows = Heart_Rate(:,63); 
index_rows = string(index_rows);
index = ones(1,1);
parfor i = 2:size(index_rows,1)
       text = index_rows(i,1);
       if strcmp (text,'go on')
          index = [index,i-1];
       end
end
 
HR_data_processed = selected_cols(index,:);

% this step can be increased, because of individual differences.
selected_cols = HR_data_processed(:,[1,2,3]);
index_rows = HR_data_processed(:,2);
sec_index_rows = HR_data_processed(:,3);
index_rows = string(index_rows);
sec_index_rows = string(sec_index_rows);
index = ones(1,1);
parfor i = 2:size(index_rows,1)  
       text = index_rows(i,1);  
       sec_text = sec_index_rows(i,1);
       if strcmp (text,'932872') && strcmp(sec_text,'0')
       else
          index = [index,i];
       end
end
   
 HR_data_processed = selected_cols(index,:);
     
% the step above eliminates the data manually.And can be improved by
% using unique function.

repeat_col = HR_data_processed (:,3);
repeat_col = string (repeat_col);
replace_repeat_col = strrep(repeat_col,'bpm','');
replace_repeat_col = strrep(replace_repeat_col,'BPM','');
replace_repeat_col = strrep(replace_repeat_col,'iujyhtgrefaw','');
replace_repeat_col = strrep(replace_repeat_col,'\','');
replace_repeat_col = strrep(replace_repeat_col,'#','');
replace_repeat_col = deblank(replace_repeat_col);
replace_repeat_col=cellstr(replace_repeat_col);
HR_data_processed (:,3) = replace_repeat_col; 

%% Sleep Questionnaire

selected_cols = Sleep_Question(:,[10,12,54]); 
index_rows = Sleep_Question(:,1); 
index_rows = string(index_rows);
index = ones(1,1);
parfor i = 2:size(index_rows,1)
       text = index_rows(i,1);
       if strcmp (text,'2') || strcmp(text,'3')|| strcmp(text,'4')|| strcmp(text,'5')|| strcmp(text,'6')|| strcmp(text,'8')    
          index =[index,i];
       end
end  %Only keep the vaild trais in our dataset

Sleep_data_processed = selected_cols(index,:); %re-arrange the dataset

%% Mood Test
selected_cols = Mood_Test(:,[10,12,54]); 
index_rows = Mood_Test(:,53); 
index_rows = string(index_rows);
index = ones(1,1);

parfor i = 2:size(index_rows,1)
       text = index_rows(i,1);
       if contains (text,'response') && contains (text,'quantised')
          index = [index,i];
       end
end

MT_data_processed = selected_cols(index,:);

clearvars -except AnalysisDir MT_data_processed Sleep_data_processed HR_data_processed OMNI_data_processed ET_data_processed EC_data_processed...
                  Task_APS Task_CRT Task_XNA Task_SRT;

%% Combined participant list

ec_data = EC_data_processed;
et_data = ET_data_processed;
omni_data = OMNI_data_processed;
hr_data = HR_data_processed;
mood_data = MT_data_processed;
sleep_data = Sleep_data_processed;

ec_data(1,:)=[];
ec_data = string(ec_data);
et_data(1,:)=[];
et_data = string(et_data);
omni_data(1,:)=[];
omni_data = string(omni_data);
hr_data(1,:)=[];
hr_data = string(hr_data);
mood_data(1,:)=[];
mood_data = string(mood_data);
sleep_data(1,:)=[];
sleep_data = string(sleep_data);

i  = length(ec_data);
mood_data1 = mood_data(:,1);
mood_data2 = mood_data(:,2);
mood_data3 = mood_data(:,3);
re_m1 = reshape(mood_data1,[],i);
re_m1 = re_m1';
re_m2 = reshape(mood_data2,[],i);
re_m2 = re_m2';
re_m3 = reshape(mood_data3,[],i);
re_m3 = re_m3';
mood_data =[];
mood_data = string(mood_data);
mood_data(:,1) = re_m1(:,1);
mood_data(:,2 )= re_m2(:,1);
mood_data(:,(3:12)) = re_m3(:,(1:end));

sleep_data1 = sleep_data(:,1);
sleep_data2 = sleep_data(:,2);
sleep_data3 = sleep_data(:,3);
re_s1 = reshape(sleep_data1,[],i);
re_s1 = re_s1';
re_s2 = reshape(sleep_data2,[],i);
re_s2 = re_s2';
re_s3 = reshape(sleep_data3,[],i);
re_s3 = re_s3';
sleep_data = [];
sleep_data = string(sleep_data);
sleep_data(:,1) = re_s1(:,1);
sleep_data(:,2 )= re_s2(:,1);
sleep_data(:,(3:8)) = re_s3(:,(1:end));

sleep_time = sleep_data(:,(4:7));
sleep_time = str2double(sleep_time);
sleep_night = sleep_time(:,1)*60 + sleep_time(:,2);
sleep_day = sleep_time(:,3)*60 + sleep_time(:,4);
sleep_data(:,4) = sleep_night;
sleep_data(:,5) = sleep_day;
sleep_data(:,(6:7)) = [];
sleep_data = string(sleep_data);

clearvars -except AnalysisDir ec_data et_data omni_data hr_data mood_data sleep_data...
           Task_APS Task_CRT Task_XNA Task_SRT;

%% Joining everything together

table_ec = array2table(ec_data(:,(1:4)),'VariableNames',{'Date','Repeat','ParticipantID','ExerciseCheck' });
table_et = array2table(et_data(:,(1:3)),'VariableNames',{'Repeat','ParticipantID','ExerciseType'});
combinedv9 = outerjoin(table_ec,table_et,'key',{'Repeat','ParticipantID',},'Type','left','MergeKeys',true);

table_omni = array2table(omni_data(:,(1:3)),'VariableNames',{'Repeat','ParticipantID', 'OMNIscore'});
combinedv9 = outerjoin(combinedv9,table_omni,'key',{'Repeat','ParticipantID',},'Type','left','MergeKeys',true);

table_hr = array2table(hr_data(:,(1:3)),'VariableNames',{'Repeat','ParticipantID', 'HR'});
combinedv9 = outerjoin(combinedv9,table_hr,'key',{'Repeat','ParticipantID',},'Type','left','MergeKeys',true);

table_m = array2table(mood_data(:,(1:12)),'VariableNames',{'Repeat','ParticipantID','Mood1','Mood2','Mood3','Mood4','Mood5','Mood6','Mood7','Mood8','Mood9','Mood10'});
combinedv9 = outerjoin(combinedv9,table_m,'key',{'Repeat','ParticipantID',},'Type','left','MergeKeys',true);

table_s = array2table(sleep_data(:,(1:6)),'VariableNames',{'Repeat','ParticipantID','Sleep1','Sleep2','Sleep3','Sleep4'});
combinedv9 = outerjoin(combinedv9,table_s,'key',{'Repeat','ParticipantID',},'Type','left','MergeKeys',true);

% Changing variable names
List_Headers = combinedv9.Properties.VariableNames;
List_Headers = string(List_Headers);

List_Headers (1,1) = 'ProgramDay';
List_Headers (1,4) = 'PreOrPostExercise';
List_Headers (1,8) = 'Energetic';
List_Headers (1,9) = 'Sad';
List_Headers (1,10) = 'Alert';
List_Headers (1,11) = 'Nervous';
List_Headers (1,12) = 'Focused';
List_Headers (1,13) = 'Lethargic';
List_Headers (1,14) = 'Sleepy';
List_Headers (1,15) = 'Calm';
List_Headers (1,16) = 'Distracted';
List_Headers (1,17) = 'Glad';
List_Headers (1,18) = 'SleepTiredRating';
List_Headers (1,19) = 'SleepNightMinutes';
List_Headers (1,20) = 'SleepDayMinutes';
List_Headers (1,21) = 'SleepQuality';

combinedv9 = table2cell(combinedv9);
combinedv9 = string(combinedv9);

addpath 'D:\MATLAB\R2021a\examples\natsortrows';
combinedv9 = natsortrows(combinedv9,[],[3 2]);

%% Fixing, tidying up participant table and tabulating the dates
DateSplit = split(combinedv9(1:end,1));
combinedv9(:,1) = DateSplit(:,1);
combinedv9(:,1) = datetime(combinedv9(:,1),'InputFormat','dd/MM/yyyy'); 
UniqueParticipants = unique(combinedv9(:,3));

% LOGIC 1: If it's the first time the participant does the test, put the date of test to participant id in the lookup table
% LOGIC 2: If not first time doing test, find the date of the first test. Then current date - baseline date to get day of intervention
for i = 1:length(combinedv9)
    if strcmp(combinedv9(i,2),'1') == 1
       HoldP = combinedv9(i,3);
       [tf,rowHoldP] = ismember(HoldP,UniqueParticipants(:,1));
       UniqueParticipants(rowHoldP,2) = combinedv9(i,1);
       combinedv9(i,1) = 1;
    end
    if strcmp(combinedv9(i,2),'1') ~= 1
       HoldP = combinedv9(i,3);
       [tf,rowHoldP] = ismember(HoldP,UniqueParticipants(:,1));
       dateHoldP = UniqueParticipants(rowHoldP,2);
       combinedv9(i,1) = datenum(combinedv9(i,1)) - datenum(dateHoldP) + 1;
    end
    if strcmp(combinedv9(i,4),'1') == 1 %Switching the exercise condition variable lables logically  Exercise check 1 = 2, 2 = 1
       combinedv9(i,4) = 2;
    else
       combinedv9(i,4) = 1;
    end
end

ProgramDay = str2double(combinedv9(:,1));
Pre_Post = str2double(combinedv9(:,4));
parfor i = 1:length(combinedv9)
    week(i,:) = floor(ProgramDay(i)/7);
end

count = 1;
for i = 1:length(week)-1
    if week(i+1,1) == week(i,1)
       week(i+1,2) = count+1;
       count = count+1;
    else
       week(i+1,2) = 1;
       count = 1;
    end
end
week(1,2) = 1;
Trial = append(string(week(:,1)),string(week(:,2))); %bascially done
[location,~] = find(str2double(Trial)==3); %this means participants who strat their 1st test within baseline testing week (these data should be fixed through next few steps) jA*h87VWTb4i39z

index = 1;
for i = 1:length(location)
    while str2double(Trial(location(i))) <= str2double(Trial(location(i)+index))
          index = index+1;
          if location(i)+index == length(Trial)
              count(:,length(count)+1) = index; 
              break
          end
          if str2double(Trial(location(i)))> str2double(Trial(location(i)+index))
             count(:,i) = index-1;
          end
    end
          index = 1;
end


for i = 1:length(count)
    Recalculate{i} =  ProgramDay((location(i):location(i)+count(i)),:);
    Diff(i) = Recalculate{i}(1)-1;
    Recalculate{i} = Recalculate{i} - Diff(i);
    Replace{i} = ceil(Recalculate{i}/7);
end

index = 1;
for i = 1:length(Replace)
    for j = 1:length(Replace{i})-1
        if Replace{i}(j+1,1) == Replace{i}(j,1)
           Replace{i}(j+1,2) = index+1;
           index = index+1;
        else
           Replace{i}(j+1,2) = 1;
           index = 1;
        end
    end
    Replace{i}(1,2) = 1;
    index = 1;
    Trial_modified{i} = append(string(Replace{i}(:,1)),string(Replace{i}(:,2)));
    Trial(location(i):location(i)+count(i)) = Trial_modified{i}(1:j+1);
end

combinedv9 = combinedv9(:,[1,2,2,3:end]);
combinedv9(:,3) = Trial;
List_Headers = List_Headers(:,[1,2,2,3:end]);
List_Headers(3) = 'Trial';

% Dates now corrected in participant list
clearvars -except List_Headers AnalysisDir combinedv9 Task_APS Task_CRT Task_XNA Task_SRT;

%% Task 1 Simple Reaction Time (Team 4)
selected_cols = Task_SRT(:,[10,12,57,60,73,75]); 
index_rows = Task_SRT(:,73); 
index_rows = string(index_rows);
index = ones(1,1);

parfor i = 2:size(index_rows,1)
    text = index_rows(i,1);
     if contains (text,'Variant')
        index = [index,i];
     end
end  

pre_processed1 = selected_cols(index,:); 
sselected_cols = pre_processed1(:,[1,2,4,6]);
sindex_rows = pre_processed1(:,3); 
sindex_rows = string(sindex_rows);
sindex = ones(1,1);

parfor j = 2:size(sindex_rows,1)
    stext = sindex_rows (j,1);
    if contains (stext,'Screen 2')
       sindex = [sindex,j];
    end
end 

SRT_data_processed = sselected_cols(sindex,:);
%% Task 2 Choice Reaction Time (Team 2)
selected_cols = Task_CRT(:,[10,12,57,60,65,73,75]); 
index_rows = Task_CRT(:,73); 
index_rows = string(index_rows);
index = ones(1,1);

parfor i = 2:size(index_rows,1)
     text = index_rows(i,1);
     if contains (text,'task')
         if contains (text,'intro')
         else
            index = [index,i];
         end
     end
end  

pre_processed1 = selected_cols(index,:); 
sselected_cols = pre_processed1(:,[1,2,4,5,6,7]);
sindex_rows = pre_processed1(:,3); 
sindex_rows = string(sindex_rows);
sindex = ones(1,1);

parfor j = 2:size(sindex_rows,1)
    stext = sindex_rows (j,1);
    if contains (stext,'pause')
    else
       sindex = [sindex,j];
    end
end 

CRT_data_processed = sselected_cols(sindex,:);
repeat_col = CRT_data_processed (:,5);
replace_repeat_col = strrep(repeat_col,'task','');
CRT_data_processed (:,5) = replace_repeat_col; 
%% Task 3 Association Processing Speed (Team 1)
selected_cols = Task_APS(:,[10,12,60,65,75,76,77]); 
index_rows = Task_APS(:,73); 
index_rows = string(index_rows);
index = ones(1,1);

parfor i = 2:size(index_rows,1)
    text = index_rows(i,1);
     if contains (text,'Tests')
        index = [index,i];
     end
end 

APS_data_processed = selected_cols(index,:); 
%% Task 4 XN Attending (Team 3)
selected_cols = Task_XNA(:,[10,12,57,60,65,73,75,76,78]); 
index_rows = Task_XNA(:,73); 
index_rows = string(index_rows);
index = ones(1,1);

parfor i = 2:size(index_rows,1)
    text = index_rows(i,1);
     if contains (text,'trial')
         if contains (text,'start')
         else
            index = [index,i];
         end
     end
end 

pre_processed1 = selected_cols(index,:); 
sselected_cols = pre_processed1(:,[1,2,4,5,6,7,8,9]);
sindex_rows = pre_processed1(:,3); 
sindex_rows = string(sindex_rows);
sindex = ones(1,1);

parfor j = 2:size(sindex_rows,1)
    stext = sindex_rows (j,1);
    if contains (stext,'Screen 1')
       sindex = [sindex,j];
    end
end

XN_attending_data_processed = sselected_cols(sindex,:);
phase = XN_attending_data_processed (:,5);
phase = strrep(phase,'trial_pics','1');
phase = strrep(phase,'trial stage 2','2'); 
XN_attending_data_processed (:,5) = phase;

clearvars -except AnalysisDir List_Headers SRT_data_processed XN_attending_data_processed CRT_data_processed APS_data_processed combinedv9...
    Task_APS Task_SRT Task_CRT Task_XNA;

%% Duration
selected_cols = Task_APS(:,[1,3,10,12,55]); 
index_rows = Task_APS(:,1); 
index_rows = string(index_rows);
index = ones(1,1);

parfor i = 2:size(index_rows,1)
    text = index_rows(i,1);
     if strcmp (text,'1')
        index = [index,i];
     end
end 
APS_start = selected_cols(index,:);
APS_start(1,:) = [];

for j = 3:length(index)
    APS_end(j,:) = selected_cols(index(j)-1,:);
end
APS_end((1:2),:) = [];
APS_end = [APS_end;Task_APS(end-1,[1,3,10,12,55])];
t1 = datevec(APS_start(:,2),'dd/mm/yyyy HH:MM:SS');
t2 = datevec(APS_end(:,2),'dd/mm/yyyy HH:MM:SS');
duration_APS = etime(t2,t1);
Durationv9_APS = [APS_start(:,(3:4)),string(duration_APS)];

selected_cols = Task_CRT(:,[1,3,10,12,55]); 
index_rows = Task_CRT(:,1); 
index_rows = string(index_rows);
index = ones(1,1);

parfor i = 2:size(index_rows,1)
    text = index_rows(i,1);
     if strcmp (text,'1')
        index = [index,i];
     end
end 
CRT_start = selected_cols(index,:);
CRT_start(1,:) = [];

for j = 3:length(index)
    CRT_end(j,:) = selected_cols(index(j)-1,:);
end
CRT_end((1:2),:) = [];
CRT_end = [CRT_end;Task_CRT(end-1,[1,3,10,12,55])];
t1 = datevec(CRT_start(:,2),'dd/mm/yyyy HH:MM:SS');
t2 = datevec(CRT_end(:,2),'dd/mm/yyyy HH:MM:SS');
duration_CRT = etime(t2,t1);
Durationv9_CRT = [CRT_start(:,(3:4)),string(duration_CRT)];

selected_cols = Task_SRT(:,[1,3,10,12,55]); 
index_rows = Task_SRT(:,1); 
index_rows = string(index_rows);
index = ones(1,1);

parfor i = 2:size(index_rows,1)
    text = index_rows(i,1);
     if strcmp (text,'1')
        index = [index,i];
     end
end 
SRT_start = selected_cols(index,:);
SRT_start(1,:) = [];

for j = 3:length(index)
    SRT_end(j,:) = selected_cols(index(j)-1,:);
end
SRT_end((1:2),:) = [];
SRT_end = [SRT_end;Task_SRT(end-1,[1,3,10,12,55])];
t1 = datevec(SRT_start(:,2),'dd/mm/yyyy HH:MM:SS');
t2 = datevec(SRT_end(:,2),'dd/mm/yyyy HH:MM:SS');
duration_SRT = etime(t2,t1);
Durationv9_SRT = [SRT_start(:,(3:4)),string(duration_SRT)];

selected_cols = Task_XNA(:,[1,3,10,12,55]); 
index_rows = Task_XNA(:,1); 
index_rows = string(index_rows);
index = ones(1,1);

parfor i = 2:size(index_rows,1)
    text = index_rows(i,1);
     if strcmp (text,'1')
        index = [index,i];
     end
end 
XNA_start = selected_cols(index,:);
XNA_start(1,:) = [];

for j = 3:length(index)
    XNA_end(j,:) = selected_cols(index(j)-1,:);
end
XNA_end((1:2),:) = [];
XNA_end = [XNA_end;Task_XNA(end-1,[1,3,10,12,55])];
t1 = datevec(XNA_start(:,2),'dd/mm/yyyy HH:MM:SS');
t2 = datevec(XNA_end(:,2),'dd/mm/yyyy HH:MM:SS');
duration_XNA = etime(t2,t1);
Durationv9_XNA = [XNA_start(:,(3:4)),string(duration_XNA)];

save 'Durationv9.mat' Durationv9_APS Durationv9_CRT Durationv9_SRT Durationv9_XNA; 
%% Quantising stimuli names and trial types in all Tasks
T2NamesImport = readtable('Lookup Table_FINAL.xlsx','Sheet',2,'Range','D1:E121');
T2Names = T2NamesImport(1:end,1);
T2NamesQ = T2NamesImport(1:end,2);
T2Names = table2cell(T2Names);
T2NamesQ = table2cell(T2NamesQ);
T2NamesQ = string(T2NamesQ);
    
T3NamesImport = readtable('Lookup Table_FINAL.xlsx','Sheet',3,'Range','D1:E157');
T3Names = T3NamesImport(1:end,1);
T3NamesQ = T3NamesImport(1:end,2);
T3Names = table2cell(T3Names);
T3NamesQ = table2cell(T3NamesQ);
T3NamesQ = string(T3NamesQ);
    
T4NamesImport = readtable('Lookup Table_FINAL.xlsx','Sheet',4,'Range','D1:E91');
T4Names = T4NamesImport(1:end,1);
T4NamesQ = T4NamesImport(1:end,2);
T4Names = table2cell(T4Names);
T4NamesQ = table2cell(T4NamesQ);
T4NamesQ = string(T4NamesQ);

    % Quantise Task 2 stimuli names
parfor i = 1:length(CRT_data_processed)
    CRT_data_processed(i,6)= replace(CRT_data_processed(i,6),T2Names,T2NamesQ);
end
   
   % Quantise Task 3 stimuli names
for i = 1:length(APS_data_processed)
    APS_data_processed(i,5)= replace(APS_data_processed(i,5),T3Names,T3NamesQ);
    APS_data_processed(i,6)= replace(APS_data_processed(i,6),T3Names,T3NamesQ);
    APS_data_processed(i,7)= replace(APS_data_processed(i,7),T3Names,T3NamesQ);
end
   
   % Quantise Task 4 stimuli names 
for i = 1:length(XN_attending_data_processed)
    if cellfun(@isnumeric,XN_attending_data_processed(i,6)) == 0
       XN_attending_data_processed(i,6)= replace(XN_attending_data_processed(i,6),T4Names,T4NamesQ);
    end      
    if cellfun(@isnumeric,XN_attending_data_processed(i,7)) == 0
       XN_attending_data_processed(i,7)= replace(XN_attending_data_processed(i,7),T4Names,T4NamesQ);
    end      
    if cellfun(@isnumeric,XN_attending_data_processed(i,8)) == 0
       XN_attending_data_processed(i,8)= replace(XN_attending_data_processed(i,8),T4Names,T4NamesQ);
    end
end 
%% Screening the completeness and creating Participant Completion Checker

cd(AnalysisDir)

% Calling out all the Participant IDs
a = APS_data_processed(:,2);
b = CRT_data_processed(:,2);
c = SRT_data_processed(:,2);
d = XN_attending_data_processed(:,2);
e = combinedv9(:,4);

a(1,:)=[];
b(1,:)=[];
c(1,:)=[];
d(1,:)=[];

a = string (a);
b = string (b);
c = string (c);
d = string (d);


% Return the number of times the participant ID appears i.e 100 trial means the ID should appear 100 times
list_a = tabulate(a(:));
list_a(:,3)=[];
list_a = sortrows(list_a,1,'ascend');
list_b = tabulate(b(:));
list_b(:,3)=[];
list_b = sortrows(list_b,1,'ascend');
list_c = tabulate(c(:));
list_c(:,3)=[];
list_c = sortrows(list_c,1,'ascend');
list_d = tabulate(d(:));
list_d(:,3)=[];
list_d = sortrows(list_d,1,'ascend');
list_e = tabulate(e(:));
list_e(:,3)=[];
list_e = sortrows(list_e,1,'ascend');
list = [list_a,list_b,list_c,list_d,list_e];

list (:,3) = [];
list (:,4) = [];
list (:,5) = [];
list (:,6) = [];
list = string(list);
list = str2double(list);

for i  = 1:length(list)
    list (i,7)= rdivide(list(i,2),list(i,6));
    list (i,8)= rdivide(list(i,3),list(i,6));
    list (i,9)= rdivide(list(i,4),list(i,6));
    list (i,10)= rdivide(list(i,5),list(i,6));       
end

[M,F] = mode(list);
list_exclude = [];
j = 1;

for i= 1:length(list)
    if list(i,7)~= M(1,7)
        list_exclude(1,j) = list (i,1);
        j=j+1;
    elseif list(i,8)~= M (1,8)
        list_exclude(1,j) = list (i,1);
        j=j+1;
    elseif list(i,9)~= M(1,9)
        list_exclude(1,j) = list (i,1);
        j=j+1;
    elseif list(i,10)~= M(1,10)
        list_exclude(1,j) = list (i,1);
        j=j+1;
    end
end

CombinedHeaders = {'Participant_ID','Overall_APS','Overall_CRT','Overall_SRT','Overall_XN_attending','Repeat_Times','Trials_APS','Trials_CRT','Trials_SRT','Trials_XN_attending'};
list=num2cell(list);
list =[CombinedHeaders;list];
list_exclude = list_exclude';

cd([AnalysisDir filesep 'v9Results'])

xlswrite('v9Participant Completion Checker.xlsx',list,1,'A1');

if isempty(list_exclude) == 0
    xlswrite('v9Participant Completion Checker.xlsx',list_exclude,2,'A1');
end

clearvars -except AnalysisDir List_Headers combinedv9 SRT_data_processed XN_attending_data_processed CRT_data_processed APS_data_processed list_exclude;
%% Exclude participants with incomplete trials (if needed)
% The whole part just for someone who may want to implement the clean dataset into spss,
% currently (excluding the isane participants makes the files generated later more stable and fesible, however do have some considerations). 
% And would be re-newed by Pipeline Team later.

% THIS LINE CLEARS ALL IDs TO BE EXCLUDED (to include everything for now)
 list_exclude = [];% Delete this line if you want to use the filters below

SRT_data_processed = string(SRT_data_processed);
XN_attending_data_processed = string(XN_attending_data_processed);
CRT_data_processed = string(CRT_data_processed);
APS_data_processed = string(APS_data_processed);
list_exclude=string(list_exclude);
for i = 1:length(list_exclude)
    text = list_exclude(i,1);
    combinedv9(all(combinedv9(:,3)==text,2),:) = [];
    SRT_data_processed(all(SRT_data_processed(:,2) == text,2),:) = [];
    XN_attending_data_processed(all(XN_attending_data_processed(:,2) == text,2),:) = [];
    CRT_data_processed(all(CRT_data_processed(:,2) == text,2),:) = [];
    APS_data_processed(all(APS_data_processed(:,2) == text,2),:) = [];
end

%% Merging complete participant list with all 4 Tasks

% Creating the final participant table from the combined table
ParticipantTable = array2table(combinedv9,'VariableNames',List_Headers);
combinedv9 = [List_Headers;combinedv9];

%% Task 1 SRT
SRT_data_processed(1,:) = [];
v9SRT = array2table(SRT_data_processed(:,(1:4)),'VariableNames',{'Repeat','ParticipantID','Response Time','ITI Interval'});
v9SRT = outerjoin(v9SRT,ParticipantTable,'Type','left','MergeKeys',true);
v9SRT = v9SRT(:,[5,1,6,2,7:end,3,4]);
v9SRT = [v9SRT.Properties.VariableNames;table2cell(v9SRT)];
v9SRT = string(v9SRT);

Post_T = mod(str2double(v9SRT((2:end),3)),2);
Post_E = mod(str2double(v9SRT((2:end),5)),2);

index = ones(1,1);
parfor i = 1:length(v9SRT)-1
     if Post_E(i) == Post_T(i)
        index = [index,i+1];
     end
end 
SRT = v9SRT(index,:);

Trial = str2double(SRT((2:end),3));

index = ones(1,1);
parfor i = 1:length(SRT)-1
     if Trial(i) == 1 || Trial(i) == 2 || Trial(i) == 11 || Trial(i) == 12 || Trial(i) == 13 || Trial(i) == 14 || Trial(i) == 15 || Trial(i) == 16 || ...
        Trial(i) == 51 || Trial(i) == 52 || Trial(i) == 53 || Trial(i) == 54 || Trial(i) == 55 || Trial(i) == 56 || Trial(i) == 81 || Trial(i) == 82 || Trial(i) == 83 || ...
        Trial(i) == 84 || Trial(i) == 85 || Trial(i) == 86 || Trial(i) == 91 || Trial(i) == 92
        index = [index,i+1];
     end
end
SRT = SRT(index,:); 

disp('SRT Saving...');
save('v9Task1_SRT.mat', 'SRT'); 
xlswrite('v9Task1_SRT.xlsx',SRT); 
disp('SRT Done!');

%% Task 2 CRT
CRT_data_processed(1,:) = [];
v9CRT = array2table(CRT_data_processed(:,(1:6)),'VariableNames',{'Repeat','ParticipantID','Response Time','Correct','Phase','Stimuli'});
v9CRT = outerjoin(v9CRT,ParticipantTable,'Type','left','MergeKeys',true);
v9CRT = v9CRT(:,[7,1,8,2,9:end,3:6]);
v9CRT = [v9CRT.Properties.VariableNames;table2cell(v9CRT)];
v9CRT = string(v9CRT);

Post_T = mod(str2double(v9CRT((2:end),3)),2);
Post_E = mod(str2double(v9CRT((2:end),5)),2);

index = ones(1,1);
parfor i = 1:length(v9CRT)-1
     if Post_E(i) == Post_T(i)
        index = [index,i+1];
     end
end 
CRT = v9CRT(index,:);

Trial = str2double(CRT((2:end),3));

index = ones(1,1);
parfor i = 1:length(CRT)-1
     if Trial(i) == 1 || Trial(i) == 2 || Trial(i) == 11 || Trial(i) == 12 || Trial(i) == 13 || Trial(i) == 14 || Trial(i) == 15 || Trial(i) == 16 || ...
        Trial(i) == 51 || Trial(i) == 52 || Trial(i) == 53 || Trial(i) == 54 || Trial(i) == 55 || Trial(i) == 56 || Trial(i) == 81 || Trial(i) == 82 || Trial(i) == 83 || ...
        Trial(i) == 84 || Trial(i) == 85 || Trial(i) == 86 || Trial(i) == 91 || Trial(i) == 92
        index = [index,i+1];
     end
end
CRT = CRT(index,:); 

disp('CRT Saving...');
save('v9Task2_CRT.mat', 'CRT'); 
xlswrite('v9Task2_CRT.xlsx',CRT); 
disp('CRT Done!');
%% Task 3 APS
APS_data_processed(1,:) = [];
v9APS = array2table(APS_data_processed(:,(1:7)),'VariableNames',{'Repeat','ParticipantID','Response Time','Correct','LeftStimuli','RightStimuli','TopStimuli'});
v9APS = outerjoin(v9APS,ParticipantTable,'Type','left','MergeKeys',true);
v9APS = v9APS(:,[8,1,9,2,10:end,3:7]);
v9APS = [v9APS.Properties.VariableNames;table2cell(v9APS)];
v9APS = string(v9APS);

Post_T = mod(str2double(v9APS((2:end),3)),2);
Post_E = mod(str2double(v9APS((2:end),5)),2);

index = ones(1,1);
parfor i = 1:length(v9APS)-1
     if Post_E(i) == Post_T(i)
        index = [index,i+1];
     end
end 
APS = v9APS(index,:);

Trial = str2double(APS((2:end),3));

index = ones(1,1);
parfor i = 1:length(APS)-1
     if Trial(i) == 1 || Trial(i) == 2 || Trial(i) == 11 || Trial(i) == 12 || Trial(i) == 13 || Trial(i) == 14 || Trial(i) == 15 || Trial(i) == 16 || ...
        Trial(i) == 51 || Trial(i) == 52 || Trial(i) == 53 || Trial(i) == 54 || Trial(i) == 55 || Trial(i) == 56 || Trial(i) == 81 || Trial(i) == 82 || Trial(i) == 83 || ...
        Trial(i) == 84 || Trial(i) == 85 || Trial(i) == 86 || Trial(i) == 91 || Trial(i) == 92
        index = [index,i+1];
     end
end
APS = APS(index,:); 

disp('APS Saving...');
save('v9Task3_APS.mat', 'APS'); 
xlswrite('v9Task3_APS.xlsx',APS); 
disp('APS Done!');
%% Task 4 XN_attending
XN_attending_data_processed(1,:) = [];
v9XNA = array2table(XN_attending_data_processed(:,(1:8)),'VariableNames',{'Repeat','ParticipantID','Response Time','Correct','Phase','LStimuliP1','RStimuliP1','MemoryStimuliP2'});
v9XNA = outerjoin(v9XNA,ParticipantTable,'Type','left','MergeKeys',true);
v9XNA = v9XNA(:,[9,1,10,2,11:end,3:8]);
v9XNA = [v9XNA.Properties.VariableNames ; table2cell(v9XNA)];
v9XNA = string(v9XNA);

Post_T = mod(str2double(v9XNA((2:end),3)),2);
Post_E = mod(str2double(v9XNA((2:end),5)),2);

index = ones(1,1);
parfor i = 1:length(v9XNA)-1
     if Post_E(i) == Post_T(i)
        index = [index,i+1];
     end
end 
XNA = v9XNA(index,:);

Trial = str2double(XNA((2:end),3));

index = ones(1,1);
parfor i = 1:length(XNA)-1
     if Trial(i) == 1 || Trial(i) == 2 || Trial(i) == 11 || Trial(i) == 12 || Trial(i) == 13 || Trial(i) == 14 || Trial(i) == 15 || Trial(i) == 16 || ...
        Trial(i) == 51 || Trial(i) == 52 || Trial(i) == 53 || Trial(i) == 54 || Trial(i) == 55 || Trial(i) == 56 || Trial(i) == 81 || Trial(i) == 82 || Trial(i) == 83 || ...
        Trial(i) == 84 || Trial(i) == 85 || Trial(i) == 86 || Trial(i) == 91 || Trial(i) == 92
        index = [index,i+1];
     end
end
XNA = XNA(index,:); 

disp('XNA Saving...');
save('v9Task4_XNA.mat', 'XNA'); 
xlswrite('v9Task4_XNA.xlsx',XNA);
disp('XNA Done!');

clearvars -except APS CRT XNA SRT AnalysisDir combinedv9
save 'CleanData.mat'
clearvars -except AnalysisDir

% END