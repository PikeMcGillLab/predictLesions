Making predicted lesion masks

Before you begin, make sure:
-	You are signed into Pikelab on AcademicFS
	o	This can be accessed by requesting permission from Andre Robichaud: andre.robichaud@ucalgary.ca
	o	See lab wiki:
		~	https://sites.google.com/site/qmrilab/tutorials/new-lab-members
	o	Used to access the needed files. You do not need to copy to directory. The available files are listed further in this document under the Available Files section
		~	Refer to available files section to see what files exist and where they are stored
		~	Patient zip files
		~	Post-Operative to Pre-Operative Transformation matrices ~
		~	Pre-Operative to Intra-Operative Transformation matrices
		~	Intra-Operative to Pre-Operagive Transformation matrices
		~	Fiesta Images
		~	T1 nifti files and 
		~	T1 lesion masks
-	You are using a Mac (tested on OS 10.12.6 and OS 10.13.6)
-	You have installed MATLAB (tested on 2018a and 2017b)
-	Have xml2struct tool for MATLAB
	o	https://github.com/kndiaye/matlab/blob/master/xml2struct.m
	o	Use to get xml2struct command
-	You have FSL installed
	o	FSL 5.0.11 or 5.0.10
	o	FLIRT v6.0
-	Assumes that all scripts/functions are in same folder. 



Functions:
-	extractNiftiZipInput2(cmd, zipfile, RigidTransformFile, outFile)
	o	MATLAB function
	o	Takes zip files and turns binary .raw files into three nifti images
		~	Magnitude, Temperature, and Thermal Dose
-	Volume3.command(patient 1, patient x)
	o	BASH command
	o	Processes the output from extractNiftiZipInput2 and produces predicted lesion masks and files for DSC analysis
	o	Made to work on single patient or multiple patients
-	genReport(patient 1, patient x)
	o	BASH command
	o	Takes the predicted lesion masks and DSC files and turns into .csv report




How to process patients, including report generation
1)	Open up MATLAB, change working directory to directory with matlab function
2)	Run extractNiftiZipInput2 for desired patient - See instructions below
3)	Open up a terminal
4)	Go the directory containing the functions
5)	Run predictLesions.command for desired patients - See instructions below
6)	Run genReport.command for desired patients - See instructions below



 

extractNiftiZipInput2(cmd, zipfile, RigidTransformFile, outFile)

-	Purpose
	o	Produces the magnitude, temperature, and thermal dose maps for a patient
-	Requires
	o	Access to Pikelab
	o	MATLAB 2018a or 2018b
-	To use
	o	Open matlab
	o	Set working directory to folder with extractNiftiZipInput2.m file
	o	Use function extractNiftiZipInput2 <cmd> <filepath> <filepath> <filepath to output directory>, see examples section
-	Input - Input is set-up to autocomplete using the included functionSignatures.json file	
	o	Cmd - Tells MATLAB if you want temperature maps, magnitude maps, or both
		~ 	Use the following keywords to define what nifti files you want output
			•	'dose' - Outputs only thermal dose maps
			•	'temp' - Outputs only temperature maps
			•	'mag' - Outputs only magnitude maps
			•	'temp&mag' - Outputs temperature and magnitude maps
			•	'temp&dose' - Outputs temperature and thermal dose maps
			•	'mag&dose' - Outputs magnitude and thermal dose maps
			•	'all' - Outputs temperature maps, magnitude maps, and thermal dose maps
	o	Zipfile - The patient file you want to process
		~	Input as a filepath leading to zip file *Refer to Available Data section, for filepath*
	o	RigidTransformFile - The matrix that converts files from intra-operative space to pre-operative space
		~	Input as a filepath leading to zip file *Refer to Available Data section, for filepath*
		~ 	Requires Pikelab
	o	outfile - The destination file where patient nifti files are to be saved
		~	Input as a filepath to desired output directory
		~	Default is within the directory with functions, files need to be in default if a report is needed
-	Outputs
	o	Magnitude Maps - Default Names:
		~	IntraOp-Magnitude#-Sonication_#.nii.gz
		~	PreOp-Magnitude#-Sonication_#.nii.gz
	o	Temperature Maps - Default Names:
		~	IntraOp-Thermal#-Sonication_#.nii.gz
		~	PreOp-Thermal#-Sonication_#.nii.gz
	o	Thermal Dose Maps - Default Names:
		~	IntraOp-CEM240-#-Sonication_#.nii.gz
		~	PreOp-CEM240-#-Sonication_#.nii.gz
