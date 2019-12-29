function SuccessRate =  kNN(tdata,tlabels,kmin,kmax)
    %kmax = 20;
    SuccessRate = zeros(kmax,1);
    samplesLength = size(tdata,1);
    xNum = 500;
    classes = zeros(10,1);
    for k=kmin:kmax
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
end