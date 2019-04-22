source_dir = uigetdir([]);
gestures = ["ABOUT","AND","CAN","COP","DEAF","DECIDE","FATHER","FIND","HEARING"];
for g_index = 1:length(gestures)
    gesture = gestures(g_index);
    d = dir([source_dir, char('/shuffle_train_'+ string(gesture) +'*.csv')]);
    d_test = dir([source_dir, char('/shuffle_'+ string(gesture) +'*.csv')]);
    n = length(d);
    for c = 1:n
        disp(d(c))
        disp(d_test(c))
        name = getfield(d(c),'name');
        path = getfield(d(c),'folder');
        name_test = getfield(d_test(c),'name');
        path_test = getfield(d_test(c),'folder');
        T_train = readtable(string(path)+"/"+string(name));
        T_test = readtable(string(path_test)+"/"+string(name_test));
        A = table2array(T_train);
        B = table2array(T_test);
        A = vertcat(A,B);
    end
    mkdir('final_dataset');
    csvwrite('final_dataset/'+gesture+'.csv',A);
end