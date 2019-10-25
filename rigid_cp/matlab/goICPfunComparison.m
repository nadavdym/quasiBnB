function output=goICPfunComparison(P,Q,owner,doPlot,textPath,configParams)
%given two point clouds P,Q run the cpp code of go-icp- either ours or original- and return the
%output of the

switch owner
    case 'combined'
        codeFolder='/ytmp/cloud/nadavd/dropbox/Dropbox/globalICP/code/Go-ICP-masterCOMBINED';
    case 'original'
        codeFolder='/ytmp/cloud/nadavd/dropbox/Dropbox/globalICP/code_distribution/rigid_cp/Go-ICP-masterITERATIONS_KD';
    case 'ours'
        codeFolder='/ytmp/cloud/nadavd/dropbox/Dropbox/globalICP/code_distribution/rigid_cp/Go-ICP-master';
end
t=datetime('now');
jobIdx=0;%getoptions(configParams,'jobIdx',0);
jobIdxStr=sprintf('jobIdx=%d',jobIdx);
directory=[datestr(t,'HH:MM:SS') '_' jobIdxStr];
if nargin<5 || isempty(textPath)
    textPath='/ytmp/cloud/nadavd/dropbox/Dropbox/globalICP/code_distribution/rigid_cp/Go-ICP-master/matlab/';
    mkdir(textPath,directory);
    textPath=[textPath directory '/'];
end
cd(textPath);
if nargin<4
    doPlot=true;
end
%normalize to unit cube (a requirement of go-icp)
MP=max(abs(P(:)));
MQ=max(abs(Q(:)));
M=max(MP,MQ);
if M>1
    P=P/M;
    Q=Q/M;
end

%create text files from P and Q

t=datetime('now');
tString=datestr(t,'HH:MM:SS');
configString=sprintf('thresh=%f_',configParams.MSEThresh);

nameP=['sourceCloud' tString '.txt'];
nameQ=['targetCloud' tString '.txt'];
nameOutput=[owner '_output'  tString '.txt'];
nameConfig=['config'  tString configString '.txt'];
configParams.name=nameConfig;
configParams.path=textPath;
writeConfig2File(configParams);

fid = fopen(nameOutput,'wt');
fclose(fid);


writeMat2File(P',nameP);
writeMat2File(Q',nameQ);


fullNameP=[textPath  nameP];
fullNameQ=[textPath  nameQ];
fullNameConfig=[textPath  nameConfig];
fullNameOutput=[textPath nameOutput];

nQ=size(Q,2);
numString=sprintf('%d',nQ);

%run algorithm
cd(codeFolder);
cmd = './GoICP';
cmd = [cmd ' ' fullNameP ' ' fullNameQ ' ' numString ' ' fullNameConfig ' ' fullNameOutput];
system(cmd);

%read and save results
file = fopen(fullNameOutput, 'r');
t = fscanf(file, '%f', 1);

R = fscanf(file, '%f', [3,3])';
T = fscanf(file, '%f', [3,1]);
counts = fscanf(file, '%d', [1,3]);
fclose(file);

output.t=t;
output.R=R;
output.T=M*T; %rescale the translation
output.counts = counts;

%plot results
if doPlot
    model=P;
    data=Q;
    figure;
    subplot(1,2,1);
    plot3(model(1,:), model(2,:), model(3,:), '.r');
    hold on;
    plot3(data(1,:),  data(2,:),  data(3,:), '.b');
    hold off; axis equal; title('Initial Pose');
    subplot(1,2,2);
    data_ = bsxfun(@plus, R*data, T);
    plot3(model(1,:), model(2,:), model(3,:), '.r');
    hold on;
    plot3(data_(1,:), data_(2,:), data_(3,:), '.b');
    hold off; axis equal;  title('Result');
end

cd(textPath);
delete(fullNameP);
delete(fullNameQ);
delete(fullNameConfig);
delete(fullNameOutput);
rmdir(textPath);
end