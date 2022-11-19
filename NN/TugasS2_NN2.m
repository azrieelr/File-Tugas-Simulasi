clc, clf, clear all

O = 4;
N = 2^O-1;
pattern1 = prbs(O,N);
pattern2=pattern1';
stairs(pattern1)
input = [10 1];
M1 = 2500;
M2 = 320;
K1 = 80000;
K2 = 500000;
b1 = 350;
b2 = 15020;

s = tf('s');
G1 = ((M1+M2)*s^2+b2*s+K2)/((M1*s^2+b1*s+K1)*(M2*s^2+(b1+b2)*s+(K1+K2))-(b1*s+K1)*(b1*s+K1));

%step(G1)
t= 0:1:14;
blackbox_PRBSresponse = lsim(G1,pattern1,t);
%plot(blackbox_PRBSresponse)

%param nn ( init )
W11 = -0.963;
W12 = 0.643;
W13 = 0.584;
W21 = -0.534;
W22 = 0.421;
W23 = 0.575;
W24 = 0.641;
W25 = 0.890;
W26 = 0.900;
W31 = -0.146;
W32 = 0.573;
b11 = -0.111;
b12 = 0.231;
b13 = 0.321;
b1  = 0.687;
b2  = 0.476;
b3  = 0.583;
y1nn = zeros(250,1);
for k = 1:size(blackbox_PRBSresponse,1)
    iter = k
    Target = blackbox_PRBSresponse(k,1);
    error1 = 1
    while 1==1 
        if abs(error1) <= 0.1
            break
        else     
            %forward
            N11 = W11*input(1,k)+b11;
            A11 = logsig(N11);
            N12 = W12*input(1,k)+b12;
            A12 = logsig(N12);
            N13 = W13*input(1,k)+b13;
            A13 = logsig(N13);
            A2 = purelin((W21*A11+W22*A12+W23*A13)+b1+b2);
            error1 = Target-A2
            
            N21 = W21*W23*W25*input(1,k)+b1;
            A21 = logsig(N21);
            N22 = W22*W24*W26*input(1,k)+b2;
            A22 = logsig(N22);
            A3 = purelin((W21*A11+W22*A12+W23*A13)+b3);
            %Backpropagation
            S2 = -2*1*error1;
            S11 = (1-A11).*A11.*(W21*W22);
            S12 = (1-A12).*A12.*(W23*W24);
            S13 = (1-A13).*A13.*(W25*W26);
            
            S21 = (1-A21).*A21.*(W31);
            S22 = (1-A22).*A22.*(W32);
            %update param
            alpha = 0.1;
            W11 = W11-alpha*S11*input(1,k);
            b11 = b11-alpha*S11;
            W12 = W12-alpha*S12*input(1,k);
            b12 = b12-alpha*S12;
            W13 = W13-alpha*S13*input(1,k);
            b13 = b13-alpha*S13;
            
            W21 = W21-alpha*S21*input(1,k);
            b21 = b1-alpha*S21;
            W22 = W22-alpha*S22*input(1,k);
            b22 = b2-alpha*S22;
            W23 = W23-alpha*S21*input(1,k);
            b23 = b1-alpha*S21;
            W24 = W24-alpha*S22*input(1,k);
            b24 = b2-alpha*S22;
            W25 = W25-alpha*S21*input(1,k);
            b25 = b1-alpha*S21;
            W26 = W26-alpha*S22*input(1,k);
            b26 = b2-alpha*S22;
            
            W31 = W21*W23*W25-alpha*S2*A21;
            W32 = W22*W24*W26-alpha*S2*A22;
            b3  = b3-alpha*S2;
        end
    end
    y1nn(k,1) = A2;
end