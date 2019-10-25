function [Ropt,map,obj,generationSizeVec,timeData]=quasiBnB(P1,P2,SO,doDisplay)
%compute optimal alignment between shapes using quasiBnB algorithm
preprocessTime=tic;
iterMax=10^6; %maximal number of LPs we allow
accuracy=10^-6;
lp_accuracy=0.1*accuracy;

%get dimensions
d=size(P1,1); 
n=size(P1,2);
D=0.5*(d^2-d); %dimension of SO(d)
assert(size(P1,1)==size(P2,1) && size(P1,2)==size(P2,2) );
assert(d<=3);

%check centralization
if abs(mean(P1'))+abs(mean(P2'))>10^-6
    error('centralize point clouds');
end

%create uniform measures
mu1=1/n*ones(n,1);
mu2=mu1;

%compute std
std1=computeDiscreteSTD(P1,mu1);
std2=computeDiscreteSTD(P2,mu2);

timeData.preprocessTime=toc(preprocessTime);
%start qBnB
runTime=tic;
depth=0;

ub=inf;
if SO
    inds=[1:2^D];
else
    inds=[ -2^D:-1 1:2^D];
end
generationSize=size(inds,2);
doStop=false;
totalRuns=0;
map=nan(n);
Ropt=nan(d);
allRopt={};
generationSizeVec=[];
keptIndNum=[];
allIterInd=0;
ubVec=inf(iterMax,1);
while ~doStop
    depth=depth+1;
    generationSizeVec(depth)=generationSize;
    objective=nan(generationSize,1);
    secondOrderLb=nan(generationSize,1);
    temp=sqrt(D)*2^(-depth)*pi;
    secondOrderErrorRadius=2*std1*std2*(exp(temp)-1-temp);
    %solve on all generation
    for ii=1:generationSize
        allIterInd=allIterInd+1;
        [R,~]=ind2Rotations(inds(:,ii),d);
        W=pdist2((R*P1)',P2');
        cost=W.^2;
        [preObj,tempMap]=bernardAuction(cost,n*lp_accuracy);
        objective(ii)=preObj;
        secondOrderLb(ii)=preObj-secondOrderErrorRadius;
        if objective(ii)<ub
            ub=objective(ii);
            Ropt=R;
            map=tempMap;
            indOpt=inds(:,ii);
        end
        ubVec(allIterInd)=ub;
    end
    totalRuns=totalRuns+generationSize;
    %prepare for next generation
    keepInd=secondOrderLb<=ub;
    keptIndNum(depth)=sum(keepInd);
    prevInds=inds(:,keepInd);
    inds=getNewGeneration(prevInds,d);
    generationSize=size(inds,2);
    UBall=ub;
    LBall=min(secondOrderLb);
    if UBall-LBall<accuracy
        doStop=true;
        fprintf('stopped BnB because requested tolerance was reached');
    elseif totalRuns+generationSize>iterMax
        doStop=true;
        warning('stopped BnB before reaching requested tolerance');
    end
    
end

obj=ub;
timeData.runTime=toc(runTime);

if doDisplay
    figure;
    plot(generationSizeVec);
    title('number of BnB iterations per generation');
    figure;
    plot(log2(generationSizeVec));
    title('log2 number of BnB iterations per generation');
    figure;
    plot(ubVec);
    title('upper bound vs iteration num');
end

end