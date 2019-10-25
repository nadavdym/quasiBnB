function [obj,map]=bernardAuction(cost,epsilon)
%solve auction algorithm using bernard's solver. epsilon is the required
%accuracy

n=size(cost,1);
%change of variables (algorithm maximizes, with positive cost)
newCost=-cost;
M=max(newCost(:));
m=min(newCost(:));
newCost=newCost+M-2*m;
scalingFactor = sum(abs(cost(:)))/epsilon;
newCost=scalingFactor*newCost;
newCost=sparse(newCost);
[assignments, map, prices] = ...
                        sparseAssignmentProblemAuctionAlgorithm(newCost);
obj=map(:)'*cost(:);
%normalization because we work with probability measures 
obj=obj/n;  
map=map/n;



end