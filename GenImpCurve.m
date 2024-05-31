function [Gen_Matrix, Imp_Matrix] = GenImpCurve(Training_Features_Vectors, Testing_Features_Vectors ,S, Tr, Ts)
    %Assign the training and testing features
    TR = Training_Features_Vectors; 
    TS = Testing_Features_Vectors;
    %calculate rows and cols
    Columns = S *(Tr + Ts)*(((Tr /(Ts + Tr))* 100)/100);
    Rows = S *(Tr + Ts)*(((Ts /(Ts + Tr))* 100)/100);
    
    %calculate distance by euclidean Equation
      for i = 1:Rows
            for j = 1:Columns
                distance(i,j) = sqrt(sum((TR(j,:) - TS(ceil(i/2),:)) .^ 2));
            end
      end
    
   Gen_Matrix = [];
   Imp_Matrix = [];
   Counter = 1;
   
   %calculate Gen and Imp
    for i = 1:Rows
        if(mod(i-1,2) == 0 && i ~= 1)
            Counter = Counter + 1;
        end   
        for j = 1:Columns
            if( Counter*Tr >= ceil(j/2) && (Counter-1)*Tr < ceil(j/2))
				Gen_Matrix = [Gen_Matrix,distance(i,j)];
            else
				Imp_Matrix = [Imp_Matrix,distance(i,j)];
            end 
        end       
    end
end
