% This is the main function that produces the magnitude, temperature, and
% thermal dose maps


%Difference between v1 and v2
%Arguement order: Was cmd, cmd2, zip, out, rigid. Now: cmd, cmd2, zip,
%rigid, out
%Outfile is now optional
%Reason: allows for the file tree structure to be easily maintained
%Removed problem line on 144 that was throwing errors


function extractNiftiZipInput2(cmd,cmd2,zipfile,RigidTransformFile,outFile)

 %First bit is for testing and using any default bits
 %Add unit testing
 
 %Default arguements 
if nargin==0
    cmd = 'all';
    zipfile='ET 9002 - June 15 2017.zip';
    outFile = '/Users/spichardo/Downloads/ET 9002 Thermal Data';
    RigidTransformFile='9002-RXYZ-PreTreat-To-IntraOp.RAS';
end

%addpath([pwd,filesep,'dicm2nii']);
addpath(fullfile(pwd,'dicm2nii'))



if ~ischar(cmd)
    error('Provide a string command as the first input for nii_tool');
end
            
%allows for people putting in capitals
cmd= lower(cmd);
cmd= strtrim(cmd);

cmd1=lower(cmd2);
cmd2=strtrim(cmd1);


path=RigidTransformFile(numel(RigidTransformFile)-32:numel(RigidTransformFile));
path=path(1:4);

if ~exist('outFile','var')
     % third parameter does not exist, so default is set
     outFile = fullfile(pwd,'Patient_Files',path);
end

%if exist(fullfile(pwd,'Patient_Files'))==0
%    mkdir Patient_Files;
%    mkdir(fullfile(pwd,'Patient_Files',path));
%elseif exist(fullfile(pwd,'Patient_Files',path))==0
%    mkdir(fullfile(pwd,'Patient_Files',path));
%end


%If user wants temperature maps, input command: 'tempMap', If user wants
%magnitudes use command: 'magMap'. If user wants both use: 'all'
if ( strcmp('tempMap',cmd) == 0 ) && (strcmp('magMap',cmd)==0) && (strcmp('all',cmd)==0)
    string = strcat(cmd, ' is not a valid opetion, select from the provided options: thermal, magnitude, or all');
    error(string);
end

%If user wants thermal dose maps, input command: 'thermalDose', If user wants
%only temperature maps, use command: 'tempmap'. If user wants both use: 'all'
if ( strcmp('thermalDose',cmd2) == 0 ) && (strcmp('tempMap',cmd2)==0) && (strcmp('all',cmd2)==0)
    string = strcat(cmd2, ' is not a valid opetion, select from the provided options: thermal, magnitude, or all');
    error(string);
end

%If the output file does not exist, then create it.
if exist(outFile,'dir')==0
    mkdir(outFile)
end

%Temporary directory for zip file contents.
tdir = tempname;
mkdir(tdir);

IntraOpMat =load(RigidTransformFile, '-ascii');

