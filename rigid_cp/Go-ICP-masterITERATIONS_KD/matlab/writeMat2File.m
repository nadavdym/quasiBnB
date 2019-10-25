function writeMat2File(P,name)
%write matrix P to a text file named "name". 
%first line of the text file is the number of rows of P
fid = fopen(name,'wt');
n=size(P,1);
fprintf(fid,'%d\n',n)
for ii = 1:n
    fprintf(fid,'%g\t',P(ii,:));
    fprintf(fid,'\n');
end
fclose(fid)
end