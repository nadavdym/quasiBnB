rng(1)
sigma=0.1;
n=10; %with n=100 this takes more that 15 minutes (not clear how much more)
t0=randn(3,1);
P=randn(3,n);
N=randn(3,n);
Q=P+sigma*N+t0;
output=goICPfun(P,Q);