%The function proper
try
    unzip(zipfile,tdir);
    file=tdir;
    [Images,Number,File,SonSummary,XML] = GetSonicationData(file);  %returns the image matrices as 4D matrix first column is echo 1, second column is echo 2, final two colums are the x and y of the image
    SqueezedFiles=SqueezeFiles(Images,Number);                      %Separates the echoes into 2 image matrices
    Orientation = blanks(Number);                                   %block char matrix to hold orientations
    Orientation = GetOrientation(SonSummary,Orientation);           %Determines the orientation of the different image files
    ProcessedFiles=ProcessImages(Orientation,SqueezedFiles,Number); %Rotates and flips the images as needed for the image orientation

    for i=1:Number

        Coords=xml2coords(XML,Number,i,SqueezedFiles(i).ThermalCount);
        [RawNiftiMag1,RawNiftiMag2,RawNiftiTherm1,RawNiftiTherm2]=MakeRawNifties(ProcessedFiles(i));
        
        if strcmp(cmd,'magMap') || strcmp(cmd,'all')
            [NiftiMag1_IntraOp,NiftiMag1_PreOp]=CommonNifti(RawNiftiMag1,Coords,SqueezedFiles(i).MagnitudeCount,ProcessedFiles(i).Orientation,'magnitude',IntraOpMat);
            [NiftiMag2_IntraOp,NiftiMag2_PreOp]=CommonNifti(RawNiftiMag2,Coords,SqueezedFiles(i).MagnitudeCount,ProcessedFiles(i).Orientation,'magnitude',IntraOpMat);
        end
        
        if strcmp(cmd,'tempMap') || strcmp(cmd,'all')
            [NiftiTherm1_IntraOp,NiftiTherm1_PreOp]=CommonNifti(RawNiftiTherm1,Coords,SqueezedFiles(i).ThermalCount,ProcessedFiles(i).Orientation,'thermal',IntraOpMat);
            [NiftiTherm2_IntraOp,NiftiTherm2_PreOp]=CommonNifti(RawNiftiTherm2,Coords,SqueezedFiles(i).ThermalCount,ProcessedFiles(i).Orientation,'thermal',IntraOpMat);
        end
        
        if strcmp(cmd2,'thermalDose') || strcmp(cmd2,'all')
            NiftiThermDose1_IntraOp =NiftiTherm1_IntraOp;
            NiftiThermDose2_IntraOp = NiftiTherm2_IntraOp;
            NiftiThermDose1_PreOp =NiftiTherm1_PreOp;
            NiftiThermDose2_PreOp = NiftiTherm2_PreOp;
            
            NiftiThermDose1_IntraOp.img = arrayfun(@(x) calcThermalDose(x),NiftiThermDose1_IntraOp.img);
            NiftiThermDose2_IntraOp.img = arrayfun(@(x) calcThermalDose(x),NiftiThermDose2_IntraOp.img);
            NiftiThermDose1_PreOp.img = arrayfun(@(x) calcThermalDose(x),NiftiThermDose1_PreOp.img);
            NiftiThermDose2_PreOp.img = arrayfun(@(x) calcThermalDose(x),NiftiThermDose2_PreOp.img);
        end

        if strcmp(cmd,'magMap') || strcmp(cmd,'all')
            SaveNifties('IntraOp-Magnitude',i,NiftiMag1_IntraOp,NiftiMag2_IntraOp,outFile);
            SaveNifties('PreOp-Magnitude',i,NiftiMag1_PreOp,NiftiMag2_PreOp,outFile);
        end
        
        if ( strcmp(cmd,'tempMap') || strcmp(cmd,'all') ) && ( strcmp(cmd2,'tempMap') || strcmp(cmd2,'all') )
            SaveNifties('IntraOp-Thermal',i,NiftiTherm1_IntraOp,NiftiTherm2_IntraOp,outFile);
            SaveNifties('PreOp-Thermal',i,NiftiTherm1_PreOp,NiftiTherm2_PreOp,outFile);
        end
        
        if ( strcmp(cmd,'tempMap') || strcmp(cmd,'all') ) && ( strcmp(cmd2,'thermalDose') || strcmp(cmd2,'all') )
            SaveNifties('IntraOp-CEM240-',i,NiftiThermDose1_IntraOp,NiftiThermDose2_IntraOp,outFile);
            SaveNifties('PreOp-CEM240-',i,NiftiThermDose1_PreOp,NiftiThermDose2_PreOp,outFile);
        end
        

    end %for loop
    %
    disp('All Done')
catch ME
    rmdir(tdir,'s');
    rethrow(ME);
end

