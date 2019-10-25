function [R,vectorForm]=ind2Rotations(ind,d)
%given an index in {1,2,..,2^D}^n, return a corresponding rotation in O(d)

n=length(ind);
doFlip=ind(1)<0;
ind=abs(ind);
switch d
    case 2
        B=[1;-1];
    case 3
        B=[1 1 1;1 1 -1; 1 -1 1; -1 1 1; -1 -1 1; -1 1 -1; 1 -1 -1; -1 -1 -1];
end
coeff=2.^(-(1:n));
coeff=coeff';
binary=B(ind,:)';
vectorForm=pi*binary*coeff;
S=zeros(d);
switch d
    case 2
        S(1,2)=vectorForm(1);
    case 3
        S(2,1)=vectorForm(1);
        S(3,1)=vectorForm(2);
        S(3,2)=vectorForm(3);
end
S=S-S';
R=fastExpm(S);
%R=expm(S);
if doFlip
    D=eye(d);
    D(1,1)=-1;
    R=D*R;
end

end