%
layers = [imageInputLayer([224,224 1])
convolution2dLayer(9,74,'Padding',4)
reluLayer
maxPooling2dLayer(2,'Stride',2)
convolution2dLayer(3,27,'Padding',1)
reluLayer
maxPooling2dLayer(2,'Stride',2)
convolution2dLayer(2,23,'Padding',1)
reluLayer
maxPooling2dLayer(2,'Stride',2)
fullyConnectedLayer(40)
softmaxLayer
classificationLayer()];%/n