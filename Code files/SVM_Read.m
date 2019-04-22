source_dir = uigetdir([]);
gestures = ["ABOUT","AND","CAN","COP","GOOUT","DEAF","DECIDE","FATHER","FIND","HEARING"];

for g_index = 1:length(gestures)
    gesture = gestures(g_index);
    d = dir([source_dir, char('/'+ string(gesture) +'*.csv')]);
    n = length(d);
    for c = 1:n
        fileName = getfield(d(c),'name');
        pathName = getfield(d(c),'folder');
        %FOR WINDOWS:
        PathName = char(pathName+"\");
        [data, headers] = xlsread([PathName, fileName], 1);
        
        %For Mac Use This
        %fileformac = fullfile(pathName,fileName);
        %data = csvread(fileformac);
        [rows,cols] = size(data);
        
        %Getting Class Labels
        yClassLabel=data(:,cols);
        
        %Set the random number seed to make the rsults repeatable in this
        %script
        rng('default');
        %Predictor Matrix
        xData=double(data(:,1:end-1));
        marker = 1840;
        %Split training Data into 60% Training and 40% Test
        %cv=cvpartition(length(data),'holdout',0.40);
        xtrain = xData(1:marker,1:cols-1);
        ytrain = yClassLabel(1:marker,1);
        
        

        fprintf('\nGESTURE : %s\n',gesture);
        for user = 1:27
            start_index = marker + ((user-1)*204);
            end_index = start_index + 204;    
            fprintf('\nDM : %d \n', user+10);
            xtest = xData(start_index:end_index,1:cols-1);
            ytest = yClassLabel(start_index:end_index,1);
            
            %Setting max iterations
            opts = statset('MaxIter',1000);
            
            %Train the classifier
            svmModel = fitcsvm(xtrain,ytrain,'Standardize',true,'KernelFunction','RBF','KernelScale','auto');
          
            % CVSVMModel = crossval(SVMModel);
            % classLoss = kfoldLoss(CVSVMModel);
            %disp(svmModel);
            %Generation Predictions based on Trained SVMModel
            yPredict = predict(svmModel, xtest);
            confusionMatrix = confusionmat(ytest,yPredict);
            trueNegative=confusionMatrix(1,1);
            falsePositive=confusionMatrix(1,2);
            falseNegative=confusionMatrix(2,1);
            truePositive=confusionMatrix(2,2);
            
            total=trueNegative+truePositive+falseNegative+falsePositive;
            accuracy=(truePositive+trueNegative)/total;
            precision=truePositive/(falsePositive+truePositive);
            recall=truePositive/(truePositive+falseNegative);
            f1Score=2*(precision*recall)/(precision+recall);
            
            disp('Confusion Matrix:');
            disp(confusionMatrix);
            
            fprintf('\nFor Gesture : %s \n',gesture);
            fprintf('\nThe Accuracy is : %d \n', accuracy*100.0);
            fprintf('The Precision is : %d \n', precision*100.0);
            fprintf('The Recall is : %d \n', recall*100.0);
            fprintf('The f1Score is : %d \n\n\n', f1Score*100.0);
        end
    end
end