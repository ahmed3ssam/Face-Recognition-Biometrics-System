function [match_label] = test(model, path)
	I = imread(path);
	[image_label, confidance] = predict(model, extractHOGFeatures(I)); %use model to predict, confidance
	image = imread(sprintf('A/all_faces/%d.jpg', image_label));
	if max(confidance) > -0.22
		figure
		subplot(231); imshow(I); title('input test image')
		subplot(232); imshow(image); title('Second Matched image')
	else
		"no match"
	end
	match_label = image_label;
end

