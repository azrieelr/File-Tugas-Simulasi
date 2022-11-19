close all, clear all, clc, format compact

x = [10 20 50]' % input vector (6-dimensional pattern)
y = [3.2 3 1]' % corresponding target output vector
% create network
net = network( ...
1, ... % numInputs, number of inputs,
2, ... % numLayers, number of layers
[1; 0], ... % biasConnect, numLayers-by-1 Boolean vector,
[1; 0], ... % inputConnect, numLayers-by-numInputs Boolean matrix,
[0 0; 1 0], ... % layerConnect, numLayers-by-numLayers Boolean matrix
[0 1] ... % outputConnect, 1-by-numLayers Boolean vector
);
% Neuron weights
w = [4 -2]
% Neuron bias
b = -3
% Activation function
 func = 'tansig'
% func = 'purelin'
% func = 'hardlim'
% func = 'logsig'
p = [0.7 1.2]
activation_potential = p*w'+b
euron_output = feval(func, activation_potential)
% View network structure
%view(net);
% number of hidden layer neurons
net.layers{1}.size = 4;
net.layers{2}.size = 4;
% hidden layer transfer function
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'logsig';
%view(net);
net = configure(net,x,y);
%view(net);
% initial network response without training
initial_output = net(x)
% network training
net.trainFcn = 'trainlm';
net.performFcn = 'mse';
net = train(net,x,y);
% network response after training
final_output = net(x)