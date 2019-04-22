source_dir = uigetdir([]);
gestures = ["ABOUT","AND","CAN","COP","GOOUT","DEAF","DECIDE","FATHER","FIND","HEARING"];

for g_index = 1:length(gestures)
    gesture = gestures(g_index);
    d = dir([source_dir, char('/shuffle_'+ string(gesture) +'*.csv')]);
    n = length(d);
    for c = 1:n
        fileName = getfield(d(c),'name');
        pathName = getfield(d(c),'folder');
        %FOR WINDOWS:
        %PathName = char(PathName+"\");
        %[data, headers] = xlsread([PathName, FileName], 1);
        
        %For Mac Use This
        fileformac = fullfile(pathName,fileName);
        data = csvread(fileformac);
        [rows,cols] = size(data);
        
        %Getting Class Labels
        yClassLabel=data(:,cols);
        
        %Set the random number seed to make the rsults repeatable in this
        %script
        rng('default');
        %Predictor Matrix
        xData=double(data(:,1:end-1));
        
        %Split training Data into 27% Training and 73% Test
        cv=cvpartition(length(data),'holdout',0.73);
        xtrain = xData(cv.training,:);
        ytrain = yClassLabel(cv.training,1);
        xtest = xData(cv.test,:);
        ytest = yClassLabel(cv.test,1);
        inputNN = xtrain.';
        outputNN = ytrain.';
        net = feedforwardnet(20);
        net = configure(net,inputNN,outputNN);

        [net,tr] = train(net,inputNN,outputNN);
        plotperform(tr)
        neuralNetwork = net(inputNN);
        yNeuralPredicted = net(xtest.');
        yNeuralPredicted = round(yNeuralPredicted');
         %h=figure;
         plotperform(tr);
         %print('-dpsc', 'perform')
         saveas(gcf,char(gesture + "_NN.png"));
        % Compute the confusion matrix
        confusionMatrixNN = confusionmat(ytest,yNeuralPredicted);
        trueNegativeNN=confusionMatrixNN(1,1);
        falsePositiveNN=confusionMatrixNN(1,2);
        falseNegativeNN=confusionMatrixNN(2,1);
        truePositiveNN=confusionMatrixNN(2,2);

        totalNN=trueNegativeNN+truePositiveNN+falseNegativeNN+falsePositiveNN;
        accuracyNN=(truePositiveNN+trueNegativeNN)/totalNN;
        precisionNN=truePositiveNN/(falsePositiveNN+truePositiveNN);
        recallNN=truePositiveNN/(truePositiveNN+falseNegativeNN);
        f1ScoreNN=2*(precisionNN*recallNN)/(precisionNN+recallNN);
        
        
        fprintf('\nFor Gesture : %s \n',gesture);
        fprintf('\nThe Accuracy is : %d \n', accuracyNN*100.0);
        fprintf('The Precision is : %d \n', precisionNN*100.0);
        fprintf('The Recall is : %d \n', recallNN*100.0);
        fprintf('The f1 Score is : %d \n', f1ScoreNN*100.0);

    end
end