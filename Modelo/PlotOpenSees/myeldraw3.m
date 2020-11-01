function myeldraw3(ex,ey,ez,plotpar,elnum,XYZsi)
%ELDRAW3: Draw the undeformed 3D mesh of elements of same type, e.g.
%         2-noded, 3-noded, 4-noded or 8-noded
%
%Inputs: ex      - Element node x-coordinate matrix. X-coordinates
%                  of nodes of I:th element is ex(I,:)
%        ey      - Similar to ex but y-coordinates
%        ez      - Similar to ex but z-coordinates
%        plotpar - Plot parameters. plotpar=[linestyle,color,nodesymbol]
%                  - linestyle = 1 dotted (default), 2 dashed, 3 solid
%                  - color = 1 white (or black) (default), 2 green, 3 yellow,
%                            4 red
%                  - nodesymbol = 1 dot (default), 2 star, 3 circle
%        elnum   - Vector of element numbers, i.e. the first column of the 
%                  topology matrix. If empty or left out, no numbers are drawn
%Output: None
%Call:   eldraw3(ex,ey,ez,plotpar,elnum)
%
%See also: ELDISP3, ELDRAW2 and ELDISP2

%Copyright: Thomas Abrahamsson, Solid Mechanics,
%           Chalmers University of Technology, Göteborg, Sweden
%Written: Jan 16, 1999

% --------------------------------------------------------------------------------
%                                                                         Initiate
%                                                                         --------
if nargin<3,error('Too few input arguments'),end
[nx,mx]=size(ex);[ny,my]=size(ey);[nz,mz]=size(ez);
nel=nx;nen=mx;
if (nx~=ny | nx~=nz),error('Row dimensions of ex, ey and ez do not match'),end
if (mx~=my | mx~=mz),error('Column dimensions of ex, ey and ez do not match'),end
if nargin>4,
   if length(elnum)~=nel,error('The elnum vector is too short or too long.'),end
end

if nargin==3,plotpar=[1 1 1];end,if isempty(plotpar),plotpar=[1 1 1];end

if plotpar(1)==1,linestyle=':';elseif plotpar(1)==2,linestyle='--';
elseif plotpar(1)==3,linestyle='-';else
   error('Sorry. This linestyle does not exist');
end

if plotpar(2)==1,color='k';elseif plotpar(2)==2,color='g';
elseif plotpar(2)==3,color='y';elseif plotpar(2)==4,color='r';else
   error('Sorry. This color does not exist');
end

if plotpar(3)==1,symbol='.';elseif plotpar(3)==2,symbol='*';
elseif plotpar(3)==3,symbol='o';else
   error('Sorry. This symbol does not exist');
end


x0=sum(ex')/nen; y0=sum(ey')/nen; z0=sum(ez')/nen;
    
if nen==2,%    Bar or Beam elements
   exx=ex;eyx=ey;ezx=ez;
elseif nen==4,% Plate elements
   exx=[ex ex(:,1)];eyx=[ey ey(:,1)];ezx=[ez ez(:,1)];
else
    str=['Sorry. Does not work for ' int2str(nen) '-noded elements'];
    error(str); 
end

xmin=min(min(ex));xmax=max(max(ex));dx=xmax-xmin;
ymin=min(min(ey));ymax=max(max(ey));dy=ymax-ymin;
zmin=min(min(ez));zmax=max(max(ez));dz=zmax-zmin;
D=max([dx dy dz])/10;
triadx=[0 D;0 0;0 0];triady=[0 0;0 D;0 0];triadz=[0 0;0 0;0 D];

% --------------------------------------------------------------------------------
%                                                                             Plot
%                                                                             ----

% hfig=figure;
% set(hfig,'Name','CALFEM mesh plot','Numbertitle','Off','Color','w');
hold on;
plot3(ex(1,1),ey(1,1),ez(1,1));axis off; 
for I=1:nel,
  hline=line(exx(I,:),eyx(I,:),ezx(I,:));
  set(hline,'color',color,'linestyle',linestyle,'Marker',symbol);
end
 
if nargin>4,
  for I=1:nel
    h=text(x0(I),y0(I),z0(I),int2str(elnum(I)));
  end
end

if nargin>5
for I=1:3 
  htriad=line(triadx(I,:),triady(I,:),triadz(I,:));
  set(htriad,'color','k','linestyle','-');
end
htext=text(triadx(1,2),triady(1,2),triadz(1,2),'X');
set(htext,'Color','k');
htext=text(triadx(2,2),triady(2,2),triadz(2,2),'Y');
set(htext,'Color','k');
htext=text(triadx(3,2),triady(3,2),triadz(3,2),'Z');
set(htext,'Color','k');
end
axis equal
rotate3d
