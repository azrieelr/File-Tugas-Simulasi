clc, clf, clear all

O = 4;
N = 2^O-1;
pattern1 = prbs(O,N);
pattern2=pattern1';
stairs(pattern1)
input = [5000, 2000, 3000];
input2 = [100, 50, 1.7, 0.2];
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
W14 = 0.844;
W21 = -0.534;
W22 = 0.421;
W23 = 0.864;
W24 = 0.934;
b11 = 1.111;
b12 = 0.325;
b13 = 0.600;
b14 = 0.850;
b2  = 0.476;
y1nn = zeros(250,1);
y2nn = zeros(250,1);
for k = 1:size(blackbox_PRBSresponse,1)
    iter = k
    Target = blackbox_PRBSresponse(k,1);
    error = 1
    while 1==1 
        if abs(error) <= 0.01
            break
        else     
            %forward
            N11 = W11*input(1,k)+b11;
            A11 = logsig(N11);
            N12 = W12*input(1,k)+b12;
            A12 = logsig(N12);
            N13 = W13*input(1,k)+b13;
            A13 = logsig(N13);
            N14 = W14*input(1,k)+b14;
            A14 = logsig(N14);
            A2 = purelin((W21*A11+W22*A12+W23*A13+W24*A14)+b2);
            error = Target-A2
            %Backpropagation
            S2 =-2*1*error;
            S11 = (1-A11).*A11.*(W21*S2);
            S12 = (1-A12).*A12.*(W22*S2);
            S13 = (1-A13).*A13.*(W23*S2);
            S14 = (1-A14).*A14.*(W24*S2);
            %update param
            alpha = 0.1;
            W11 = W11-alpha*S11*input(1,k);
            b11 = b11-alpha*S11;
            W12 = W12-alpha*S12*input(1,k);
            b12 = b12-alpha*S12;
            W13 = W13-alpha*S13*input(1,k);
            b13 = b13-alpha*S13;
            W14 = W14-alpha*S14*input(1,k);
            b14 = b14-alpha*S14;
            
            W21 = W21-alpha*S2*A11;
            W22 = W22-alpha*S2*A12;
            W23 = W23-alpha*S2*A13;
            W24 = W24-alpha*S2*A14;
            b2  = b2-alpha*S2;
        end
        y1nn(k,1) = A2;
        for k = 1:size(y2nn,1)
            N11 = W11*input2(1,k)+b11;
            A11 = logsig(N11);
            N12 = W12*input2(1,k)+b12;
            A12 = logsig(N12);
            N13 = W13*input2(1,k)+b13;
            A13 = logsig(N13);
            N14 = W14*input2(1,k)+b14;
            A14 = logsig(N14);
            A2 = purelin((W21*A11+W22*A12+W23*A13+W24*A14)+b2);
            error2 = Target-A2
        end
        y2nn(k,1) = A2
    end
end
