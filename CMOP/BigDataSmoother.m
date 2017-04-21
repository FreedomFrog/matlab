function [T,smoothT] = BigDataSmoother(startdate,starttime,enddate,endtime,WindowWidth,p)
Tabmaker
tic

start = datenum([startdate ' ' starttime]);
stop = datenum([enddate ' ' endtime]);
time = start:60/86400:stop;
time = time';
T = table(time,'VariableNames',{'time'});

WidthInMins = WindowWidth*60*24;
smoothTime = time(WidthInMins/2:end-WidthInMins/2);
smoothT = table(smoothTime,'VariableNames',{'smoothTime'});

[nvars, ~] = size(tab);

for i = 1:nvars
    %Grab data from Data Explorer
    M = dataExpCollect(tab{i,1},tab{i,2},tab{i,3},tab{i,4},tab{i,5},tab{i,6},startdate,starttime,enddate,endtime);
    
    %Graph the raw data (optional)
    figure(i)
    subplot(3,1,1)
    plot(M(:,1),M(:,2))
    xlabel('Time')
    ylabel(tab{i,9})
    
    %Lop off the outliers
    M = dataCleaner(M,tab{i,7},tab{i,8});
    
    %Remove gaps
    M = dataGapRemover(M,p);
    
    %Impute this variable's values onto the common time vector
    newVar = interp1(M(:,1),M(:,2),time);
    
    %Graph the cleaned data without gaps (optional)
    subplot(3,1,2)
    plot(time,newVar)
    xlabel('Time')
    ylabel(tab{i,9})
    
    %Append this variable to the final table of values.
    newVarT = array2table(newVar,'VariableNames',{tab{i,9}});
    T = [T newVarT];
    
    %Smooth the data
    smoothVar = dataSmoother(newVar,WindowWidth);
    smoothVarT = array2table(smoothVar,'VariableNames',{tab{i,9}});
    smoothT = [smoothT smoothVarT];
    
    %Plot the smoothed data
    subplot(3,1,3)
    plot(smoothTime,smoothVar,time,newVar)
    xlabel('Time')
    ylabel(tab{i,9})
end
toc

function X = dataExpCollect(station,depth,letter,sensor,var,cleanlevel,startdate,starttime,enddate,endtime)
%--------------------------------------------------------------------------
% File name: dataExpCollect.m
% Author: Ian Nicolas
% Purpose: To generlize the process of data collecting from the data
% exploer website at CMOP - 'the front door' - where we have access to
% quality controlled data.
% Inputs: intrument - string input, ex: 'saturn03.240.A.CT'
%         var - string input, ex: 'salt' for salinity
%         cleanlevel - string input, ex: 'PD0' for PD0 processing
%         startdate - string input, ex: '2015-5-6'
%         starttime - string input, ex: '0:00'
%         enddate - string input, ex: '2015-06-6'
%         endtime - string input, ex: '23:59'
% Outputs: table - a table with the correct column names with the data
% specified in the time range inputs.
% Note that you will have to reference the variable names, intruments and
% quality level as CMOP dictates it in the data explorer:
% http://www.stccmop.org/datamart/observation_network/dataexplorer
%--------------------------------------------------------------------------

try
    %This collects the string inputs and places them in a url string.
    url = strcat('http://amb6400b.stccmop.org/ws/product/offeringplot_datadownload.py?handlegaps=true&series=time,' ...
        ,station,'.',depth,'.',letter,'.',sensor,'.',var,'.',cleanlevel,'&width=8.54&height=2.92&starttime=',startdate,'%20',starttime, ...
        '&endtime=',enddate,'%20',endtime,'&requesttype=data&format=mat');
    %This will load/download the data as a MATLAB file and place it in a
    %temporary file in your current folder.
    urlwrite(url,'tempfile.mat');
    load('tempfile.mat');
    X = data.values;
    %This will delete the temporary file in your directory.
    delete('tempfile.mat');
catch
    disp('Error: either (1) the quality control level you choose is not availiable or (2) the instrument you specified does not measure the variable you specified or (3) you misspelled something.')
end

function X = dataCleaner(M,LB,UB)

goodindices = (M(:,2)>LB) & (M(:,2)<UB);
X = M(goodindices,:);

function X = dataGapRemover(M,p)

gap = prctile(diff(M(:,1)),p);
gaplocations = diff(M(:,1)) > gap;
M(gaplocations,2) = nan;
X = M;

function X = dataSmoother(Var,WindowWidth)
%WindowWidth should be given days.

WidthInMins = WindowWidth*24*60;
M = length(Var);
k = M - WidthInMins+1;

for i = 1:k
    if isnan(Var(i+WidthInMins/2-1))
        X(i) = nan;
    else
        X(i) = nanmean(Var(i:i+WidthInMins-1));
    end
    X = X';
end