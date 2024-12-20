function mse = calcMSE(x,y,dim)
%calcMSE   Calculate the mean-squared error between vectors or matrices


%% CHECK INPUT ARGUMENTS
%
%
% Check for proper input arguments
if nargin < 2 || nargin > 3
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 3 || isempty(dim)
    dim = find(size(x)~=1, 1);
    if isempty(dim); dim = 1; end
end
  

%% MSE CALCULATION
% 
% 
% Calculate mean squared error 
mse = mean((x-y).^2,dim);