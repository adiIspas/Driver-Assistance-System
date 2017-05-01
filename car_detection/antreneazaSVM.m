function clasificator = antreneazaSVM(exempleAntrenare,eticheteExempleAntrenare)
% antreneazaSVM Antreneaza un SVM
%
%   exempleAntrenare         = exemplele de antrenare
%   eticheteExempleAntrenare = etichete pentru exemplele de antrenare
%
%   clasificator             = clasificatorul obtinut

    lambda = 10^(-5);
    [w, b] = vl_svmtrain(exempleAntrenare, eticheteExempleAntrenare, lambda);     
    
    clasificator = struct('w',w,'b',b);
end