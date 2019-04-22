source_dir = uigetdir([]);
gestures = ["ABOUT","AND","CAN","COP","DEAF","DECIDE","FATHER","FIND","HEARING"];
% gestures = ["ABOUT","AND"];
for g_index = 1:length(gestures)
    gesture = gestures(g_index);
    d = dir([source_dir, char('/'+ string(gesture) +'*.csv')]);
    n = length(d);
    for c = 1:n
        disp(d(c))
        name = getfield(d(c),'name');
        path = getfield(d(c),'folder');
        T = readtable(string(path)+"/"+string(name));
        variable = floor(0.8*size(T));
        max = size(T);
        Train = T(1:variable,:);
        Test = T(variable:max, 1:121);
        
        model_tree = fitctree(Train,'Var122');

        answer = predict(model_tree,Test);

        tc = transpose(table2array(T(variable:max, 122)));
        pc = transpose(answer); 

        [C,order] = confusionmat(tc,pc);

         tp = C(1,1);
         fn = C(1,2);
         fp = C(2,1);
         tn = C(2,2); 
         sensitivity = tp /( tp + fn );
         specificity = tn /( fp + tn );
         accuracy = (tp+tn) / (tp+fn+fp+tn); 
         tpr = sensitivity;
         fpr = 1-specificity;
         precision = tp /( tp + fp );
         fVal = (2*tpr*precision)/(tpr+precision);

         recall = tp / ( tp + fn );
         f1score = (2*recall*precision) / ( recall + precision);

         fprintf('For gesture : %s \n',gesture);
         fprintf('\n The sensitivity/Recall is : %d \n', sensitivity);
         fprintf('The specificity is : %d \n', specificity);
         fprintf('The accuracy is : %d \n', accuracy);
         fprintf('The tpr is : %d \n', tpr);
         fprintf('The fpr is : %d \n', fpr);
         fprintf('The precision is : %d \n', precision);
         fprintf('The F1 score is : %d \n', f1score);
    end
end
