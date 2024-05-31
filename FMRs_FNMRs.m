function [FMRs, FNMRs] = FMRs_FNMRs(Gen, Imp, T)
    % Find Max and Min between Scores
    SMax = max(max(Gen), max(Imp));
    SMin = min(min(Gen), min(Imp));
    % Calculate P and Vector of Thresholds
    p = (SMax - SMin) / (T-1);
    TVector = [];
    for i = 1:T
        TVector = [TVector, SMin + ((i - 1) * p)];
    end
    % Calculate FMR & FNMR
    FMRs = [];
    FNMRs = [];
    numOfImpMoreThanT = 0;
    numOfGenMoreThanT = 0;
    [~,imp] = size(Imp);
    [~,gen] = size(Gen);
    for i = 1:T
        for j = 1:imp
            if(Imp(j) < TVector(i))
              numOfImpMoreThanT = numOfImpMoreThanT + 1;
            end
        end
        for k = 1:gen
            if(Gen(k) < TVector(i))
                numOfGenMoreThanT = numOfGenMoreThanT + 1;
            end
        end
        [m,n] = size(Imp);
        FMRs = [FMRs, (numOfImpMoreThanT / n)];
        [m,n] = size(Gen);
        FNMRs = [FNMRs, 1 - (numOfGenMoreThanT / n)];
        numOfImpMoreThanT = 0;
        numOfGenMoreThanT = 0;
    end
end
