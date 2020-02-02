function [Alpha] = Random_Coeff(C, K)
X = C;
Y = K;
Alpha = zeros(X,Y);
for ii = 1:1:X
    %for jj = 1:1:K
        %----GENERATING RANDOM COEFF. BASED ON CURRENT TIME----
        rng('shuffle')
        T = randi(2048);
        rng(T)  
        %------------------------------------------------------
        for jj = 1:1:Y
            Alpha(ii, jj) = randi(15); % for q = 4 GF 16
            %Alpha(ii, jj) = randi(255); % for q = 8 GF 256
        end
        %rng('default')
        %end
%end
end
end