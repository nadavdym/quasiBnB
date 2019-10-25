function inds=getNewGeneration(prevInds,d)
%make a new vector of indices correpsonding to a deeper depth of cubes
D=0.5*(d^2-d); %dimension of SO(d)
depth=size(prevInds,1);
n=size(prevInds,2);
inds=inf(depth+1,2^D*n);
for jj=1:n
   inds(1:depth,(jj-1)*2^D+(1:2^D))=prevInds(:,jj)*ones(1,2^D);
   inds(depth+1,(jj-1)*2^D+(1:2^D))=1:2^D;
end

end