%function [segments, output]= doubleTalk_detection (x,y)

close all
clear all

Fs=16000;
fl=100;fh=7000;
%% Loading the reference signal

[inp,Fs_read] = audioread('Reference signal.wav');
%ref = speech_band_filter (fl,fh, Fs, inp); % This corresponds to the part where only far-end is talking. 
ref=resample(inp,Fs,48000);
start_point=1;stop_point=length(ref);%adjust according to the Fs!

x=ref(start_point:stop_point,1);
figure, plot(ref);


%% Loading the Mic signal

[inp2,Fs_read] = audioread('Microphone_signal.wav');
%mic_sig = speech_band_filter (fl,fh, Fs, inp2); %corresponding to the part where only far-end is talking.
mic_sig=resample(inp2,Fs,Fs_read);
y=mic_sig(start_point:stop_point,1);
hold on,plot(mic_sig,'g');


%% Adaptive Function
filterlength = 1024; % equivalent of 64 ms (at new sample rate Fs=16kHz). 
totallength=size(y,1);


N = 570000;
% begin of algorithm
w = zeros ( filterlength  , 1 ) ;
%y_hat = zeros(lenght(y) , 1 );
%e = zeros(length(y) , 1 );
y_hat = zeros(size(y));
e=zeros(size(y_hat));
error=zeros(1,length(filterlength : totallength));
ru=zeros(1,length(filterlength : totallength));
u=zeros(1,filterlength);d=zeros(1,filterlength);
tic,

for n = filterlength : totallength
	u = x(n:-1:n-filterlength+1);
    d = y(n:-1:n-filterlength+1);
    U=mean(u);
    D=mean(d);
    
    u_norm=(u-U);
    d_norm=(d-D);
    
    ru(n)=(u_norm'*d_norm)^2/((u_norm'*u_norm)*(d_norm'*d_norm));    

end

toc,

figure, plot(ru);