data = load('mnist_test.csv');
labels = data(:,1);
images = data(:,2:end);
%%
colormap gray
imagesc(reshape(images(5,:),28,28)')
%%
ratio = 0.8; %test size/crossValidation size
samplesNum = size(data,1);
rowLength = size(data,2);
testSet = zeros(uint16(samplesNum*ratio),rowLength);
validationSet = zeros(samplesNum-size(testSet,1),rowLength);
ti = 1;
vi = 1;
for i=1:samplesNum
    if(rand()<=ratio)
        if(ti <= size(testSet,1))
            testSet(ti,:) = data(i,:);
            ti = ti + 1;
        else
            validationSet(vi,:) = data(i,:); 
            vi = vi + 1;
        end
    else
        if(vi <= size(validationSet,1))
            validationSet(vi,:) = data(i,:);
            vi = vi + 1;
        else
            testSet(ti,:) = data(i,:);
            ti = ti + 1;
        end
    end
end
vlabels = validationSet(:,1);
tlabels = testSet(:,1);
vdata = validationSet(:,2:end);
tdata = testSet(:,2:end);

%% find best k
kmax = 10;
kmin = 1;
x = (1:kmax);
testSuccessRate = kNN(tdata,tlabels,kmin,kmax);
disp(testSuccessRate);
plot(x,testSuccessRate);
fprintf('Program paused. Press enter to continue.\n')
pause;
bestK = find(~(testSuccessRate - max(testSuccessRate)),1);
validationSuccessRate = kNN(vdata,vlabels,bestK,bestK);
disp(validationSuccessRate);
fprintf('Program paused. Press enter to continue.\n')
pause;

