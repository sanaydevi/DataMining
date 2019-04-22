source_dir = uigetdir([]);
gestures = ["ABOUT","AND","CAN","COP","DEAF","DECIDE","FATHER","FIND","HEARING"];
concatAllPcaData = [];
number_of_rows = [];

l_list={};

for g_index = 1:length(gestures)
    concatGesture = [];
    gesture = gestures(g_index);
    d = dir([source_dir, char('/pca_'+ string(gesture) +'*.csv')]);
    n = length(d);
    for c = 1:n
        disp(d(c))
        name = getfield(d(c),'name');
        path = getfield(d(c),'folder');
        T = readtable(string(path)+"/"+string(name));
        A = table2array(T);
        number_of_rows = horzcat(number_of_rows, size(A,1));
        concatGesture= vertcat(concatGesture,A); 
    end
   concatAllPcaData= vertcat(concatAllPcaData,concatGesture);
   
end

concatAllPcaData = [concatAllPcaData zeros(size(concatAllPcaData,1),1)];

for g_index = 1:length(gestures)
    
    gesture = gestures(g_index);
    concatAllPcaData(:,122)=0;
    start=0;
    sum=0;
    get_start = g_index-1;
    
    for x=1:get_start
        sum = sum+number_of_rows(1,x);
    end
    val = sum+ number_of_rows(1,g_index);
    for i = (sum+1):(sum+ number_of_rows(1,g_index))
        concatAllPcaData(i,122)= 1;
    end
    csvwrite('pca_data/all_data_'+gesture+'.csv',concatAllPcaData);
end

varList = {};
    for index = 1:122
          varList{end + 1} = strcat('Var', num2str(index));
    end

for g_index = 1:length(gestures)
    gesture = gestures(g_index);
    d = dir([source_dir, char('/all_data_'+ string(gesture) +'*.csv')]);
    n = length(d);
    for c = 1:n
        disp(d(c))
        name = getfield(d(c),'name');
        path = getfield(d(c),'folder');
        T = readtable(string(path)+"/"+string(name));
        A = table2array(T);
        shuffledArray = A(randperm(size(A,1)),:);
        
    end
    table_shuffles = array2table(shuffledArray,'VariableNames',varList);
    
   %csvwrite('pca_data/shuffle_'+gesture+'.csv',table2array(table_shuffles));
   writetable(table_shuffles, 'pca_data/shuffle_'+gesture+'.csv','QuoteStrings',true);
end

