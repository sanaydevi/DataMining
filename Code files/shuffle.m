source_dir = uigetdir([]);
gestures = ["ABOUT","AND","CAN","COP","DEAF","DECIDE","FATHER","FIND","HEARING"];

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
   csvwrite('pca_data/shuffle_'+gesture+'.csv',shuffledArray);
end
