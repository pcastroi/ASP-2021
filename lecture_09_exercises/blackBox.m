function [outSig] = blackBox(inSig,fs,sysSelect)
% Blackbox

% Validate input
if nargin < 3
    error('Not enough input arguments.');
end
if size(inSig,2) ~= 1
    error('Expected input signal is a column vector.');
end

% Generate some filters to play around with
rng(0); % Reset random number generator to ensure reproducible results.

% Create 'telephone' bandpass filter
[b,a] = butter(4,[300/(fs/2), 3300/(fs/2)],'bandpass');

% Generates a 'reverberant' system with exponential decay.
T = 1; % seconds, IR duration
RT = 0.8; % reverberation time (RT60)

% Generate noise
noise = 2*rand(T*fs,1)-1;

% Apply exponential decay with given RT60
t = (0:1/fs:T-1/fs).';
ir = exp(-t/RT*3*log(10)).*noise;
% Normalize to unity gain
ir = ir ./ sqrt(sum(ir.^2,1));

switch sysSelect
    case 'system_a' % Telephone
        outSig = filter(b,a,inSig);
    
    case 'system_b' % Reverberant system with delay
        delay = 0.01; %sec
        ir = [zeros(ceil(delay*fs),1); ir];
        ir = ir(1:T*fs);
        % Zero-pad input signal with length(ir)-1 as fftfilt restricts the
        % output length to that of the input.
        inSig = [inSig; zeros(length(ir)-1,1)];
        outSig = fftfilt(ir,inSig);
    
    case 'system_c' % Reverberant system with delay and noise
        delay = 0.1; %sec
        noiseLevel = -50; % dBFS
        ir = [zeros(ceil(delay*fs),1); ir];
        ir = ir(1:T*fs);
        % Zero-pad input signal with length(ir)-1 as fftfilt restricts the
        % output length to that of the input.
        inSig = [inSig; zeros(length(ir)-1,1)];
        outSig = fftfilt(ir,inSig);
        bkg_noise = pinkNoise(size(outSig,1),fs);
        outSig = outSig + bkg_noise.*10^(noiseLevel/20);

    otherwise
        error('Specified system does not exist.');
end

end
function out = pinkNoise(nsamples,fs)
    % Generate some pink noise in the frequency domain
    nfft = nsamples;
    nfft = nfft + mod(nfft,2); % Ensure even nfft
    freq = (0:(nfft/2)).'*fs/nfft;
    N_mag = ones(nfft/2+1,1);

    % Create pink (1/f) PSD
    start_ind = find(freq > 20,1);
    % Start the 1/f decay only above a certain bin to avoid too much energy at LF
    N_mag(start_ind:end) = sqrt(freq(start_ind)./freq(start_ind:end)*1);

    % Create random phase
    N_phase = rand(nfft/2+1,1)*2*pi;
    
    % Construct complex spectrum
    N_onesided = N_mag.*exp(1i.*N_phase);
    N = [N_onesided; flipud(conj(N_onesided(2:end-1)))];
    
    % Transform to time domain
    n = ifft(N,'symmetric');
    n = n(1:nsamples);
    
    % Normalize to rms == 1
    out = n ./ rms(n);
end
