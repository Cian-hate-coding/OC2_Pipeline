# OC2_Pipeline
Clean data (Matlab script)
%% Long Covid Assessment Pipeline 27/07/2022 Paul Burgess Cian Xu

%% Setting analysis directory
clear; close all; clc
AnalysisDir = 'E:\Study\University College London\Paul Burgess\Research Project\Long_Covid_Assessment'; %change the direction on your laptop (raw data files)
addpath 'E:\Study\University College London\Paul Burgess\Research Project\Script'%change the direction on your laptop (scripts)
addpath(AnalysisDir)
cd(AnalysisDir)

files = dir('*.csv'); 
for i = 1 : length(files)
    fileName = files(i).name; 
    opts{i} = detectImportOptions(fileName);
    Header{i} = opts{1,i}.VariableNames; 
    Char{i} = setvartype(opts{1,i},'char');
    Raw{i} = readtable(fileName,Char{1,i});
    Raw{i} = table2cell(Raw{i});  
      if  contains (fileName,'hdk77')
         Demograph = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'65er')
         SRT = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'bbtz')
         Inhibition = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'v6zw')
         SOT = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'u1zz')
         SOT = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'2qmh')
         SOT = [Header{1,i};Raw{1,i}];
     elseif  contains (fileName,'yr48')
         SOT = [Header{1,i};Raw{1,i}];
     end
end
