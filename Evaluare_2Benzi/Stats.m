function Stats
% clear, clc
clc
disp('Stats of my app')
% STATS computes stats for the results of LaneDetector
%
% Inputs:
% -------
% 
% Outputs:
% --------
%

% The detection files
detectionFiles = {
  'cordova1/list.txt_results.txt'
%   'cordova2/list.txt_results.txt'
  'washington1/list.txt_results.txt'
  'washington2/list.txt_results.txt'
  };

% The ground truth labels
truthFiles = {
  'cordova1/labels.ccvl'
%   'cordova2/labels.ccvl'
  'washington1/labels.ccvl'
  'washington2/labels.ccvl'
  };

% Get statistics
ccvGetLaneDetectionStats(detectionFiles, truthFiles);
