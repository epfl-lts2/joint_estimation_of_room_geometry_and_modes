function [P,coeff] = orthogonal_multi(H,w,phitheta,kmax)
%ORTHOGONAL Orthogonal polynomials required for rational fraction 
% polynomials method. (This code was written to be used with rfp.m)
%
% Syntax: [P,coeff] = orthogonal(H,w,phitheta,kmax)
%
% H        = FRF measurement (receptance)
% w        = frequency range vector (rad/sec)
% phitheta = weighting function (must be 1 for phi matrix or 2 for 
%            theta matrix)
% kmax     = degree of the polynomial
%
% P        = matrix of the orthogonal polynomials evaluated at the 
%            frequencies
% coeff    = matrix used to transform between the orthogonal polynomial 
%            coefficients and the standard polynomial
%
% Reference: Mark H.Richardson & David L.Formenti "Parameter Estimation 
%            from Frequency Response Measurements Using Rational Fraction 
%            Polynomials", 1ºIMAC Conference, Orlando, FL. November, 1982.
%**********************************************************************
% Chile, March 2002, Cristian Andrés Gutiérrez Acuña, crguti@icqmail.com
% Modified by Etienne Rivet & Sami Karkar, October 2013
%**********************************************************************

% ************** Figure 12 from paper **************
if phitheta == 1
    q = 1./(abs(H)).^2;     % weighting function for phi matrix
elseif phitheta == 2
    q = ones(size(H));      % weighting function for theta matrix
                            %(magnitude of FRF squared)
end

R_minus1 = zeros(size(w));
R_0 = 1/sqrt(2*sum(q)).*ones(size(w));
R = [R_minus1 R_0]; % polynomials -1 and 0.
coeff = zeros(kmax+1,kmax+2);
coeff(1,2) = 1/sqrt(2*sum(q));

% generating orthogonal polynomials matrix and transform matrix
% ************** Figure 17 from paper **************
for k = 1:kmax
    Vkm1 = 2*sum(w.*R(:,k+1).*R(:,k).*q);
    Sk = w.*R(:,k+1)-Vkm1*R(:,k);
    Dk = sqrt(2*sum((Sk.^2).*q));
    R = [R Sk/Dk]; %#ok<AGROW>
    coeff(:,k+2) = -Vkm1*coeff(:,k);
    coeff(2:k+1,k+2) = coeff(2:k+1,k+2)+coeff(1:k,k+1);
    coeff(:,k+2) = coeff(:,k+2)/Dk;
end

R = R(:,2:kmax+2);          % orthogonal polynomials matrix
coeff = coeff(:,2:kmax+2);  % transform matrix

% make complex by multiplying by j^k
for k = 0:kmax
    P(:,k+1) = R(:,k+1)*1j^k; %#ok<AGROW> complex orthogonal polynomials matrix
    jk(1,k+1) = 1j^k;         %#ok<AGROW>
end
coeff = (jk'*jk).*coeff;    % complex transform matrix
