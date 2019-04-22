source_dir = uigetdir([]);
gestures = ["ABOUT","AND","CAN","COP","DEAF","DECIDE","FATHER","FIND","GOOUT","HEARING"];
zero_crossing_sensors = [1,2,3,12,13,14];
mean_indices = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17];
feature_indices = [4,5,6,7,8,9,10,11];
total_top_3 = zeros(10*3);
mkdir('pca_data');
for g_index = 1:length(gestures)
    concatGesture = [];
    pca_input = zeros(20,121);
    gesture = gestures(g_index);
    T = readtable(string(source_dir)+"/Action_"+gesture+".csv");
    A = table2array(T);
    number_of_instances = height(T)/17;
    % Calculate all features for this instance
    for instance_index = 1:number_of_instances      
        % populate zero crossing
        for sensor_type = 1:6
            row_index = (instance_index-1)*17 + zero_crossing_sensors(sensor_type);
            pca_input(instance_index,sensor_type) = length(zerocross(table2array(T(row_index,:))));
        end
        % Time of max value
        [p,q] = max(table2array(T(17*(instance_index-1)+1:17*instance_index,:)),[],2);
        pca_input(instance_index,7:23) = transpose(q);
        % FFT
        instance_fft = abs(fft(sum(table2array(T(feature_indices + 17*(instance_index-1),:))),128))/1000;
        pca_input(instance_index,24:87) = instance_fft(1:64);
                
        % Standard deviation
        pca_input(instance_index,88:104) = transpose(std(table2array(T(17*(instance_index-1)+1:17*instance_index,:)),0,2));          

        % Mean
        instance_mean = mean(table2array(T(mean_indices + 17*(instance_index-1),:)),2);
        pca_input(instance_index,105:121) = transpose(instance_mean);
        
    end
    pca_output = pca(pca_input);
    pca_multiplied = pca_input*pca_output;
    csvwrite('pca_data/pca_'+gesture+'.csv',pca_multiplied);
end
function z=zerocross(v)
  z=find(diff(v>0)~=0)+1;
end