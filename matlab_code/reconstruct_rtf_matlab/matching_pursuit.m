function [R, index_set] = SOMP(X, D, K)
% Input:
% X - samples matrix, one signal each column
% D - dictionary, each column with unit norm
% K - spasity level
% Output:
% S - sparse coding matrix
% index_set - set of indices of used atoms in the dictionary 

% We project to the span of the columns, so their order is not important.

index_set = [];
dictionary_subset = zeros(size(D));
R = X; % matrix for which we try to find a sparse representation in our dictionary
for i = 1:K
    % atom that gives best approximation for the set of signals
    s = zeros(size(D,2),1);
    for j = 1:size(D,2)         % for each atom in dictionary matrix
        for k = 1:size(R,2)     % for each signal in signal matrix
            % Here we should use FFT instead
            s(j) = s(j) + abs(D(:,j)'*R(:,k));
        end
    end
    ind = find(s==max(s),1);
    index_set = [index_set ind];
    dictionary_subset = zeros(size(D));
    dictionary_subset(:,ind) =  D(:, ind);
    R = R - dictionary_subset*(pinv(dictionary_subset)*R);
end
end