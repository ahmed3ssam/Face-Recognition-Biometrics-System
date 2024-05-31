clearvars
path = "F:\PDFS\Year4\Semster 2\bio\Team_7\A\all_faces";
n = 320; %No. of training images
m = 80;
subjects = 40;
samples = 8;
L = 70; %No. of dominant eigen values selected
M = 112; N = 92; %Required image dimensions
X = zeros(n, 10); %Initialize data set matrix[X]
labels = zeros(n, 1);

for count = 1:n
	i = ceil(count/samples);
	j = mod((count-1), samples) + 1;
	I = imread(sprintf('%s/Training/s%d/%d.jpg', path, i, j));
    I = imresize(I, [M, N]); %Resize all images to specified MxN
	lbpI = extractLBPFeatures(I,'Upright',false); %get features using local binary pattern 
	labels(count) = i;
	X(count, :) = lbpI; %Saving all feature vector
end

model = fitcecoc(X, labels);

% testing

for count = 1:40
	I = imread(sprintf('%s/Testing/s%d/1.jpg', path, count));
    I = imresize(I, [M, N]); %Resize all images to specified MxN
	lbpI = extractLBPFeatures(I,'Upright',false); %get features using local binary pattern 
	Y((count-1)*2+1, :) = lbpI; %Saving all feature vector

	I = imread(sprintf('%s/Testing/s%d/2.jpg', path, count));
    I = imresize(I, [M, N]); %Resize all images to specified MxN
	lbpI = extractLBPFeatures(I,'Upright',false); %get features using local binary pattern 
	Y((count-1)*2+2, :) = lbpI; %Saving all feature vector
end

img = imread(sprintf('%s/Training/s%d/%d.jpg', path, 3, 2));
imgo = img;
img = imresize(img, [M, N]);

%Finding local binary pattern
lbpI = extractLBPFeatures(img, 'Upright',false); %get features using local binary pattern 

[face_label, confidance] = predict(model, lbpI);
confidance 

%test all images
acc = 0;
for count = 1:m
	[label, confidance] = predict(model, Y(count, :));
	if label == ceil(count/2) && max(confidance) > -0.5
		acc = acc + 1;
	end
end


%--------------Displaying first five matches---------%
resultimg1 = imread(sprintf('%s/Training/s%d/%d.jpg', path, face_label, 1));

subplot(231); imshow(imgo); title('input test image')
subplot(232); imshow(resultimg1); title('First Matched image')

S = 40;
Tr = 8;
Ts = 2; 
T = 40;
%Graph Gen-Imp For First Model
[Gen_Matrix, Imp_Matrix] = GenImpCurve(X, Y, S, Tr, Ts);
Max = max(max(Imp_Matrix), max(Gen_Matrix));
Min = min(min(Imp_Matrix), min(Gen_Matrix));
figure('Name','Genuine Imposter First Model','NumberTitle','off') 
hold on
firstbar=histogram((Gen_Matrix-Min)/(Max-Min),'FaceColor','b');
firstbar.EdgeColor = 'b';
secondbar=histogram((Imp_Matrix-Min)/(Max-Min),'FaceColor','r');
secondbar.EdgeColor = 'r';
legend('Genuine','Imposter')
xlabel('Matching Scores');
ylabel('Normalized Frequencies');
grid
%----------------------------------------------------------------------
%Calculate FMR,FNMR
[FMRs, FNMRs] = FMRs_FNMRs(Gen_Matrix, Imp_Matrix, T);
%Calculate EER,HTER,TMR
[EER, HTER, TMRs] = EER_HTER_TMR(FMRs, FNMRs, FNMRs(4));
%Graph ROC For First Model
figure('Name','ROC First Model','NumberTitle','Off')
plot(TMRs,FMRs,'linewidth',3);
xlabel('FMRs');
ylabel('TMRs');
grid
%----------------------------------------------------------------------
%Calculate d_prime
d_prime = (sqrt(2) * abs(mean(Gen_Matrix)- mean(Imp_Matrix)))/(sqrt(std(Gen_Matrix)^2 + std(Imp_Matrix)^2));
%Displaying d_prime
FirstModel_dprime = d_prime
%Displaying EER
FirstModel_EER = EER
%Displaying HTER
FirstModel_HTER = HTER
%Displaying TMR
FirstModel_TMR = TMRs
%Displaying FMRs
FirstModel_FMRs = FMRs
%Displaying FNMRs
FirstModel_FNMRs = FNMRs
%Displaying accuracy
accuracy = (acc/80)*100
FirstModel_Results = 32;
