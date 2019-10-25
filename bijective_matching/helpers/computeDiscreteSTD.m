function std=computeDiscreteSTD(P,mu)
N=sum(P.^2);
var=N*mu;
std=sqrt(var);




end