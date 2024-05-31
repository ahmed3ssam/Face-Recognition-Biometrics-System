function [model, new_label] = enroll(path, num_of_images)
    load("data.mat", 'X', 'labels'); %load training data
    new_label = max(labels) + 1; %get a new label
    new_labels = zeros(num_of_images, 1) + new_label;
    new_labels = [labels; new_labels]; %append new labels to the training data
    count = size(labels, 1); %to append to the vector variable `X`
    for i = 1:num_of_images
        I = imread(sprintf('%s/%d.jpg', path, i)); %read new subject image
        I1 = rgb2gray(I); %preprocessing
        detector = vision.CascadeObjectDetector; %to detect ear
        bbox = detector(I1); %get ear bounding box
        [a, b] = sort(bbox(:, 4)); %sort bbox by size
        bbox = bbox(b(end), :); %get largest bounding box
        I2 = imcrop(I1, bbox); %crop around ear
        I3 = imresize(I2, [112, NaN]); %resize image to 112x112
        I4 = imcrop(I3, [15, 0, 91, 112]); %crop to 92x112, width of training images
        if i == 1 %copy first image to folder all_ears, so we can display it later
            imwrite(I4, "out.jpg");
            movefile(sprintf('out.jpg'), sprintf('A/all_ears/%d.jpg', new_label));
        end
        hogI = extractHOGFeatures(I4); %get features using HOG for current image
        X(count + i, :) = hogI; %Saving all feature vectors
    end
    model = fitcecoc(X, new_labels); %retrain model
    save('data.mat', 'X', 'labels') %save retrained model, write variables `X` and `labels` to file `data.mat`
end