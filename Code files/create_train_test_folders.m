source_dir = uigetdir([]);
 t1 = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37"];
gestures = ["ABOUT","AND","CAN","COP","DEAF","DECIDE","FATHER","FIND","GOOUT","HEARING"];
% t1 = ["01", "02", "03"];
% mkdir('train');

for i = 1:length(t1) 
    for g_index = 1:length(gestures)
        gesture = gestures(g_index);
    d = dir([source_dir, char(('/DM')+ string(t1(i)) +char('/')+ string(gesture)+'*.csv')]);
    n = length(d);
        for c = 1:n
            disp(d(c))
            name = getfield(d(c),'name');
            path = getfield(d(c),'folder');
            s= '/train';
            
            new_directory_train=  strcat(source_dir,s);
            new_directory_test=  strcat(source_dir,'/test');
            filename = strcat(string(path), '/' ,string(name));
            if (i<=29)
                copyfile(char(filename),char(new_directory_train));
            else
                 copyfile(char(filename),char(new_directory_test));
            end
        end
    end
end


