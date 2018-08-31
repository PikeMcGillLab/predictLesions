Making predicted lesion masks

Before you begin, make sure:
-	You are signed into Pikelab on AcademicFS
	o	This can be accessed by requesting permission from Andre Robichaud: andre.robichaud@ucalgary.ca
	o	See lab wiki:
		~	https://sites.google.com/site/qmrilab/tutorials/new-lab-members
	o	Used to access the files needed to process patients. These files do not need to be copied to your computer. 			They are accessed either when calling a function or within the function, while it is running. 
	o	Refer to available files section to see what files exist and where they are stored
	o	Files that are needed to process patients, any files with blank spaces that will be used with FSL are renamed 			while the function is being called.
		~	Patient zip files
		~	Post-Operative to T2 Pre-Operative Transformation matrices ~
		~	Pre-Operative to Intra-Operative Transformation matrices
		~	Intra-Operative to Pre-Operative Transformation matrices
		~	FIESTA Images
		~	T1 images 
		~	T1 lesion masks
-	You are using a Mac (tested on OS 10.12.6 and OS 10.13.6)
-	You have installed MATLAB (tested on 2018a and 2017b)
-	You have FSL installed
	o	FSL 5.0.11 or 5.0.10
	o	FLIRT v6.0
-	In order to produce the predicted lesion masks and generate a final report, the files are assumed to follow the file tree.

*Note: As new patients are treated as part of the study, their files will have to be added to predictLesion.command in the subfuction getFiles

Functions:
-	extractNiftiZipInput2(cmd, zipfile, RigidTransformFile, outFile)
	o	MATLAB function
	o	Takes zip files and turns binary .raw files into three nifti images
		~	Magnitude, Temperature, and Thermal Dose
-	predictLesions.command(patient 1, patient x)
	o	BASH command
	o	Processes the output from extractNiftiZipInput2 and produces predicted lesion masks and files for DSC analysis
	o	Made to work on single patient or multiple patients
-	genReport.command(patient 1, patient x)
	o	BASH command
	o	Takes the predicted lesion masks and DSC files and turns into .csv report


How to process patients, including report generation
1)	Download git repository onto computer. Downloads as predictLesions-master.zip
2) 	Unzip predictLesions-master and move folder to desktop
3)	Open up MATLAB, change working directory to ~/Desktop/predictLesions-master
4)	Run extractNiftiZipInput2 for desired patient - See instructions below
5)	Open up a terminal
6)	Change directory to ~/Desktop/predictLeisons-master
8)	Use command chmod -rwx predictLesions.command to allow read, write, and execute permission
9)	Use command chmod -rwx genReport.command to allow read, write, and execute permission
10)	Run predictLesions.command for desired patients - See instructions below
11)	Run genReport.command for desired patients, if desired - See instructions below



extractNiftiZipInput2(cmd, zipfile, RigidTransformFile)

-	Purpose
	o	Produces the magnitude, temperature, and thermal dose maps for a patient. The output is saved to the directory holding extractNiftiZipInput2.m
-	Input - Set to auto-complete within MATLAB via the file: functionSignatures.json
	o	Cmd - Sets the output for MATLAB.
		~ 	Use the following keywords to output required nifti files
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
-	Outputs
	o	Magnitude Maps
		~	Low resolution 4D image showing the structures of the patient's brain
		~	Default Names:
			>	IntraOp-Magnitude#-Sonication_#.nii.gz
			>	PreOp-Magnitude#-Sonication_#.nii.gz
	o	Temperature Maps
		~	4D image showing the temperatures within the patient's brain
		~	Default Names:
			>	IntraOp-Thermal#-Sonication_#.nii.gz
			>	PreOp-Thermal#-Sonication_#.nii.gz
	o	Thermal Dose Maps
		~	Image of the thermal dose of the patient's brain.
		~	Thermal dose is measured in cumulative equivalent minutes at 43 celcius (CEM43)
		~	See /Volumes/Pikelab/MTaylor/MRgFUS_Report.pdf and /Volumes/Pikelab/MTaylor/MRgFUS_presentation for more information on CEM43
		~	A good paper for CEM43 is: Basic principles of thermal dosimetry and thermal thresholds for tissue damage from hyperthermia, by Dewhirst. See DOI: doi: 10.1080/0265673031000119006 or pubmed ID: 12745972
		~ 	Default Names:
			> 	TODO NOTE: THESE NAMES SHOULD BE CHANGED TO IntraOp-CEM43-TMap#-Sonication#.nii.gz, PreOp-CEM43-TMap#-Sonication#.nii.gz  
			>	IntraOp-CEM240-#-Sonication_#.nii.gz
			>	PreOp-CEM240-#-Sonication_#.nii.gz
