function [f0,alpha,Q,poles,res] = rfp_multi(f,H,N,M)
% RFP Modal parameter estimation from frequency response function using 
% rational fraction polynomial method.
%
% f     = frequency range vector (Hz)
% H     = FRF measurements (receptance)
% N     = # of degrees of freedom
% f0    = natural frequencies (Hz)
% alpha = FRF generated (receptance)
% Q     = quality factors
% poles = poles
%
% Reference: Mark H.Richardson & David L.Formenti "Parameter Estimation 
%            from Frequency Response Measurements Using Rational Fraction 
%            Polynomials", 1ºIMAC Conference, Orlando, FL. November, 1982.
%**********************************************************************
% Chile, March 2002, Cristian Andrés Gutiérrez Acuña, crguti@icqmail.com
% Modified by Etienne Rivet & Sami Karkar, October 2013
%**********************************************************************

nom_f = max(f);
f = f./nom_f;   % f normalization for scaling the frequency axis
n = 2*N;        % # of polynomial terms in denominator
if nargin < 4
    m = n-1+4;
else
    m = n-1+M;      % # of polynomial terms in numerator
end
p = size(H,2);
alpha = zeros(length(f),p);

% orthogonal function that calculates the orthogonal polynomials
cas = 2; % 1 for orthogonal, 2 for orthogonal_bis
for kp = 1:p
    switch cas
        case 1
            [Theta,coeff_B] = orthogonal(H(:,kp),f,2,n);
            [Phi,coeff_A] = orthogonal(H(:,kp),f,1,m);
                T = sparse(diag(H(:,kp)))*Theta(:,1:end-1);
                W = H(:,kp).*Theta(:,end); % fig 15
                X = -2*real(Phi'*T);
                G = 2*real(Phi'*W);
        case 2
            [Theta,coeff_B] = orthogonal_multi(H(:,kp),f,2,n); 
            [Phi,coeff_A] = orthogonal_multi(H(:,kp),f,1,m);
            P = sparse(diag(1./H(:,kp)))*Phi;                  % L x m+1 fig 14 and 15
            W = Theta(:,end);                                  % L x 1
            X = -2*real(P'*Theta(:,1:end-1));                  % m+1 x n eq 20
            G = 2*real(P'*W);                                  % m+1 x 1 eq 20
    end

    Thetak{kp} = Theta;
    Phik{kp} = Phi;
    coeff_Ak{kp} = coeff_A;
    coeff_Bk{kp} = coeff_B;
    Xk{kp} = X;                                                % m+1 x n
    Gk{kp} = G;                                                % m+1 x 1
    Uk{kp} = eye(size(X,2))-X.'*X;                             % n x n fig 19
    Vk{kp} = X'*G;                                             % n x 1 G -> H
end

U = cell2mat(vertcat(Uk(:)));
V = cell2mat(vertcat(Vk(:)));

d = -U\V; % eq 32
D = [d;1];          % {D} orthogonal denominator polynomial coefficients

for kp = 1:p
    G = Gk{kp};
    X = Xk{kp};
    Phi = Phik{kp};
    Theta = Thetak{kp};
    
    C = G-X*d;      % {C} orthogonal numerator polynomial coefficients
    
    % calculation of FRF (alpha)
    for k = 1:length(f)
        numer = sum(C.'.*Phi(k,:));
        denom = sum(D.'.*Theta(k,:));
        alpha(k,kp) = numer/denom;
    end

    A(:,kp) = coeff_Ak{kp}*C;
    A(:,kp) = A(end:-1:1,kp).'; % {A} standard numerator polynomial coefficients
    
    B(:,kp) = coeff_Bk{kp}*D;
    B(:,kp) = B(end:-1:1,kp).'; % {B} standard denominator polynomial coefficients
    
end
% Calculation of poles and residues
% [~,P] = residue(A(:,1),B(:,1));
P = [];
for nmes = 1:size(H,2)
    [res(:,nmes),P(:,nmes)] = residue(A(:,nmes),B(:,nmes));
end
res = res(1:2:end,:);
poles = P(1:2:end,1);
poles = poles(end:-1:1)*nom_f;      % poles
f0 = abs(poles);                    % natural frequencies
Q = -abs(poles)./(2*real(poles));   % quality factor
