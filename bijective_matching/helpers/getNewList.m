function newList=getNewList(prevList,D)
%given a list of cubes, by subdividing each one of the cubes
prevListSize=length(prevList);
newList=cell(2^D*prevListSize,1);
listInd=0;
switch D
    case 1
        B=[1;-1];
    case 3
        B=[1 1 1;1 1 -1; 1 -1 1; -1 1 1; -1 -1 1; -1 1 -1; 1 -1 -1; -1 -1 -1];
end
for ii=1:prevListSize
    cube=prevList{ii};
    h=cube.h/2;
    x0=cube.x;
    
    for jj=1:2^D
        listInd=listInd+1;
        new_cube.h=h;
        new_cube.orientation=cube.orientation;
        new_cube.x=x0+h*B(jj,:)';
        newList{listInd}=new_cube;
    end
end



end