-	Examples - Use within MATLAB. 
	o	Extract: temperature maps, magnitude, maps, thermal dose maps
		~	extractNiftiZipInput2('all','/Volumes/Pikelab/SPichardo/ET 9002 - June 15 2017.zip','/Volumes/Pikelab/SPichardo/9002-RXYZ-PreTreat-To-IntraOp.RAS')
	o	Extract temperature maps and thermal dose maps
		~	extractNiftiZipInput2('temp&dose','/Volumes/Pikelab/SPichardo/ET 9002 - June 15 2017.zip', '/Volumes/Pikelab/SPichardo/9002-RXYZ-PreTreat-To-IntraOp.RAS')
	o	Extract temperature maps only
		~	extractNiftiZipInput2('temp','/Volumes/Pikelab/SPichardo/ET 9002 - June 15 2017.zip','/Volumes/Pikelab/SPichardo/9002-RXYZ-PreTreat-To-IntraOp.RAS')
	o	Extract all maps
		~	extractNiftiZipInput2('all','/Volumes/Pikelab/SPichardo/ET 9002 - June 15 2017.zip','/Volumes/Pikelab/SPichardo/9002-RXYZ-PreTreat-To-IntraOp.RAS')
		
Notes:
The following functions, used in extractNiftiZipInput2, were not programmed by a member of McGill lab
- xml2struct.m is sourced from https://github.com/kndiaye/matlab
- nii_tool is sourced from https://github.com/xiangruili/dicm2nii





predictLesions (patient x, patient y)
-	Purpose:
	o	Produces the predicted lesion masks using the thermal dose maps. 
	o	Produces the Dice Sorenson Coefficient (DSC) files for analysis
		~	For more information on DSC refer to /Volumes/Pikelab/MTaylor/MRgFUS_Report.pdf or wikipedia
	o	Operates under two cases.
		~	Case 1: Process single patient.
			> 	Input single patient number
		~	Case 2: Process range of patients.  * Will process patients from lowest number to highest, 				incrementally *
			>	Input two patient numbers, with a space between them, see example below
			
-	Requires
	o	The thermal dose map outputs from MATLAB
		~	Will throw error if not available
-	Input
	o	Patient 1 - Lowest number patient or only patient wanting processing
		~	Function will throw an error if not provided
	o	Patient x (optional) - Highest number patient
-	Outputs
	o	Predicted lesion masks
		~	This is an image that shows the predicted lesion
		~	Name:
			>	Predicted-Lesion-Mask.nii.gz
	o	Thresholded predicted lesion masks
		~	This is an image of the lesion mask, but voxels have been thresholded.
		~	Predicted-Lesion-Mask-###.nii.gz
			>	### is the thermal dose threshold
	o	DSC numerator files
		~	This file is used to get the numerator for DSC analysis
		~	DSC_Num_###.nii.gz
			>	### is the thermal dose threshold
	o	DSC denominator files
		~	This file is used to get the denominator for DSC analysis
		~	DSC_Denom_###.nii.gz
			>	### is the thermal dose threshold
