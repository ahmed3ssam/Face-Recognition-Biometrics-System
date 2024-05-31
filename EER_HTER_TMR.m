function [EER, HTER, TMRs] = EER_HTER_TMR(FMRs, FNMRs, desFMR)
    % Calculate EER
    x = 0;
    y = 0;
    [~,l] = size(FMRs);
    minDist = 99999;
    minIndex = 0;
    for i = 1:l
        if(abs(FMRs(i)-FNMRs(i)) < minDist)
            minDist = abs(FMRs(i)-FNMRs(i));
            minIndex = i;
        end
    end
    x = FMRs(minIndex);
    y = FNMRs(minIndex);
    %If both are same value, then result will be the same.
    EER = (x+y)/2; 
    % Calculate HTER
    HTER = [];
    for i = 1:l
        x = ((FMRs(i) + FNMRs(i)) / 2);
        HTER = [HTER, x];
    end
    HTER = min(HTER);
    % Calculate TMR given FMR
    TMRs = [];
    for i = 1:l
        TMRs = [TMRs, 1 - FNMRs(i)];
    end
    for i = 1:l
        if(FMRs(i) == desFMR)
            TMRs = TMRs(i);
        end
    end
end