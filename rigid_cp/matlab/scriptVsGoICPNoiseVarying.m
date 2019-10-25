%this script runs keplerGoICP from a pc

sigma=0.1;

configParams=[];


configParams.MSEThresh=10^-3;
configParams.distTransSize=0; %300
% defaultTrans=true;
% if defaultTrans
%     configParams.transMinX=-0.5;
%     configParams.transMinY=-0.5;
%     configParams.transMinZ=-0.5;
%     configParams.transWidth=1;
% end

n=5; %number of points in Q (n<=m)
m=10; %number of points in P
doPlot=true;

seed=1;
%[P,Q,t0,R0]=createRandomICPProblem(sigma,n,seed);
[P,Q,t0,R0]=createRandomICPProblemPartial(sigma,n,seed,m);
outputOurs=goICPfunComparison(P,Q,'ours',doPlot,[],configParams);
outputTheirs=goICPfunComparison(P,Q,'original',doPlot,[],configParams);
realEnergyAvg=computeAvgClosestPntEnergy(P,Q,R0,t0);
EnergyAvgOurs=computeAvgClosestPntEnergy(P,Q,outputOurs.R,outputOurs.T);
EnergyAvgTheirs=computeAvgClosestPntEnergy(P,Q,outputTheirs.R,outputTheirs.T);
    %EnergyAvgKD(ii)=computeAvgClosestPntEnergy(P,Q,outputKD.R,outputKD.T);

%[P,Q,t0,R0]=createRandomICPProblemPartial(configParams.sigma,configParams.n,configParams.seedVec,configParams.m);
