
clear all,
close all,

%% Loading the reference signal
Fs=16000;

[inp,Fs_read1] = audioread('FM928_v25_2_ReferenceChannel.wav'); %Please place this .wav file in the same folder as the code. Fs_read is 48 kHz (the original recording).
%[inp,Fs_read1] = audioread('FM928_v25_off_ReferenceChannel.wav'); %Please place this .wav file in the same folder as the code. Fs_read is 48 kHz (the original recording).
ref_sig=resample(inp,Fs,Fs_read1);% This will downsample the data from 48 to 16 kHz. It reduces the computation load but also the resolution. 

figure, plot(ref_sig);


%% Loading the Mic signal

[inp2,Fs_read2] = audioread('FM928_v25_2_Mic1.wav'); %Please place this .wav file in the same folder as the code.
%[inp2,Fs_read2] = audioread('FM928_v25_off_Mic1.wav'); %corresponds to M928_v25_off.
mic_sig=resample(inp2,Fs,Fs_read2);

figure, plot(mic_sig,'g');

%% Define the input parameters and call the adaptive function to process the data
filterlength = 800; % equivalent of 50 ms in time (at new sample rate Fs=16kHz). This length seems suitable given the acoustic characteristics of the truck cabin. 
farend_activity_thresh = 1e-4; % This corresponds to -80 dB FS. Used as the definition of 'silence' in the far end signal.
correlation_thresh = 1e-8; % if the cross correlation between far end and mic signal is less than 10^-8 then we assume they are uncorrelated.

tic, % calculate the execution time: start the timer!
[out,w,ru] = NLMS_AcousticEchoCanceller(ref_sig, mic_sig, filterlength, farend_activity_thresh, correlation_thresh);
toc, % Stop the timer!

%% ERLE estimation

ERLE_estimate_start=4.56e5; ERLE_estimate_stop=8.5e5;% Estimate the ERLE in this period where only the far end is talking (near end is silent= no DT). This section corresponds to the HINT swedish sentences. 
%ERLE_estimate_start=9.25e4; ERLE_estimate_stop=6.44e5;% corresponds to FM928_v25_off 

pd = rms(mic_sig(ERLE_estimate_start:ERLE_estimate_stop));
pe = rms(out(ERLE_estimate_start:ERLE_estimate_stop));
ERLE= 20*log10(pd/pe) % This is the overall ERLE between the two given points

figure,plot([1:numel(mic_sig(ERLE_estimate_start:ERLE_estimate_stop))]./Fs,mic_sig(ERLE_estimate_start:ERLE_estimate_stop),'--b'), 
hold on, plot([1:numel(out(ERLE_estimate_start:ERLE_estimate_stop))]./Fs,out(ERLE_estimate_start:ERLE_estimate_stop),'r')
xlabel('time[s]'); legend('microphone signal','error signal (e)');
axis([0 27 -0.1 0.1]);
ylabel('Amplitude [+/-1 denotes 0 dB FS]'), xlabel('Time [s]');
%% correct the ERLE estimation against the background noise (only applicable when Engine is ON).

%%% Note: This section is only applicable to the case where the engine is ON (i.e. in presence of noise).  
n_start=3.4e5;n_stop=3.85e5; % This section of the signal is extractec for estimating the stationary noise floor.
P_mic=rms(mic_sig(ERLE_estimate_start:ERLE_estimate_stop));
P_e=rms(out(ERLE_estimate_start:ERLE_estimate_stop));
PN=rms(mic_sig(n_start:n_stop));

ERLE_corr=20*log10(abs((P_mic-PN)/(P_e-PN))) % corresponds to Eq. 5-c of the paper.

%% save the result and listen to it!

% audiowrite('Output_FM930_v25_off_changed.wav',out,Fs); %save the result as a wave file under the right name!