path1=fullfile(pwd,'Patient_Files',path);
%movefile(fullfile(pwd,'Patient_Files/*.nii.gz',(path1))
%movefile('PreOp*.nii.gz',(path1))
rmdir(tdir,'s');

 end

% This subfunction takes the binary files and converts it into images
function [MatrixFiles,Number,PatientFile,chars,xml] = GetSonicationData(file)
close all;
PatientFile=file;

OddFile = 'ET 9009 - Dec 19 2017 ';

Number = NumOfSonications(file);
ImageMatrices=struct;

for i=1:Number

    [C,D,E,F,G]=ProcessImageFiles([file filesep sprintf('Sonication%i',i)], i);
    ImageMatrices(i).RawMagnitude=C;
    ImageMatrices(i).RawThermal=D;
    ImageMatrices(i).XRange=E;
    ImageMatrices(i).YRange=F;

    MatrixFiles=ImageMatrices;

end

[chars,xml]=ReadXML(PatientFile);

disp('Retrieved all image files');

end %GetSonicationImage

% This subfunction determines how many sonicaitons that were performed
function [Number] = NumOfSonications(file)

Files = dir([file filesep 'Sonication*']);
Number = numel(Files);
for i=1:Number
    if Files(i).isdir == 0
        Files(i)=[];
        i = i-1;
    end %if
end %for

Number = numel(Files);

end %NumOfSonications

% This function produces the image matrices for the magnitude and
% temperature maps
function [MagMaps, TherMaps, Xv, Yv, ROI] = ProcessImageFiles(SonicationPath,Sonic)

NTherImag=0; %Number of thermal images
NMagImag=0; %Number of magnitude Images

MagRawFiles=dir([SonicationPath filesep '6-*.raw']);
NMagImag=numel(MagRawFiles);
%MagRawFiles=SortStruct(UnsortedMagRawFiles);

ThermalRawFiles=dir([SonicationPath filesep '5-*.raw']);
NTherImag=numel(ThermalRawFiles);
%ThermalRawFiles=SortStruct(UnsortedThermalRawFiles);

Nx=128; %X Dimension size of image
Ny=256; %Y Dimension size of image

TMaps=zeros(NTherImag,2,Ny,Nx); %Vector containing the data for thermal maps
MagMap=zeros(NMagImag,2,Ny,Nx,'uint16'); %Vector containing the data for magnitude maps
FOV=[280,280]; %Field of View, where the area of the brain was burned?
Dx=FOV(1)/Nx; %Yes
Dy=FOV(2)/Ny; %Yes

Xv=[0:Nx-1]*Dx;
Yv=[0:Ny-1]*Dy;

CxCy=FOV/2;
RadiusROI=5;
[xx,yy]=meshgrid(Xv,Yv);
ROI=(xx-CxCy(1)).^2+(yy-CxCy(2)).^2<=RadiusROI^2;

%Starting the processing
NumberSonication = Sonic;
for n = 0:NMagImag-1
    Mfile = [SonicationPath filesep sprintf('6-%i-0-%i.raw',NumberSonication,n)];
    f=fopen(Mfile,'rb');
    Mmap=fread(f,Nx*Ny*2,'uint16');
    fclose(f);
    Mmap=reshape(Mmap,[2,Nx,Ny]);
    MagMap(n+1,:,:,:)=permute(Mmap,[1,3,2]);

    if n<NMagImag-1
        Tfile = [SonicationPath filesep sprintf('5-%i-3-%i.raw',NumberSonication,n)];
        g=fopen(Tfile,'rb');
        Tmap=fread(g,2*Nx*Ny+1,'float');
        Tmap=reshape(Tmap,[2,Nx,Ny]);
        fclose(f);
        TMaps(n+1,:,:,:)=permute(Tmap,[1,3,2]);
    end %if block
end %for loop
MagMaps = MagMap;
TherMaps = TMaps;
end %PIF


% This function gets the XML data
function [chars,xml] = ReadXML(File)

chars=xml2struct([File, filesep, 'SonicationSummary.xml']);
xml=xml2struct([File, filesep,'MriImageParams.xml']);

end %function

% This function separates map 1 and map 2
 function [SqueezedFiles]=SqueezeFiles(Images,Number)

SqueezedFiles = struct;

    for i=1:Number

        Rm=size(Images(i).RawMagnitude);
        Rt=size(Images(i).RawThermal);
        Rm=Rm(1);
        Rt=Rt(1);
        SqueezedFiles(i).MagnitudeCount=Rm;
        SqueezedFiles(i).ThermalCount=Rt;
        Thermal=Images(i).RawThermal;
        Magnitude=Images(i).RawMagnitude;

        %4D
        SqueezedFiles(i).Mag1=zeros(256,128,1,Rm);
        SqueezedFiles(i).Mag2=zeros(256,128,1,Rm);
        SqueezedFiles(i).Therm1=zeros(256,128,1,Rt);
        SqueezedFiles(i).Therm2=zeros(256,128,1,Rt);

        for j=1:Rm;
            SqueezedFiles(i).Mag1(:,:,1,j)=squeeze(Magnitude(j,1,:,:));
            SqueezedFiles(i).Mag2(:,:,1,j)=squeeze(Magnitude(j,2,:,:));
        end %Rm loop
        for j=1:Rt
            SqueezedFiles(i).Therm1(:,:,1,j)=squeeze(Thermal(j,1,:,:));
            SqueezedFiles(i).Therm2(:,:,1,j)=squeeze(Thermal(j,2,:,:));
        end%Rt loop
    end%inner for loop
end %function

% This function determines the orientation of each sonication
function [OrientatedFiles]=GetOrientation(Chars,Orientation)
StrSon='sonicationindex';
SonIndex=0;
StrOrient='scanplane';
OrientIndex=0;

%if strcmp(Chars.Name,'rs:data') == 0 %Patient isn't 9005

if strcmp(Chars.name,'rs:data') == 0 %Patient isn't 9005

    X = numel(Chars.children(4).children);
    Y = numel(Chars.children(4).children(2).attributes);


    for i=1:Y
        if strcmp(StrOrient,Chars.children(4).children(2).attributes(i).name)
            OrientIndex=i;
        end
    end %for loop

    n=1;

    for i=1:numel(Orientation)

        if strcmp(Chars.children(4).children(2*i).attributes(OrientIndex).value,'OAx')
            Orientation(i) = 'a';
        elseif strcmp(Chars.children(4).children(2*i).attributes(OrientIndex).value,'OSag')
            Orientation(i) = 's';
        elseif strcmp(Chars.children(4).children(2*i).attributes(OrientIndex).value,'OCor')
            Orientation(i) = 'c';
        else
            Orientation(i) = 'NaN';
            disp('Was looking for an A, S, or C. Found: ', Chars(Target_Pos(Sonication)+N));
        end%if block

    end%for loop

    OrientatedFiles=Orientation;

else
    X = numel(Chars.children);
    Y = numel(Chars.children(2).attributes);

    for i=1:Y
        if strcmp(StrOrient,Chars.children(2).attributes(i).name)
            OrientIndex=i;
        end
    end %for loop

    n=1;

    for i=1:numel(Orientation)

    if strcmp(Chars.children(2*i).attributes(OrientIndex).value,'OAx')
        Orientation(i) = 'a';
    elseif strcmp(Chars.children(2*i).attributes(OrientIndex).value,'OSag')
        Orientation(i) = 's';
    elseif strcmp(Chars.children(2*i).attributes(OrientIndex).value,'OCor')
        Orientation(i) = 'c';
    else
        Orientation(i) = 'NaN';
        disp('Was looking for an A, S, or C. Found: ', Chars(Target_Pos(Sonication)+N));
    end%if block

    end%for loop

    OrientatedFiles=Orientation;
end %if block

end%function

% This function rotates, permutes, and flips images
function [ProcessedImages] = ProcessImages(Orientation,SqueezedFiles,Number)

ProcessedImages=struct;
for i=1:Number
    if strcmp(Orientation(i),'a') || strcmp(Orientation(i),'c')
        TempMag1=imrotate(SqueezedFiles(i).Mag1,-90,'bilinear');
        ProcessedImages(i).Mag1=flip(TempMag1);
        TempMag2=imrotate(SqueezedFiles(i).Mag2,-90,'bilinear');
        ProcessedImages(i).Mag2=flip(TempMag2);
        TempTherm1=imrotate(SqueezedFiles(i).Therm1,-90,'bilinear');
        ProcessedImages(i).Therm1=flip(TempTherm1);
        TempTherm2=imrotate(SqueezedFiles(i).Therm2,-90,'bilinear');
        ProcessedImages(i).Therm2=flip(TempTherm2);
    elseif strcmp(Orientation(i),'s')
        ProcessedImages(i).Mag1=imrotate(SqueezedFiles(i).Mag1,270,'bilinear');
        %ProcessedImages(i).Mag1=flip(ProcessedImages(i).Mag1);
        ProcessedImages(i).Mag2=imrotate(SqueezedFiles(i).Mag1,270,'bilinear');
        %ProcessedImages(i).Mag2=flip(ProcessedImages(i).Mag2);
        ProcessedImages(i).Therm1=imrotate(SqueezedFiles(i).Therm1,270,'bilinear');
        %ProcessedImages(i).Therm1=flip(ProcessedImages(i).Therm1);
        ProcessedImages(i).Therm2=imrotate(SqueezedFiles(i).Therm2,270,'bilinear');
        %ProcessedImages(i).Therm2=flip(ProcessedImages(i).Therm2);
    end %if block
    ProcessedImages(i).Orientation = Orientation(i);
end %for loop

%disp('Files fully processed Files made into raw nifties');
end %function

% This function turns the images into nifti files
function [RawNiftiMag1,RawNiftiMag2,RawNiftiTherm1,RawNiftiTherm2] = MakeRawNifties(ImageFiles)

RawNiftiMag1=nii_tool('init',ImageFiles.Mag1);
RawNiftiMag2=nii_tool('init',ImageFiles.Mag2);
RawNiftiTherm1=nii_tool('init',ImageFiles.Therm1);
RawNiftiTherm2=nii_tool('init',ImageFiles.Therm2);
%disp('Files made into raw nifties');

end

% This function gets the corner co-ordinates for the nifti files
function [CornerCoords] = xml2coords(xml,Number,SonValue,Count)

% Coords=xml2coords(XML,Number,i,SqueezedFiles(i).ThermalCount);

X = numel(xml.children(4).children);
Y = numel(xml.children(4).children(42).attributes);

B=zeros(1,Count);
StrSon='sonicationindex';
SonNum=0;
StrIndex='fieldindex';
IndexNum=0;
StrLeftCoordA='acttopleftcoorda';
LCANum=0;
StrLeftCoordR='acttopleftcoordr';
LCRNum=0;
StrLeftCoordS='acttopleftcoords';
LCSNum=0;
IndValue=5;

CornerCoords=zeros(1,3);

for i = 1:Y %Scan through the attributes to find which numbers, All Grandchildren have same fields, must be even~
   if strcmp(xml.children(4).children(42).attributes(i).name,StrSon)
       SonNum=i;
   end %if block
   if strcmp(xml.children(4).children(42).attributes(i).name,StrIndex)
       IndexNum=i;
   end %if block
   if strcmp(xml.children(4).children(42).attributes(i).name,StrLeftCoordA)
       LCANum=i;
   end %if block
   if strcmp(xml.children(4).children(42).attributes(i).name,StrLeftCoordR)
       LCRNum=i;
   end %if block
   if strcmp(xml.children(4).children(42).attributes(i).name,StrLeftCoordS)
       LCSNum=i;
   end %if block
end % for loop

n=1;

for i = 2:2:X %Scan through the structure for which index has the sonication and the correct index
    if str2double(xml.children(4).children(i).attributes(SonNum).value) == SonValue && str2double(xml.children(4).children(i).attributes(IndexNum).value) == IndValue
        B(1,n)=i;
        n=n+1;
    end %if block
end %for loop

Coords=zeros(3,Count);

for i=1:Count %Get the coordinates
%     disp('i=',double2str(i))
    Coords(1,i)=str2double(xml.children(4).children(B(i)).attributes(LCRNum).value);
    Coords(2,i)=str2double(xml.children(4).children(B(i)).attributes(LCANum).value);
    Coords(3,i)=str2double(xml.children(4).children(B(i)).attributes(LCSNum).value);
end %for loop

if range(Coords(1,:)) == 0
    CornerCoords(1)=Coords(1,1);
end

if range(Coords(2,:)) == 0
    CornerCoords(2)=Coords(2,1);
end

if range(Coords(3,:)) == 0
    CornerCoords(3)=Coords(3,1);
end

end %GetCornerCoords

% This function sets the nifti header files
function [IntraOp,PreOp] = CommonNifti(Start,Dims,Count,Orientation,ImageType,TMat)
pdim=1.0938;

if strcmpi(ImageType,'magnitude')
    
    Start.hdr.xyzt_units=2;
    Start.hdr.datatype=512;
    Start.hdr.bitpix=16;
else
    Start.hdr.xyzt_units=2;
    Start.hdr.datatype=64;
    Start.hdr.bitpix=64;
end

Start.hdr.scl_slope=1;
Start.hdr.glmax=2135;
Start.hdr.glmin=0;
Start.hdr.qform_code=0;
Start.hdr.sform_code=1;

if strcmp(Orientation,'a')
    Start.img=flip(Start.img);
    Start.hdr.dim=[4,128,256,1,Count,1,1,1];
    Start.hdr.pixdim=[1,2*pdim,pdim,3,1,1,47310];
    Start.hdr.qoffset_x=Dims(1)-pdim;
    Start.hdr.qoffset_y=Dims(2)-(Start.hdr.dim(3)-pdim*1.0)*Start.hdr.pixdim(3);
    Start.hdr.qoffset_z=Dims(3);
    Start.hdr.srow_x=[-Start.hdr.pixdim(2),0,0,Start.hdr.qoffset_x];
    Start.hdr.srow_y=[0,Start.hdr.pixdim(3),0,Start.hdr.qoffset_y];
    Start.hdr.srow_z=[0,0,Start.hdr.pixdim(4),Start.hdr.qoffset_z];
    Start.hdr.quatern_b=0;
    Start.hdr.quatern_c=1;
    Start.hdr.quatern_d=0;

elseif strcmp(Orientation,'s')
    Start.img=permute(Start.img,[3,1,2,4]);
    Start.hdr.dim=[4,1,128,256,Count,1,1,1];
    Start.hdr.pixdim=[1,3,2*pdim,pdim,1,1,47310];
    Start.hdr.qoffset_x=Dims(1);
    Start.hdr.qoffset_y=Dims(2)-pdim;
    Start.hdr.qoffset_z= Dims(3)-((Start.hdr.dim(4)-1)*pdim);
    Start.hdr.srow_x=[Start.hdr.pixdim(2),0,0,Start.hdr.qoffset_x];
    Start.hdr.srow_y=[0,-Start.hdr.pixdim(3),0,Start.hdr.qoffset_y];
    Start.hdr.srow_z=[0,0,Start.hdr.pixdim(4),Start.hdr.qoffset_z];
    Start.hdr.quatern_b=0.5;
    Start.hdr.quatern_c=-0.5;
    Start.hdr.quatern_d=-0.5;

elseif strcmp(Orientation,'c')
    Start.img=flip(Start.img);
    Start.img=permute(Start.img,[1,3,2,4]);
    Start.hdr.dim=[4,128,1,256,Count,1,1,1];
    Start.hdr.pixdim=[1,2*pdim,3,pdim,1,1,47310];
    Start.hdr.qoffset_x=+Dims(1)-pdim/2;
    Start.hdr.qoffset_y=Dims(2);
    Start.hdr.qoffset_z=Dims(3)-(Start.hdr.dim(4)-pdim*0.5)*Start.hdr.pixdim(4);
    Start.hdr.srow_x=[-Start.hdr.pixdim(2),0,0,Start.hdr.qoffset_x];
    Start.hdr.srow_y=[0,Start.hdr.pixdim(3),0,Start.hdr.qoffset_y];
    Start.hdr.srow_z=[0,0,Start.hdr.pixdim(4),Start.hdr.qoffset_z];
    Start.hdr.quatern_b=0.7071;
    Start.hdr.quatern_c=0;
    Start.hdr.quatern_d=0;
end

IntraOp=Start;

q_a=sqrt(1-(Start.hdr.quatern_b^2+Start.hdr.quatern_c^2+Start.hdr.quatern_d^2));
assert(q_a>=0);
a=q_a;
b= Start.hdr.quatern_b;
c= Start.hdr.quatern_c;
d= Start.hdr.quatern_d;
A= [a*a+b*b-c*c-d*d, 2*b*c-2*a*d ,2*b*d+2*a*c,Start.hdr.qoffset_x;...
    2*b*c+2*a*d ,a*a+c*c-b*b-d*d, 2*c*d-2*a*b, Start.hdr.qoffset_y;... ?
    2*b*d-2*a*c, 2*c*d+2*a*b, a*a+d*d-c*c-b*b, Start.hdr.qoffset_z;...
0,0,0,1];


A=TMat*A;
a=0.5*sqrt(1+A(1,1)+A(2,2)+A(3,3));
b=0.25 *(A(3,2)- A(2,3))/a;
c=0.25 *(A(1,3)- A(3,1))/a;
d=0.25 *(A(2,1)- A(1,2))/a;

Start.hdr.quatern_b=b;
Start.hdr.quatern_c=c;
Start.hdr.quatern_d=d;
Start.hdr.qoffset_x=A(1,4);
Start.hdr.qoffset_y=A(2,4);
Start.hdr.qoffset_z=A(3,4);
    
A=[Start.hdr.srow_x;Start.hdr.srow_y;Start.hdr.srow_z;0,0,0,1];
A=TMat*A;

Start.hdr.srow_x=A(1,:);
Start.hdr.srow_y=A(2,:);
Start.hdr.srow_z=A(3,:);

PreOp=Start;


end

% This function turns the temperature maps and makes thermal dose images
function[Final] = calcThermalDose(Initial)

TimeDose = 3.686;
Final = Initial;

if Initial < 0
    Initial = 0;
elseif Initial < 0
    Initial = 0;
end

if Initial > 43
    Final = TimeDose * 0.5^(43-Initial);
elseif Initial <= 43
    Final = TimeDose * 0.25^(43-Initial);
end

if Final < 0
    Final = 0;
elseif Final >= 240
    Final = 240;
end


end

% This function saves the images, as needed.
function SaveNifties(infix,Sonication,NiftiImage1,NiftiImage2,outFile)

%Want to save all the data in a folder for the patient in the Patient_Files
%subfolder



string_niftiname1 = strcat(outFile, filesep,infix,'1-Sonication_',num2str(Sonication),'.nii.gz');
string_niftiname2 = strcat(outFile, filesep,infix,'2-Sonication_',num2str(Sonication),'.nii.gz');

if exist(string_niftiname1,'file')
    delete (string_niftiname1);
end
if exist(string_niftiname2,'file')
    delete (string_niftiname2);
end

nii_tool('save',NiftiImage1,string_niftiname1);
nii_tool('save',NiftiImage2,string_niftiname2);

end
