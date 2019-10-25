function [P,Q,t0,R0]=createRandomICPProblem(sigma,n,seed)
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
Q=2*rand(3,n)-1;
N=randn(3,n);
P=R0*Q+sigma*N+t0;
%centralize and normalize to unit cube
mP=mean(P,2);
P=P-mP;
mQ=mean(Q,2);
Q=Q-mQ;
t0=R0*mQ+t0-mP;


MP=max(abs(P(:)));
MQ=max(abs(Q(:)));
M=max(MP,MQ);
if M>1
P=P/M;
Q=Q/M;
t0=t0/M;
end

end