%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  demo code for the quasi-BnB algorithm for the  rigid closest point
%  problem as described in the paper "Linearly Converging Quasi Branch and
%  Bound Algorithms for Global Rigid Registration" by Nadav Dym and Shahar
%  Kovalsky.
%  Code is written by the authors. It is a modification of the code from the paper
%  "Go-ICP: A Globally Optimal Solution to 3D ICP Point-Set Registration"
%  comparison to goICP is possible by setting compare2goIcp=true
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%change to native path to run 
folder='/home/postdoc/nadavd/.sshfs/corwin/ytmp/cloud/nadavd/dropbox/Dropbox/globalICP/code_distribution/rigid_cp/';


addpath(genpath([folder '/matlab/']));

%choose random problem parameters
sigma=0.1;  %noise parameter
n=5; %number of points in Q (n<=m)
m=10; %number of points in P
seed=1;
doPlot=true;

compare2goIcp=false;

%% choose solver parameters

%these are quasiICP recommended settings
configParams=[];
configParams.MSEThresh=10^-6;
configParams.distTransSize=0; %this means kd trees are used for closest point computation

%for large problems consider using faster but less accurate distance transform using these parameter settings 
%configParams.MSEThresh=10^-3;
%configParams.distTransSize=300;

%if comparing to goicp choose moderate error threshold so goicp finishes in reasonable time
if compare2goIcp
    configParams.MSEThresh=10^-3;
end


[P,Q,t0,R0]=createRandomICPProblemPartial(sigma,n,seed,m);

outputQuasi=quasiICPmatlab2cpp(P,Q,'quasi',doPlot,folder,configParams);
generatedEnergyAvg=computeAvgClosestPntEnergy(P,Q,R0,t0);                    %energy obtained by the rotation and translation used to generate the problem
EnergyAvgQuasi=computeAvgClosestPntEnergy(P,Q,outputQuasi.R,outputQuasi.T);
if compare2goIcp
    outputGoICP=quasiICPmatlab2cpp(P,Q,'goICP',doPlot,folder,configParams);
    EnergyAvgGoICP=computeAvgClosestPntEnergy(P,Q,outputGoICP.R,outputGoICP.T);
end



