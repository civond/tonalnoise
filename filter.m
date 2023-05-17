clear all; close all;

%% DSP Midterm Q1

[x, Fs] = audioread('noisy_audio.wav');   
n = length(x);              % number of samples
t = (0:n-1)'/Fs;            % t : time axis

f_null1 = 400; %Hz
om_1 = 2 * pi * f_null1 / Fs;

%% IIR Notch Filter
r = 0.95;

b = [1 (-4*cos(om_1)) (2+4*cos(om_1)^2) (-4*cos(om_1)) 1];        % filter coefficients
a = [1 (-4*r*cos(om_1)) (2*(r^2)+4*(cos(om_1)^2)*r^2) (-4*(r^3)*cos(om_1)) ((r^4))];

%% Filter 1: Convolution of IIR Filter with Moving Average

N = 8; %N point moving average
b_ma = (1/N)* ones(1,N);
a_ma = zeros(1,N);
a_ma(1) = 1;

temp_num1 = zeros(length(a_ma),(length(a_ma)+length(b)-1));
temp_den1 = zeros(1,length(a_ma));

for i = 1:N %Numerator
    temp_num1(i,i) = b_ma(i)*b(1);
    for z=1:(length(a)-1)
        temp_num1(i,i+z) = b_ma(i)*(b(z+1));
    end
end

for i = 1:length(a) %Denominator
    temp_den1(i) = a(i);
end

num_coeffs1 = sum(temp_num1); %Sum of columns in temp_num1
den_coeff1 = temp_den1;

k1 = sum(den_coeff1) / sum(num_coeffs1); %
num_coeffs1 = num_coeffs1*k1;

y1 = filter(num_coeffs1,den_coeff1,x);

%% Filter 2: Convolution of IIR Filter with Butterworth Filter.

[b_butter,a_butter] = butter(4,1000/(8000/2),'low');

temp_num2 = zeros(length(b_butter),(length(b_butter)+length(b)-1));
temp_den2 = zeros(length(a_butter),(length(a_butter)+length(a)-1));

for i = 1:length(b_butter) %Numerator
    temp_num2(i,i) = b_butter(i)*b(1);
    for z=1:(length(b)-1)
        temp_num2(i,i+z) = b_butter(i)*(b(z+1));
    end
end

for i = 1:length(a_butter) %Denominator
    temp_den2(i,i) = a_butter(i)*a(1);
    for z=1:(length(a)-1)
        temp_den2(i,i+z) = a_butter(i)*(a(z+1));
    end
end

num_coeffs2 = sum(temp_num2); %Sum of columns in temp_num2
den_coeffs2 = sum(temp_den2); %Sum of columns in temp_den2

k2 = sum(den_coeffs2) / sum(num_coeffs2); 
num_coeffs2 = num_coeffs2*k2;

y2 = filter(num_coeffs2,den_coeffs2,x);

%% Plotting

figure(1); %Audio Signal
subplot(2,1,1);
plot(t,x,'-b',t,y1,'-r');
title('Noisy Signal vs. Filter 1');
xlim([0,11]);
xlabel('Time (s)');
legend('Noisy Signal','Filtered Signal');
grid("on");

subplot(2,1,2);
plot(t,x,'-b',t,y2,"m");
title('Noisy vs. Filter 2');
xlim([0,11]);
xlabel('Time (s)');
legend('Noisy Signal','Filtered Signal');
grid("on");

figure(2); % Audio Signal Zoom
subplot(2,1,1);
plot(t,x,'-b',t,y1,'-r');
title('Noisy Signal vs. Filter 1 (Zoomed)');
xlim([1.55 1.60]);
xlabel('Time (s)');
legend('Noisy Signal','Filtered Signal');
grid("on");

subplot(2,1,2);
plot(t,x,'-b',t,y2,'m');
title('Noisy vs. Filter 2 (Zoomed)');
xlim([1.55 1.60]);
xlabel('Time (s)');
legend('Noisy Signal','Filtered Signal');
grid("on");

figure(3) % Pole Zero
zplane(num_coeffs1,den_coeff1);
title('Filter 1 Pole Zero');

figure(4);
zplane(num_coeffs2,den_coeffs2);
title('Filter 2 Pole Zero');

figure(5) %Frequency Response
[H1, om_filter1] = freqz(num_coeffs1,den_coeff1);
[H2, om_filter2] = freqz(num_coeffs2,den_coeffs2);

subplot(2,1,1);
plot(om_filter1/(2*pi)*Fs, abs(H1),'-r')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Filter 1 Frequency Response');
grid("on");

subplot(2,1,2);
plot(om_filter2/(2*pi)*Fs, abs(H2),'-m')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Filter 2 Frequency Response');
grid("on");

%% Write Audio
audiowrite('output_filter1.wav', y1, Fs);
audiowrite('output_filter2.wav', y2, Fs);
