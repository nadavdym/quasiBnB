function writeConfig2File(params)
%create config file
if nargin==0 
    params=[];
end
%path='/ytmp/cloud/nadavd/dropbox/Dropbox/globalICP/code_distribution/rigid_cp/Go-ICP-master/matlab/';
path=params.path;
name=params.name;%'config.txt';
%path=getoptions(params,'path','/ytmp/cloud/nadavd/dropbox/Dropbox/globalICP/code/Go-ICP-master/matlab/');
%name=getoptions(params,'name','config.txt');
name=[path name];
fid = fopen(name,'wt');

%%set parameters for GO-ICP: description and defaut values from original text file

% Mean Squared Error (MSE) convergence threshold (MSEThresh=0.001)
MSEThresh=getoptions(params,'MSEThresh',0.001);

% Smallest rotation value along dimension X of rotation cube (radians)
rotMinX=-3.1416;
% Smallest rotation value along dimension Y of rotation cube (radians)
rotMinY=-3.1416;
% Smallest rotation value along dimension Z of rotation cube (radians)
rotMinZ=-3.1416;
% Side length of each dimension of rotation cube (radians)
rotWidth=6.2832;

% Smallest translation value along dimension X of translation cube
transMinX=getoptions(params,'transMinX',-1);
% Smallest translation value along dimension Y of translation cube
transMinY=getoptions(params,'transMinY',-1);
% Smallest translation value along dimension Z of translation cube
transMinZ=getoptions(params,'transMinZ',-1);
% Side length of each dimension of translation cube
transWidth=getoptions(params,'transWidth',2);

% Set to 0.0 for no trimming
trimFraction=0.0;

% Nodes per dimension of distance transform
distTransSize=getoptions(params,'distTransSize',300);
% DistanceTransformWidth = ExpandFactor x WidthLargestDimension
distTransExpandFactor=2.0;

%% write values to file

fprintf(fid,'MSEThresh=%g\t\n',MSEThresh);
fprintf(fid,'rotMinX=%g\t\n',rotMinX);
fprintf(fid,'rotMinY=%g\t\n',rotMinY);
fprintf(fid,'rotMinZ=%g\t\n',rotMinZ);
fprintf(fid,'rotWidth=%g\t\n',rotWidth);
fprintf(fid,'transMinX=%g\t\n',transMinX);
fprintf(fid,'transMinY=%g\t\n',transMinY);
fprintf(fid,'transMinZ=%g\t\n',transMinZ);
fprintf(fid,'transWidth=%g\t\n',transWidth);
fprintf(fid,'trimFraction=%g\t\n',trimFraction);
fprintf(fid,'distTransSize=%g\t\n',distTransSize);
fprintf(fid,'distTransExpandFactor=%g\t\n',distTransExpandFactor);

fclose(fid);


end

