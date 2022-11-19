%% generate data 
% masih nyoba linear !! 
%a = [ 1 1 1 0 0 1 0 1 0 0 0 1 1 0 0 1 1 1 0 0] % prbs
%b = []; % output nn
%for i=1:size(a,2)
%    b(1,i) = (a(1,i) + 3)/((a(1,i)+4)*(a(1,i)+5));
%end
syms u
input_nl = u(1:64,:);
output = kec_frontback_u;
Data = [];
for j=1:size(input_nl,1)
    Data(j,1) = input_nl(j,1);
    Data(j,2) = output(j,1);
end
%% training data
%generate NN
%init param
%synaptic weights
W11 = -0.963;
W12 = 0.643;
W21 = 0.584;
W22 = 0.844;
%bias
b11 = -0.111;
b12 = 0.231;
b2  = 0.476;
%init iter and error tolerance
iter_data = 0;
ErrorTol = 1 ;
%choice error tolerance 
ErrorTol_choice = 10^-4 ;
% init epoch
epoch = 5;
iter_epoch = 0;
for k = 1:epoch
    iter_epoch = iter_epoch + 1
    for j = 1:size(Data,1)
        iter_data = iter_data + 1
        input = Data(j,1)
        Target = Data(j,2)
        while 1==1
            if abs(ErrorTol) <= ErrorTol_choice
                A2 = A2
                break
            else
                %forward
                N11 = W11*input+b11;
                A11 = logsig(N11);
                N12 = W12*input+b12;
                A12 = logsig(N12);
                A2 = purelin((W21*A11+W22*A12)+b2);
                error = abs(Target-A2)
                %Backpropagation
                S2 = -2*1*error;
                S11 = (1-A11)*A11*(W21*S2);
                S12 = (1-A12)*A12*(W22*S2);
                %update param
                alpha = 0.1;
                W11 = W11-alpha*S11*input;
                b11 = b11-alpha*S11;
                W12 = W12-alpha*S12*input;
                b12 = b12-alpha*S12;
                W21 = W21-alpha*S2*A11;
                b2  = b2-alpha*S2;
                W22 = W22-alpha*S2*A12;
                ErrorTol = error;
            end
        end
    end
end
%% predict and calculate accuracy
%predict
c = [ 2 3 4 5 1 1 0 6 7 9 ]
d = [];
for z = 1:size(c,2)
    d(1,z) = (c(1,z) + 3)/((c(1,z)+4)*(c(1,z)+5));
end
Acc = [];
for p = 1:size(c,2)
    N11 = W11*c(1,p)+b11;
    A11 = logsig(N11);
    N12 = W12*c(1,p)+b12;
    A12 = logsig(N12);
    A2 = purelin((W21*A11+W22*A12)+b2);
    error = d(1,p)-A2;
    Acc(1,p) = error;
end
%calculate accuracy
bener = 0;
for v = 1:size(Acc,2)
    if Acc(1,v) < 0.001
        bener = bener + 1;
    end
end
Accuracy = ( bener / size ( Acc,2 ))*100