-	Examples - Use within MATLAB
	o	Extract: temperature maps, magnitude, maps, thermal dose maps. Output to default directory
		~	extractNiftiZipInput2('all',' /Volumes/Pikelab/SPichardo/9002-May19 2017.zip','Volumes/Pikelab/SPichardo/9002-Intra-to-Pre.RAS')
	o	Extract temperature maps and thermal dose maps. Output to desktop
	extractNiftiZipInput2('temp&dose',' /Volumes/Pikelab/SPichardo/9002-May19 2017.zip', 'Volumes/Pikelab/SPichardo/9002-Intra-to-Pre.RAS','~/Desktop')
	o	Extract temperature maps only. Output to default directory
		~	extractNiftiZipInput2('temp','/Volumes/Pikelab/SPichardo/9002-May19 2017.zip','Volumes/Pikelab/SPichardo/9002-Intra-to-Pre.RAS')
	o	Extract all maps and save to other directory. Output to desktop
		~	extractNiftiZipInput2('all','/Volumes/Pikelab/SPichardo/9002-May192017.zip','/Volumes/Pikelab/SPicarod/9002-Intra-to-Pre.RAS','~/Desktop/9002')





predictLesions (patient 1, patient x)
-	Purpose:
	o	Produced the predicted lesion maps using the thermal dose maps. Operates with two cases.
		~	Case 1: Single patient. Input patient number
		~	Case 2: Range of patients.  * Will process patients from lowest number to highest, incrementally
	o	Produces the Dice coefficient denominator and numerator niftis for genReport.
-	Requires
	o	The thermal dose map outputs from MATLAB
	o	FSL 5.0.11 or 5.0.10
	o	FLIRT v6.0
-	To Use:
	o	Open up a terminal
	o	Change directory to directory with predectLesions.command
	o	Type into terminal ./predictLesions.command <patient 1> <patient x>
-	Input
	o	Patient 1 - Lowest number patient or only patient wanting processing
		~	Function will throw an error if not provided
	o	Patient x (optional) - Highest number patient
-	Outputs
	o	Predicted lesion masks
		~	Predicted-Lesion-Mask-###.nii.gz
	o	DSC numerator and denominator files
		~	DSC_Denom_###.nii.gz
		~	DSC_Num_###.nii.gz
	o	### is the thermal dose threshold
-	Examples
	o	makeLesions user$ ./Volume3.command 9002
		~	Will process patient 9002 only
	o	makeLesions user$ ./Volume3.command 9004 9006
		~	Will process patients 9004, 9005, and 9006
-	Possible Thrown Errors:
	o	Too many inputs
	o	No input
	o	The thermal dose maps are not available













genReport (patient 1, patient x)

-	Purpose:
	o	Generates a report for volume and dice co-efficients for the patients required works for three cases:
		~	Case 1: Generate a report from patients 9002 to 9021. Enter no arguments
		~	Case 2: Generate a report for a single patient. Enter single argument
		~	Case 3: Generate a report for a specific range of patients. Enter argument 1 then argument 2
-	Requires:
	o	FSL 5.0.11
	o	That the file tree structure is followed
-	Directions to use
	o	Open up a terminal
	o	Change directory to directory with genReport.command
	o	Type into terminal ./genReport.command <patient 1> <patient x>
-	Input
	o	Patient 1 - Optional - First or only patient that is needed
	o	Patient x - Optional - Final patient wanted processing
-	Output
	o	TotalReport.csv in analysis directory
-	Examples
	o	Case 1
		~	makeLesions user$./genReport.command
	o	Case 2
		~	makeLesions user$ ./genReport.command 9010
	o	Case 3
		~	makeLesions user$ ./genReport.command 9003 9002
-	Possible Thrown Errors
	o	Too many inputs

 







Available Data:

Patient	| ZipFile | PostOp to PreOp Matrix | PreOp to IntraOp Matrix | IntraOp to PreOp Matrix | Fiesta |T1 | T1 Mask |
	|	  |			   |			     |			       |	|   |	      |
9001	|   x     |	     x		   |		n/a	     |		n/a	       |  n/a	| x |	 x    |
9002	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9003	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9004	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9005	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9006	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9007	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9008	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9009	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9010	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9011	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9012	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	| x |	 x    |
9013	|   x     |	     x		   |		 x	     |		 x	       |   x 	| x |	 x    |
9014	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	| x |	 x    |
9015	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	| x |	 x    |
9016	|   x     |	    n/a		   |		 x	     |		 x	       |   x 	| x |	 x    |
9017	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	| x |	 x    |
9018	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	| x |	 x    |
9019	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	| x |	 x    |
9020	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	| x |	 x    |
9021	|   x     |	    n/a		   |		 x	     |		 x	       |   x 	| x |	 x    |
9022	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	| x |	 x    |



