function ccvGetLaneDetectionStats(detectionFiles, truthFiles)
% CCVGETLANEDETECTIONSTATS computes stats for the results compared to the 
% ground truth
%
% INPUTS
% ------
% detectionFiles - a cell array of the detection files
% truthFiles  - a cell array of the corresponding ground truth files
%
% OUTPUTS
% -------
%
% See also ccvLabel
%

% Thresholds for merging i.e. matching splines
meanDistThreshold = 50;
medianDistThreshold = 50;

% meanDistThreshold = 200;
% medianDistThreshold = 200;

% Initialize
allResults = [];
allDetectionTotal = 0;
allTruthTotal = 0;
allNumFrames = 0;
allTp = 0;
allFp = 0;

disp('------------------------------------------------------------------');

for d=1:length(detectionFiles)
    %get detection and truth file
    detectionFile = detectionFiles{d};
    truthFile = truthFiles{d};

    %load the ground truth
    truths = ccvLabel('read', truthFile);
    
    %load the detections file
    detections = ccvReadLaneDetectionResultsFile(detectionFile);

    %results for this file
    results = [];
    detectionTotal = 0;
    truthTotal = 0;
    numFrames = 0;

    %progress index
    prog = 0;
    progress= '-\|/';
    fprintf(1, '\n-');

    %loop on results and compare splines
    for i=1:length(detections)
        %get frame
        detectionFrame = detections(i);
        detectionSplines = detectionFrame.splines;
        
        %display progress
        if mod(length(results), 10)==0
            fprintf(1, '\b%s', progress(prog+1));
            prog = mod(prog+1, length(progress));
        end;

        %get truth splines for that frame
        truthFrame = ccvLabel('getFrame', truths, i);
        if isempty(truthFrame), continue; end;
        numFrames = numFrames + 1;
        truthSplines = GetTruthSplines(truthFrame.labels);

        %update totals
        detectionTotal = detectionTotal + length(detectionSplines);
        truthTotal = truthTotal + length(truthSplines);

        %loop on these splines and compare to ground truth to get the closest
        frameDetections = [];
        truthDetections = zeros(1, length(truthSplines));
        for j=1:length(detectionSplines)
            %flag
            detection = 0;
            %loop on truth and get which one
            k = 1;
            while detection==0 && k<=length(truthSplines)
                if ccvCheckMergeSplines(detectionSplines{j}, ...
                                        truthSplines{k}, meanDistThreshold, ...
                                        medianDistThreshold)
                    %not false pos
                    detection = 1;
                    truthDetections(k) = 1;
                end;
                %inc
                k = k+1;                
            end; %while

            %check result
            result.score = detectionFrame.scores(j);
            result.detection = detection;
            results = [results, result];
            frameDetections = [frameDetections, detection];
        end; %for
        
        %get number of missed splines
        frameNumMissed = length(truthSplines) - length(find(frameDetections==1));
        frameNumFalse = length(find(frameDetections==0));
    end; % for i
    
    %print out some stats
    tp = length(find([results.detection]==1));
    fp = length(find([results.detection]==0));
    % numFrames = length(detections);

    fprintf(1,'\n\n\n');
    disp(sprintf('Detection File %d: %s', i, detectionFile));
    disp(sprintf('Number of frames = %d', numFrames));
    disp(' ');
    disp(sprintf('Total detections = %d', detectionTotal));
    disp(sprintf('Total truth = %d', truthTotal));
    disp(' ');
    disp(sprintf('Number of correct detections = %d', tp));
    disp(sprintf('Number of false detections = %d', fp));
    disp(' ');
    
    correct = 100*tp/truthTotal;
    false = 100 - correct;
    
    disp(sprintf('Percentage of correct detections = %f', correct));
    disp(sprintf('Percentage of false detections = %f', false));
    disp(' ');
    disp(sprintf('False detections/frame= %f', fp/numFrames));
    
    %put in total stats
    allResults = [allResults, results];
    allDetectionTotal = allDetectionTotal + detectionTotal;
    allTruthTotal =  allTruthTotal + truthTotal;
    allNumFrames =  allNumFrames + numFrames;
    allTp = allTp + tp;
    allFp = allFp + fp;
    
    dResults{d} = results;
    dDetectionTotal(d) = detectionTotal;
    dTruthTotal(d) = truthTotal;
    dNumFrames(d) = numFrames;
    dTp(d) = tp;
    dFp(d) = fp;
end; %for


fprintf(1,'\n\n\n');
disp('Overall results');
disp(sprintf('Number of frames = %d', allNumFrames));
disp(' ');
disp(sprintf('Total detections = %d', allDetectionTotal));
disp(sprintf('Total truth = %d', allTruthTotal));
disp(' ');
disp(sprintf('Number of correct detections = %d', allTp));
disp(sprintf('Number of false detections = %d', allFp));
disp(' ');
disp(sprintf('Percentage of correct detections = %f', allTp/allTruthTotal));
disp(sprintf('Percentage of false detections = %f', allFp/allTruthTotal));
disp(' ');
disp(sprintf('False detections/frame= %f', allFp/allNumFrames));


fprintf(1,'\n\n\n-----');
disp('Summary results');
correct2 = 0;
false2 = 0;
n = length(dDetectionTotal);
for d=1:length(dDetectionTotal)
    disp(' ');
    disp(sprintf('Detection %s', detectionFiles{d}));
    disp(sprintf('Total = %d', dTruthTotal(d)));
    disp(sprintf('Total detections = %d', dDetectionTotal(d)));
    correct = 100*dTp(d)/dTruthTotal(d);
    false = 100 - correct;
    disp(sprintf('correct detections = %.2f', correct));
    disp(sprintf('false detections = %.2f', false));
    disp(sprintf('false detections / frame = %.3f', dFp(d)/dNumFrames(d)));
    
    correct2 = correct2 + 100*dTp(d)/dTruthTotal(d);
    false2 = false2 + 100*dFp(d)/dTruthTotal(d);
end;

disp(' ');
disp('--- Final Results ---')

correct = correct2/n;
false = 100 - correct;
disp(sprintf('correct detections = %.2f', correct));
disp(sprintf('false detections = %.2f', false));

% ---------------------------------------------------------------------------
function splines = GetTruthSplines(labels)

centruImagine = 320;
ths = 35;

splines = {};
for i=1:length(labels)  
    currentSpline = labels(i).points;
    for u = 1:size(currentSpline,1)/4
        puncte = sortrows(currentSpline(u*4-4+1:u*4,:),2);

        for idx = 2:size(puncte,1)
            i = round(puncte(idx-1,1));
            j = round(puncte(idx-1,2));
            ii = round(puncte(idx,1));
            jj = round(puncte(idx,2));

            if abs(centruImagine - i) <= ths
                splines{end+1} = currentSpline;
            end
        end
    end
end