function output=goICPfun(P,Q)
%given two point clouds P,Q run the cpp code of go-icp and return the
%output of their algorithm

cd /ytmp/cloud/nadavd/dropbox/Dropbox/globalICP/code/Go-ICP-master/matlab

doPlot=true;
%normalize to unit cube (a requirement of go-icp)
MP=max(abs(P(:)));
MQ=max(abs(Q(:)));
M=max(MP,MQ);
P=P/M;
Q=Q/M;
%create text files from P and Q
nameP='sourceCloud.txt';
nameQ='targetCloud.txt';
nameOutput='output.txt';
nameConfig='config.txt';



fid = fopen(nameOutput,'wt');
fclose(fid);


writeMat2File(P',nameP);
writeMat2File(Q',nameQ);

textPath=[pwd '/'];
fullNameP=[textPath  nameP];
fullNameQ=[textPath  nameQ];
fullNameConfig=[textPath  nameConfig];
fullNameOutput=[textPath nameOutput];

nQ=size(Q,2);
numString=sprintf('%d',nQ);

%run algorithm
cd '/ytmp/cloud/nadavd/dropbox/Dropbox/globalICP/code/Go-ICP-master';
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
end