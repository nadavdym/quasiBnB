function [P,Q,t0,R0]=createSyntheticICPProblem(sigma,n,seed)
%create synthetic problem which should emphasize our advantages
rng(seed);

%random point cloud
Q=randn(3,floor(n/2));
Q=[Q -Q]; %symmetrize around the origin
%random rotation
temp=randn(3);
[U,~,V]=svd(temp);
R0=U*V';
if det(R0)<0
    R0=-R0;
end

P=R0*Q;
%make a scaling perturbation
P=(1+sigma)*P;

%normalize to unit cube
MP=max(abs(P(:)));
MQ=max(abs(Q(:)));
M=max(MP,MQ);
if M>1
P=P/M;
Q=Q/M;
end
t0=zeros(3,1);
end