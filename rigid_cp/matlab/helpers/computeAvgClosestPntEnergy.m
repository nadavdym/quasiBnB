function E=computeAvgClosestPntEnergy(P,Q,R,T)
%compute average closest point energy, for given solutions R,T
if isempty(R) || isempty(T)
    E=inf;
    return;
end
n=size(P,2);
Q = bsxfun(@plus, R*Q, T);
idx=knnsearch(P',Q');
E=1/n*norm(Q-P(:,idx),'fro')^2;
end