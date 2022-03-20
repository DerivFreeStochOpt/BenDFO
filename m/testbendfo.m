% This file covers the BenDFO m files
%   calfun.m dfoxs.m jacobian.m dfovec.m g_dfovec_1d.m
% Updated versions may be found at github.com/POptUS/BenDFO
%
% Note: Full code coverage can be achieved by setting running the smooth 
% version of problem 5 with x(1) < 0 and with x(1) = 0.

addpath('../data') % location of dfo.dat
load dfo.dat
numprobs = size(dfo,1);

probnames = {'smooth','nondiff','wild3','noisy3'};

% Global variables needed
global m np nprob probtype fvals nfev

% Initialize the results cell and fvals array
Results = cell(length(probnames),numprobs);
fvals = zeros(1,numprobs);

for np = 1:numprobs
    nprob = dfo(np,1);
    n = dfo(np,2);
    m = dfo(np,3);
    factor_power = dfo(np,4);
    
    % Obtain starting vector
    Xs = dfoxs(n,nprob,10^factor_power);
    
    % Loop over the 4 problem types
    for p = 1:4
        probtype = probnames{p};
        nfev = 0;
        switch probtype
            case 'smooth'
                [f,fv,G] = calfun(Xs);
                Results{p,np}.f = f;
                Results{p,np}.Xs = Xs;
                Results{p,np}.Fv = fv;
                Results{p,np}.G = G;
            otherwise % skip gradients for the other problems
                rand('state',1) % For reproducibility of 'noisy3'
                [f,fv] = calfun(Xs);
                Results{p,np}.f = f;
                Results{p,np}.Fv = fv;
                Results{p,np}.Xs = Xs;
        end
    end
end

% The following file can be compared with ../data/testout.dat
%   diff testout.dat ../data/testout.dat

fid = fopen('testout.dat','w');
p = 1;
for np = 1:numprobs
    fprintf(fid,'%3i  %8s  %3i  %3i  %6.5e  %6.5e  %6.5e  %6.5e \n',np,...
        probnames{p},size(Results{p,np}.Xs,1),size(Results{p,np}.Fv,1),...
        Results{p,np}.f,abs(sum(sin(Results{p,np}.Fv))), ...
        norm(Results{p,np}.G,2),Results{p,np}.G'*Results{p,np}.Xs);
end
for p = 2:4
    for np = 1:numprobs
        fprintf(fid,'%3i  %8s  %3i  %3i  %6.5e  %6.5e \n',np,...
            probnames{p},size(Results{p,np}.Xs,1),size(Results{p,np}.Fv,1),...
            Results{p,np}.f,abs(sum(sin(Results{p,np}.Fv))));
    end
end
fprintf(fid,'\n');
fclose(fid);
