function [P,Q,t0,R0]=createRandomICPProblemPartial(sigma,n,seed,m)
rng(seed)
t0=randn(3,1);
%random rotation
temp=randn(3);
[U,~,V]=svd(temp);
R0=U*V';
if det(R0)<0
    R0=-R0;
end

t0=0.4*(1/max(abs(t0(:))))*t0;


P=2*rand(3,m)-1;
N=randn(3,n);
Q=R0'*P(:,1:n)+sigma*N+t0;
%centralize and normalize to unit cube
mQ=mean(Q,2);
Q=Q-mQ;
mP=mean(P,2);
P=P-mP;
t0=R0*mQ-R0*t0-mP;


MP=max(abs(Q(:)));
MQ=max(abs(P(:)));
M=max(MP,MQ);
if M>1
Q=Q/M;
P=P/M;
t0=t0/M;
end


 %warning('taking t0 to be zero');
% P=2*rand(3,m)-1;
% Q=P(:,1:n);
% t0=zeros(3,1);
% R0=eye(3);


end