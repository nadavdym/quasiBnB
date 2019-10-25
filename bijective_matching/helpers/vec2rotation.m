function R=vec2rotation(vectorForm,orientation,d)
%get rotation from vector represtation, with determinant determined by
%orientation

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
if orientation==-1
    D=eye(d);
    D(1,1)=-1;
    R=D*R;
end

end