function [frequency, damping_factor ] = get_damping ...
    (R, MES_T, frequency)
DAMPING_STEP = 0.01;
DAMPING_FACTOR_MAX=-0.5;
DAMPING_FACTOR_MIN=-20;
DAMPING_VECTOR = DAMPING_FACTOR_MIN:DAMPING_STEP:DAMPING_FACTOR_MAX;

DAMPING_VECTOR_TIME = exp(kron(DAMPING_VECTOR,MES_T));
for n = 1:length(DAMPING_VECTOR)     % per every damping factor
  DAMPING_VECTOR_TIME(:,n) = DAMPING_VECTOR_TIME(:,n).*exp(1j*2*pi*frequency*MES_T);
  DAMPING_VECTOR_TIME(:,n) = DAMPING_VECTOR_TIME(:,n)/norm(DAMPING_VECTOR_TIME(:,n), 'fro') ;
end

expansion = zeros(size(DAMPING_VECTOR_TIME));
for n = 1:length(DAMPING_VECTOR)     % per every damping factor
    for j = 1:size(R,2)                                  % per every receiver
        expansion(:, n) = expansion(:, n) + abs(DAMPING_VECTOR_TIME(:,n)'*R(:,j));
    end
end

expansion = sum(expansion);
[~, index] = max(expansion);
damping_factor = DAMPING_VECTOR(index);
end