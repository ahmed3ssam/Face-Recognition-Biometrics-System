clearvars
path = "F:\PDFS\Year4\Semster 2\bio\Team_7\A\att_faces";
n = 320; %No. of training images
m = 80;  %No. of testing images
subjects = 40;
samples = 8;
M = 112; N = 92; %Required image dimensions
X = zeros(n, 4680); %Initialize data set matrix[X]
Y = zeros(m, 4680); %Initialize data set matrix[X]
labels = zeros(n, 1);

for count = 1:n
	i = ceil(count/samples);
	j = mod((count-1), samples) + 1;
	I = imread(sprintf('%s/Training/s%d/%d.jpg', path, i, j));
    I = imresize(I, [M, N]); %Resize all images to specified MxN
	hogI = extractHOGFeatures(I); %get features using local binary pattern 
	labels(count) = i;
	X(count, :) = hogI; %Saving all feature vector
end

model = fitcecoc(X, labels); %train model a classifier

save('data.mat', 'X', 'labels') %save training data, to enroll new users later

% testing

for count = 1:40
	I = imread(sprintf('%s/Testing/s%d/1.jpg', path, count));
    I = imresize(I, [M, N]); %Resize all images to specified MxN
	hogI = extractHOGFeatures(I); %get features using local binary pattern 
	Y((count-1)*2+1, :) = hogI; %Saving all feature vector

	I = imread(sprintf('%s/Testing/s%d/2.jpg', path, count));
    I = imresize(I, [M, N]); %Resize all images to specified MxN
	hogI = extractHOGFeatures(I); %get features using local binary pattern 
	Y((count-1)*2+2, :) = hogI; %Saving all feature vector
end

img = imread(sprintf('%s/Training/s%d/%d.jpg', path, 3, 2));
img = imread(sprintf('./A/images/done/%d.jpg', 5));
imgo = img;
img = imresize(img, [M, N]);

%error = 0;
%for count = 0:9
%	img = imread(sprintf('./A/images/done/%d.jpg', count));
%	%Finding local binary pattern
%	hogI = extractHOGFeatures(img); %get features using local binary pattern 
%
%	[face_label, confidance] = predict(model, hogI);
%	if max(confidance) > -0.22
%		error = error + 1;
%	end
%end
%error


%test all images
acc = 0;
for count = 1:m
	[label, confidance] = predict(model, Y(count, :));
	if label == ceil(count/2) && max(confidance) > -0.22
		acc = acc + 1;
	end
end

%Graph Gen-Imp For Second Model
[Gen_Matrix, Imp_Matrix] = GenImpCurve(X, Y, subjects, samples, 10-samples);
Max = max(max(Imp_Matrix), max(Gen_Matrix));
Min = min(min(Imp_Matrix), min(Gen_Matrix));
figure('Name','Genuine Imposter Second Model','NumberTitle','off') 
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
[FMRs, FNMRs] = FMRs_FNMRs(Gen_Matrix, Imp_Matrix, subjects);
%Calculate EER,HTER,TMR
[EER, HTER, TMRs] = EER_HTER_TMR(FMRs, FNMRs, FNMRs(4));
%Graph ROC For Second Model
figure('Name','ROC Second Model','NumberTitle','Off')
plot(TMRs,FMRs,'linewidth',3);
xlabel('FMRs');
ylabel('TMRs');
grid
%----------------------------------------------------------------------
%Calculate d_prime
d_prime = (sqrt(2) * abs(mean(Gen_Matrix)- mean(Imp_Matrix)))/(sqrt(std(Gen_Matrix)^2 + std(Imp_Matrix)^2));
accuracy = (acc/80)*100
SecondModel_Results = 32;