-	9001
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9001 - May 26 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9001-RXYZ-IntraOp-To-PreTreat.RAS
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9001_SH-11644/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9001_SH-11644/anat/ T1_lesion_mask_filled.nii.gz
-	9002
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9002 - June 15 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9002-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9002-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9002/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9002 Ra 19000101/study/3D FIESTA.nii.gz
	o	T1 
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9002_RA-11764/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9002_RA-11764/anat/ T1_lesion_mask_filled.nii.gz
-	9003
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9003 - July 25 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9003-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9003-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9003T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9003 Rb 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9003_RB-12013/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9003_RB-12013/anat/T1_lesion_mask_filled.nii.gz
-	9004
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9004 - Aug 15 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9004-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9004-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9004/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9004 Ep 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9004_EP-12126/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9004_EP-12126/anat/T1_lesion_mask_filled.nii.gz
-	9005
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET_9005 - Jan 16 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9005-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9005-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9005/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9005 Bg 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9005_BG-13004/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9005_BG-13004/anat/T1_lesion_mask_filled.nii.gz
-	9006
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9006 - Sep 26 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9006-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9006-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9006/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9006 Eo 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9006_EO-12389/anat/T1.nii.gz
	o	T1 Lesion Mask
	~		/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9006_EO-12389/anat/T1_lesion_mask_filled.nii.gz
-	9007
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9007 - Nov 28 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9007-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9007-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9007/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9007 Rb 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9007_RB-12461/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9007_RB-12461/anat/T1_lesion_mask_filled.nii.gz
-	9008
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9008 - Oct 24 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9008-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9008-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9008/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9008 Jo 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9008_JO-12613/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9008_JO-12613/anat/T1_lesion_mask_filled.nii.gz
-	9009
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9009- Dec 19 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9009-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9009-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9009/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9009 Crb 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9009_CRB-12609/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9009_CRB-12609/anat/T1_lesion_mask_filled.nii.gz
-	9010
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET-9010 - March 20 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9010-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9010-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9002/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9010 Rr 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9010_RR-13130/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9010_RR-13130/anat/T1_lesion_mask_filled.nii.gz
-	9011
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9011 - June 19 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9011-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9011-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9011/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9011 Bb 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9011_BB-13042/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9011_BB-13042/anat/T1_lesion_mask_filled.nii.gz
-	9012
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9012_AT-13418/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9012_AT-13418/anat/T1_lesion_mask_filled.nii.gz
-	9013
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9013 - Apr 17 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9013-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9013-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9013/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9013 Jd 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9013_JD-13455/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9013_JD-13455/anat/T1_lesion_mask_filled.nii.gz
-	9014
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9014_DM-13068/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9014_DM-13068/anat/T1_lesion_mask_filled.nii.gz
-	9015
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9015-DW-13582/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9015-DW-13582/anat/T1_lesion_mask_filled.nii.gz
-	9016
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9016 - Aug 2nd 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9016-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9016-PreTreat-To-IntraOp.MAT
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9016 Eb 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9016_EB-13634/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9016_EB-13634/anat/T1_lesion_mask_filled.nii.gz
-	9017
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9017_DB-13822/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9017_DB-13822/anat/T1_lesion_mask_filled.nii.gz
-	9018
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9018_BK-13858/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9018_BK-13858/anat/T1_lesion_mask_filled.nii.gz
-	9019
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9019_TB-14038/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9019_TB-14038/anat/T1_lesion_mask_filled.nii.gz
-	9020
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9020_JL-14121/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9020_JL-14121/anat/T1_lesion_mask_filled.nii.gz
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9020 Jl 19000101/study/3D FIESTA.nii.gz
-	9021
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9021 - Aug 2nd 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9021-RXYZ-IntraOp-To-PreTreat.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9021-PreTreat-To-IntraOp.MAT
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9021_WM-14127/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9021_WM-14127/anat/T1_lesion_mask_filled.nii.gz
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9021 Wm 19000101/study/3D FIESTA.nii.gz
-	9022
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9022_JG-14290/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9022_JG-14290/anat/T1_lesion_mask_filled.nii.gz



Updates:
-	V3 
o	Modified extractNiftiZipInput
	Removed cmd2 input argument. 
	Added keywords for cmd argument.
	Modified functionSignatures.json to reflect this change.
-	V2 
o	Modified extractNiftiZipInput
	Swap position of RigidTransformFile and outFile
	outFile now has default set to maintain file tree
	outFile is now optional
	Removed code line that moved files that didn't need to exist
o	Modified predictLesions
	Merged sub functions getSagittal and getFiles into getFiles
*	Now all files are placed into their folders in one function
	Merged the DSC and Volume subfunctions
*	DSC files are made within the volume function
*	Easier to redefine threshold limits

	|
