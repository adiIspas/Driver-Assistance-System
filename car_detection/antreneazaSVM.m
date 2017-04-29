function clasificator = antreneazaSVM(exempleAntrenare,eticheteExempleAntrenare)

    lambda = 10^(-5);
    [w, b] = vl_svmtrain(exempleAntrenare, eticheteExempleAntrenare, lambda);     
    
    clasificator = struct('w',w,'b',b);
end