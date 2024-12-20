close all
clear all
clc

addpath tools
myFolder = pwd;
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.mat');
theFiles = dir(filePattern);
avgC=zeros(1,length(theFiles));
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    load(fullFileName)
    if noiseType == 'pseudo' & N_prn ~= N_stft
        X = stft(F,fs,w,R,M);
        Y = stft(a,fs,w,R,M);
        
       % Single-sided spectra (changed)
        X = X(1:M/2+1,2:end-1);
        Y = Y(1:M/2+1,2:end-1);

        % Time-averaging
        XX = mean(X .* conj(X),2);
        YY = mean(Y .* conj(Y),2);
        XY = mean(X .* conj(Y),2);

        % H1 estimate: Sensitivity to input noise
        H1 = XY ./ XX;

        % H2 estimate: Sensitivity to output noise
        H2 = YY ./ conj(XY);

        % Coherence
        C = abs(XY).^2 ./ (XX .* YY); % => C = H1 ./ H2;

        % SNR
        SNR = C ./ (1 - C); 
    end
    avgC(k)=mean(C);
    if k==5 || k==6
        f=[1:length(XX)]*fs/length(XX);
        figure
        semilogx(f,10.*log10(SNR))
        xlabel('Frequency (Hz)','interpreter','latex')
        ylabel('Magnitude (dB)','interpreter','latex')
        title('SNR','interpreter','latex')
        xlim([f(1) f(end)])
        grid on
        
        figure
        plot(t,[x y]')
        title('Original signal x and recordings F \& a','interpreter','latex')
        xlabel('Time (s)','interpreter','latex')
        ylabel('Amplitude','interpreter','latex')
        legend('Played signal - x','Force transducer - F','Accelerometer - a','interpreter','latex')

        figure
        loglog(f,abs(H1),f,abs(H2))
        xlabel('Frequency (Hz)','interpreter','latex')
        ylabel('Magnitude','interpreter','latex')
        title(['$|H_1|$ and $|H_2|$, w = ' winType],'interpreter','latex')
        legend('$|H_1|$','$|H_2|$','interpreter','latex')
        ax=axis;
        axis([0 fs/2 ax(3) ax(4)])

        figure
        semilogx(f,C)
        xlabel('Frequency (Hz)','interpreter','latex')
        ylabel('0 $\le$ Magnitude $\ge$ 1','interpreter','latex')
        title(['Coherence Average = ' num2str(avgC(k))],'interpreter','latex')
        axis([0 fs/2 0 1])
    end
end

