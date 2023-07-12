function [outsig,w,ru] = NLMS_AcousticEchoCanceller(ref_sig, mic_sig, filterlength, farend_activity_thresh, correlation_thresh)
%%%%%%%%%%%% created by Amin Saremi, Last updated 9/4/2020. %%%%%%%%%%%%%%%
%% parameter definitions

% <ref_sig> : the reference signal audio samples.

% <mic_signal>: the audio samples captured by the microphone

% <filterlength>: the size of the Wiener filter that mimics the room's
% impulse response. Recommendation: set the number to equivalent of 50ms in time.

% <farend_activity_thresh>: the threshold that defines the activity in the
% far end. If the signal energy is less than this threshod, then it is assumed
% that the far end is silent.

% <correlation_thresh>: If the correlation is less than this threshold,
% then it is assumed that there is no double talk.

% <outsig>: The error signal (e). This is the output of the algorithm. 

%% NLMS Adaptive algorithm

totallength=size(mic_sig,1);

w = zeros ( filterlength  , 1 ) ;
y_hat = zeros(size(mic_sig));
e=zeros(size(mic_sig));
ru=zeros(size(mic_sig));
mu=0;
cnt=0;
for n = filterlength : totallength
	u = ref_sig(n:-1:n-filterlength+1);
    if rms(u)<farend_activity_thresh % The reference signal can be regarded as empty (far-end doesn't talk). Do not proceed. 
        y_hat(n)=0;
        e(n)=mic_sig(n);
    else % The far end is talking. 
        y_hat(n)= w' * u;
        e(n) = mic_sig(n) - y_hat(n);
        %%%%%% cross-correlation for double talk detection
        d = mic_sig(n:-1:n-filterlength+1);
        U=mean(u);
        D=mean(d);
    
        u_norm=u-U;
        d_norm=d-D;
        var_u=u_norm'*u_norm;
    
        ru(n)=sqrt((u_norm'*d_norm)^2/(var_u*(d_norm'*d_norm))); 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        if ru(n)<= correlation_thresh % The near end is talking too (Double talk is detected). Do not adapt. 
            mu=0;
            cnt=cnt+1;
        
        else % if the reference signal is active and there is no double talk, then adapt. 
            mu=0.99*2/(var_u+0.1); % alpha=1.98, sigma=0.1. see euation 7 of Paleologu et al. (2015) for info.
            w = w + mu * u * e(n);
        end
    end
    
end
cnt
outsig = e;


%% Show some results

% figure()
% semilogy((abs(e))) ;
% title('Error curve') ;
% xlabel('Samples')
% ylabel('Error value')
% figure,
% plot(w, 'b'); 

