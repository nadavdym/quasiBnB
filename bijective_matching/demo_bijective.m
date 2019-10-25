%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  demo code for the quasi-BnB algorithm for the  bijective rigid alignment
%  problem as described in the paper "Linearly Converging Quasi Branch and
%  Bound Algorithms for Global Rigid Registration" by Nadav Dym and Shahar
%  Kovalsky. Code is written by the authors. 
%  It uses the linear assignment solver from the paper "Fast
%  correspondences for statistical shape models of
%  brain structures."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder=[pwd '/'];

addpath(genpath(folder));

%% set parameters
n=10;
sigma=0.05; %noise parameter
 

seed=1;
rng(seed);


%% generate random problem
%generate random rotation
[U,~,V]=svd(randn(3));
R0=U*V';

%generate random noise
N=randn(3,n);

%generate random point clouds
P1=randn(3,n);
P2=R0*P1+sigma*N;


%%centralize and scale
m1=mean(P1')';
m2=mean(P2')';
P1=P1-m1;
P2=P2-m2;
P1=P1/norm(P1,'fro');
P2=P2/norm(P2,'fro');

%% solve
SO=true; %solve over SO(d) if true, over O(d) if false
doPlot=true;  %plot some info on number of itereations etc.
[Ropt,map,obj,generationSizeVec,timeData]=quasiBnB(P1,P2,SO,doPlot);

%% visualize results
% compare energy with the energy obtained from R0 used to generate the
% point clouds
D=pdist2((R0*P1)',P2');
cost=D.^2;
[obj0,tempMap]=bernardAuction(cost,10^-6);


markerSize=100;
%visualize rotations
figure; 
subplot(1,2,1);
hold on
imagesc(R0); colorbar;
title(sprintf('randomly generated rotation energy=%0.5f',obj0));
subplot(1,2,2);
hold on
imagesc(Ropt); colorbar;
title(sprintf('computed rotation energy=%0.5f',obj));

%visualize input and output point clouds
figure;
subplot(1,2,1);
hold on
scatter3(P1(1,:),P1(2,:),P1(3,:),markerSize,'b','o');
scatter3(P2(1,:),P2(2,:),P2(3,:),markerSize,'r','x');
title('input');
subplot(1,2,2);
hold on 
Protated=Ropt*P1;
scatter3(Protated(1,:),Protated(2,:),Protated(3,:),markerSize,'b','o');
scatter3(P2(1,:),P2(2,:),P2(3,:),markerSize,'r','x');
title('output');



