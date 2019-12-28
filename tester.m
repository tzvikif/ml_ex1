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
SuccessRate = zeros(kmax,1);
samplesLength = size(tdata,1);
xNum = 1000;
classes = zeros(10,1);
for k=5:kmax
    currentSuccessRate = 0;
    for xInd=1:xNum
        %find distances
        dist = zeros(samplesLength,2);
        xdata = tdata(xInd,:);
        xlabel = tlabels(xInd,:);
        if(xlabel == 0)
            xlabel = 10;
        end
        for sampleInd=1:samplesLength
            sampleData = tdata(sampleInd,:);
            sampleLabel = tlabels(sampleInd,:);
            if(xInd~=sampleInd)
                dist(sampleInd,1) = euclidianDist(xdata,sampleData);
                dist(sampleInd,2) = sampleLabel;
            end
        end
        dist(xInd,1) = max(dist(:,1));
        dist = sortrows(dist,1);
        %take k smallest values
        kSamples = dist(1:k,:);
        for i=1:k
            sampleLabel = kSamples(i,2);
            if(sampleLabel==0)
                sampleLabel = 10;
            end
            classes(sampleLabel) = classes(sampleLabel) + 1; 
        end
        classResult = find(classes == max(classes)*ones(10,1));
        classes = zeros(10,1);
        if(classResult==xlabel)
            currentSuccessRate  = currentSuccessRate + 1;
        end
    end
    SuccessRate(k) = currentSuccessRate/(xNum);
end

