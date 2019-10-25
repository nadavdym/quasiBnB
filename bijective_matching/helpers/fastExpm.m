function R=fastExpm(S)
%attempt to compute expm faster
[V,D]=eig(S);
R=V*diag(exp(diag(D)))*V';
R=real(R);
end