-	Examples
	o	Process single patient: patient 9002
		~	./predictLesions.command 9002
	o	Process multiple patients: 9004, 9005, and 9006
		~	./predictLesions.command 9004 9006













genReport (patient x, patient y)

-	Purpose:
	o	Generates a report for volume and DSC for the patients
	o	Operates under three cases:
		~	Case 1: Generate a report for all possible patients. 
			>	Input no patient number
		~	Case 2: Generate a report for a single patient. 
			>	Input single patient number
		~	Case 3: Generate a report for a range of patients.  * Will process patients from lowest number to highest, incrementally *
			>	Input two patient numbers, with a space between them, see example below
-	Input
	o	Patient 1 - Optional - First or only patient that is needed
	o	Patient x - Optional - Final patient wanted processing
-	Output
	o	Volume-and-DSC-report.csv in Results directory
-	Examples
	o	Case 1: Generate a report for all possible patients
		~	makeLesions user$./genReport.command
	o	Case 2: Generate a report for a single patient: Patient 9010
		~	makeLesions user$ ./genReport.command 9010
	o	Case 3: Generate a report for a specific range of patients: Patients 9002 to 9005
		~	makeLesions user$ ./genReport.command 9002 9005

 







Available Data:

This table shows the files that are available for the listed patients. The contact person for the file is shown below the file type in parenthathese. An 'x' indicates file is available, a 'n/a' indicates file is not available.

Erin - emazerol@ucalgary.ca 
Samuel - samuel.pichardo@ucalgary.ca

Patient	| ZipFile | PostOp to PreOp Matrix | PreOp to IntraOp Matrix | IntraOp to PreOp Matrix | Fiesta |   T1   | T1 Mask | Pre-Op T2 Reference Image |
	| (Samuel)|	(Erin)		   |	   (Samuel)	     |	    (Samuel)	       | 	| (Erin) | (Erin)  |       (Samuel)  		   |
9001	|   x     |	     x		   |		n/a	     |		n/a	       |  n/a	|   x    |    x    |        n/a                    |
9002	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9003	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9004	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9005	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9006	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9007	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9008	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9009	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9010	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9011	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9012	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	|  n/a    |   n/a   |        n/a                  |
9013	|   x     |	     x		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9014	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	|  n/a    |   n/a   |        n/a                  |
9015	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	|  n/a    |   n/a   |        n/a                  |
9016	|   x     |	    n/a		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9017	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	|  n/a    |   n/a   |        n/a                  |                |
9018	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	|  n/a    |   n/a   |        n/a                  |
9019	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	|  n/a    |   n/a   |        n/a                  |
9020	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	|  n/a    |   n/a   |        n/a                  |
9021	|   x     |	    n/a		   |		 x	     |		 x	       |   x 	|   x    |    x    |        x                      |
9022	|  n/a    |	    n/a		   |		n/a	     |		n/a	       |  n/a 	|  n/a    |   n/a   |        n/a                  |



