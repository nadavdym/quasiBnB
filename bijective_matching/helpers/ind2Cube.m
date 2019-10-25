function [c,l]=ind2Cube(ind)
%given an index in {1,2,..,8}^d, return a corresponding edge length and
%centroid defining a sub cube of the unit cube (centroid 0, half edge length 1)
d=length(ind);
B=[1 1 1;1 1 -1; 1 -1 1; -1 1 1; -1 -1 1; -1 1 -1; 1 -1 -1; -1 -1 -1];
coeff=2.^(-(1:d));
coeff=coeff';
binary=B(ind,:)';
c=binary*coeff;
l=2^-d;
end