-	9001 - Can't run - Missing Pre-Op to Intra-Op Matrix, Fiesta Image, T2 Pre-Op Reference, 
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9001 - May 26 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9001-RXYZ-IntraOp-To-PreTreat.RAS
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9001_SH-11644/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9001_SH-11644/anat/T1_lesion_mask_filled.nii.gz
-	9002 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9002 - June 15 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9002-RXYZ-PreTreat-To-IntraOp.RAS
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
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9002 Ra 19000101/study/Sag CUBE T2.nii.gz
-	9003 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9003 - July 25 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9003-RXYZ-PreTreat-To-IntraOp.RAS
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
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9003 Rb 19000101/study/Sag CUBE T2.nii.gz
-	9004 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9004 - Aug 15 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9004-RXYZ-PreTreat-To-IntraOp.RAS
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
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9004Ep 19000101/study/Sag CUBE T2.nii.gz
-	9005 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET_9005 - Jan 16 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9005-RXYZ-PreTreat-To-IntraOp.RAS
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
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9005 Bg 19000101/study/Sag CUBE T2.nii.gz
-	9006 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9006 - Sep 26 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9006-RXYZ-PreTreat-To-IntraOp.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9006-PreTreat-To-IntraOp.MAT
	o	Post-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9006/T1_day1_2_T2_pre.mat
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9006 Eo 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9006_EO-12389/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9006_EO-12389/anat/T1_lesion_mask_filled.nii.gz
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9006 Eo 19000101/study/Sag CUBE T2.nii.gz
-	9007 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9007 - Nov 28 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9007-RXYZ-PreTreat-To-IntraOp.RAS
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
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9007 Rb 19000101/study/Sag CUBE T2.nii.gz
-	9008 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9008 - Oct 24 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9008-RXYZ-PreTreat-To-IntraOp.RAS
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
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9008 Jo 19440109/study/Sag CUBE T2.nii.gz
-	9009 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9009- Dec 19 2017.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9009-RXYZ-PreTreat-To-IntraOp.RAS
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
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9009 Crb 19331201/study/Sag CUBE T2.nii.gz
-	9010 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET-9010 - March 20 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9010-RXYZ-PreTreat-To-IntraOp.RAS
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
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9010 Rr 19000101/study/Sag CUBE T2.nii.gz
-	9011 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9011 - June 19 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9011-RXYZ-PreTreat-To-IntraOp.RAS
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
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9011 Bb 19000101/study/Sag CUBE T2.nii.gz

-	9012 - patient excluded

-	9013 - Can run
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9013 - Apr 17 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9013-RXYZ-PreTreat-To-IntraOp.RAS
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
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9013 Jd 19000101/study/Sag CUBE T2.nii.gz
-	9014 - patient excluded

-	9015 - patient excluded

-	9016 - Can't run - Missing Post-Op to Pre-Op matrix
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9016 - Aug 2nd 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9016-RXYZ-PreTreat-To-IntraOp.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9016-PreTreat-To-IntraOp.MAT
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9016 Eb 19000101/study/3D FIESTA.nii.gz
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9016_EB-13634/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9016_EB-13634/anat/T1_lesion_mask_filled.nii.gz
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9016 Eb 19000101/study/Sag CUBE T2.nii.gz
-	9017 - patient excluded

-	9018 - patient excluded

-	9019 - Can't run - Missing all files

-	9020 - Can't run - Missing Post-Op to Pre-Op matrix
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9020_JL-14121/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9020_JL-14121/anat/T1_lesion_mask_filled.nii.gz
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9020-PreTreat-To-IntraOp.MAT	
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9020-RXYZ-PreTreat-To-IntraOp.RAS
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9020 Jl 19000101/study/3D FIESTA.nii.gz
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9020 Jl 19000101/study/Sag CUBE T2.nii.gz
-	9021 - Can't run - Missing Post-Op to Pre-Op matrix
	o	Zipfile
		~	/Volumes/Pikelab/SPichardo/ET 9021 - Aug 2nd 2018.zip
	o	Intra-Operative to Pre-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9021-RXYZ-PreTreat-To-IntraOp.RAS
	o	Pre-Operative to Intra-Operative Transformation Matrix
		~	/Volumes/Pikelab/SPichardo/9021-PreTreat-To-IntraOp.MAT
	o	T1
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9021_WM-14127/anat/T1.nii.gz
	o	T1 Lesion Mask
		~	/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks/9021_WM-14127/anat/T1_lesion_mask_filled.nii.gz
	o	Fiesta
		~	/Volumes/Pikelab/SPichardo/input/9021 Wm 19000101/study/3D FIESTA.nii.gz
	o	Pre-Op T2 Image
		~	/Volumes/Pikelab/SPichardo/input/9021 Wm 19000101/study/Sag CUBE T2.nii.gz
-	9022 - Can't run - Missing all files








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
