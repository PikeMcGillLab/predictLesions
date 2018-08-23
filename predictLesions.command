#! /bin/bash

# This function is designed to make nifti files for future analysis
# It will create predicted lesion masks for thresholds 240, 230, 220, 210, 200, 160, 120 80 CEM43
# These files can be used for DSC and volume comparison to T1 control lesions

#### 	Start getSagittal Function	###############################################################
# Sub-function to copy the relevant sagittal reference image from SPichardo
# This function is a if/else block due to patient identifiers having different initials.
# Note: This will have to updated as more patients are added

#TODO: Merge getFiles with getSagittal

getSagittal(){

# File pathways
path="/Volumes/Pikelab/SPichardo/input"
end="study"

if [[ $1 -eq 9001 ]];then
	echo Fiesta for 9001 does not exist	
elif [[ $1 -eq 9002 ]];then
	cp ${path}/9002\ Ra\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9003 ]];then
	cp ${path}/9003\ Rb\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9004 ]];then
	cp ${path}/9004\ Ep\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9005 ]];then
	cp ${path}/9005\ Bg\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9006 ]];then
	cp ${path}/9006\ Eo\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9008 ]];then
	cp ${path}/9008\ Jo\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9009 ]];then
	cp ${path}/9009\ Crb\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9010 ]];then
	cp ${path}/9010\ Rr\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9011 ]];then
	cp ${path}/9011\ Bb\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9013 ]];then
	cp ${path}/9013\ Jd\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9016 ]];then
	cp ${path}/9016\ Eb\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9020 ]];then
	cp ${path}/9020\ Jl\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
elif [[ $1 -eq 9021 ]];then
	cp ${path}/9021\ Wm\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files
# Added for when needed for another patient
#elif [[ $1 -eq 90xx ]];then
#	cp ${path}/90xx\ XX\ 19000101/${end}/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Processed_Files

else
	echo The T1s do not exist for patient $1
fi

# Remove the white spaces from the name
mv $2/Patient_Files/$1/Processed_Files/3D\ FIESTA.nii.gz $2/Patient_Files/$1/Sagittal_Fiesta.nii.gz

} #End function to get sagittal reference nifti

#### 	End getSagittal Function	###############################################################



#### 	Start getFiles Function	###############################################################
# Subfunction that copies the T1, T1 lesion mask (post op), post-op to pre-op matrix, and pre-op to intra-op conversion matrix.
# T1 and masks are accessed in a if/else block because the identifier for each patient has a unique number.

#TODO: Merge getFiles with getSagittal
getFiles() {

echo $pwd

#File pathways for the T1 and T1 mask files
T1_data="/Volumes/Pikelab/MRGFUS-shared/analysis_lesion_masks"		
T1="T1.nii.gz"
mask="T1_lesion_mask_filled.nii.gz"
Sam="/Volumes/Pikelab/SPichardo/Post_2_Pre_Matrix"

#Copy the Pre-Treat to Intra_Op matrix 
cp /Volumes/Pikelab/SPichardo/$1-PreTreat-To-IntraOp.MAT TMap$2


if [[ $1 -eq 9001 ]];then
	cp ${T1_data}/9001_SH-11692/anat/$T1 TMap${2}
	cp ${T1_data}/9001_SH-11692/anat/$mask TMap${2}	
elif [[ $1 -eq 9002 ]];then
	cp ${T1_data}/9002_RA-11833/anat/${T1} TMap${2}
	cp ${T1_data}/9002_RA-11833/anat/${mask} TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9003 ]];then
	cp ${T1_data}/9003_RB-12064/anat/$T1 TMap${2}
	cp ${T1_data}/9003_RB-12064/anat/$mask TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9004 ]];then
	cp ${T1_data}/9004_EP-12203/anat/$T1 TMap${2}
	cp ${T1_data}/9004_EP-12203/anat/$mask TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9005 ]];then
	cp ${T1_data}/9005_BG-13126/anat/$T1 TMap${2}
	cp ${T1_data}/9005_BG-13126/anat/$mask TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9006 ]];then
	cp ${T1_data}/9006_EO-12487/anat/$T1 TMap${2}
	cp ${T1_data}/9006_EO-12487/anat/$mask TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9007 ]];then
	cp ${T1_data}/9007_RB-12910/anat/$T1 TMap${2}
	cp ${T1_data}/9007_RB-12910/anat/$mask TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9008 ]];then
	cp ${T1_data}/9008_JO-12667/anat/$T1 TMap${2}
	cp ${T1_data}/9008_JO-12667/anat/$mask TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9009 ]];then
	cp ${T1_data}/9009_CRB-13043/anat/$T1 TMap${2}
	cp $T1_data9009_CRB-13043/anat/$mask TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9010 ]];then
	cp ${T1_data}/9010_RR-13536/anat/$T1 TMap${2}
	cp ${T1_data}/9010_RR-13536/anat/$mask TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9011 ]];then
	cp ${T1_data}/9011_BB-14148/anat/$T1 TMap${2}
	cp ${T1_data}/9010_RR-13536/anat/$mask TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9013 ]];then
	cp ${T1_data}/9013_JD-13722/anat/$T1 TMap${2}
	cp ${T1_data}/9013_JD-13722/anat/$mask TMap${2}
	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
elif [[ $1 -eq 9016 ]];then
	cp ${T1_data}/9016_EB-14450/anat/$T1 TMap${2}
	cp ${T1_data}/9016_EB-14450/anat/$mask TMap${2}
	#cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}		#The T1 post to pre isn't available at time of wriitng
elif [[ $1 -eq 9020 ]];then
	cp ${T1_data}/9020_JL-14340/anat/$T1 TMap${2}
	cp ${T1_data}/9020_JL-14340/anat/$mask TMap${2}
	#cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}		#The T1 post to pre isn't available at time of wriitng
elif [[ $1 -eq 9021 ]];then
	cp ${T1_data}/9021_WM-14455/anat/$T1 TMap${2}
	cp ${T1_data}/9021_WM-14455/anat/$mask TMap${2}
	#cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}		#The T1 post to pre isn't available at time of wriitng
#Added for future patient
#elif [[ $1 -eq 90xx ]];then
#	cp ${T1_data}/90xx_Xx-xxxxx/anat/$T1 TMap$2
#	cp ${T1_data}/90xx_Xx-xxxxx/anat/$mask TMap$2
#	cp ${Sam}/$1/T1_day1_2_T2_pre.mat TMap${2}
else
	echo The T1s do not exist for patient $1
fi
} # End get files

#### 	End getFiles Function		###############################################################


#### 	Start Volume Function	"arg1: Patient Number" "arg2:file path"	###############################################################
# Function that will make predicted lesion masks 
# TODO: merge the DSC function files into the threshold loops

Volume() {

#Start with basic housekeeping. Move magnitude maps and temperature maps to relevant directories, won't need them at this point

getSagittal $1 $2		#Copy the reference images into the Processed_Files

#TODO: When function is fully working, change cp to mv
if [[ -f IntraOp-Magnitude1-Sonication_1.nii.gz ]] # If mag maps are available move them
then
	cp -R *Magnitude*.nii.gz Raw_Data/Magnitude_Maps
fi #

if [[ -f IntraOp-Thermal1-Sonication_1.nii.gz ]] #If temp maps are available move them
then
	cp -R *Thermal*.nii.gz Raw_Data/Temperature_Maps
fi 


cp -R Sagittal_Fiesta.nii.gz Processed_Files/TMap1
cp -R Sagittal_Fiesta.nii.gz Processed_Files/TMap2


# Overlay the highest value voxels throughout time axis into 3D space
# For both intra opererative and pre-operative space



if [[ -e IntraOp-CEM240-1-Sonication_1.nii.gz ]] #Must check if the dose maps are available. If not available, an error will be thrown
then
	for filename in IntraOp-CEM240-*-Sonication*.nii.gz #Intra-Operative thermal dose maps
	do
    		fname=`$FSLDIR/bin/remove_ext ${filename}` 	#FSL function used to remove the extension from the file 
	
		if [[ -f ${fname}_Overlay ]] 
		then
			rm ${fname}_Overlay
		fi
    	
		fslmaths ${fname} -Tmax ${fname}_Overlay		#Using Tmax flag gets all possible lesion voxels, also increases noise
	done

	# Move images in batches 

	mv -f IntraOp-CEM240-1-Sonication_*_Overlay.nii.gz Processed_Files/TMap1        
	mv -f IntraOp-CEM240-2-Sonication_*_Overlay.nii.gz Processed_Files/TMap2
	cp -R IntraOp-CEM240-1-Sonication_*.nii.gz Processed_Files/TMap1/IntraOp_Dose_Maps
	cp -R IntraOp-CEM240-2-Sonication_*.nii.gz Processed_Files/TMap2/IntraOp_Dose_Maps
	cp -R PreOp-CEM240-1-Sonication_*.nii.gz Processed_Files/TMap1/PreOp_Dose_Maps
	cp -R PreOp-CEM240-2-Sonication_*.nii.gz Processed_Files/TMap2/PreOp_Dose_Maps

	# Will process images according to the maps
	# Perform each action in each TMap
	# Temperature maps are separated by number

	cd Processed_Files
	
	# Process patient files, TMap 1 then TMap 2
	for i in {1..2}
	do
		if [[ -d TMap$i ]]
    		then
			cd TMap$i
			echo TMap $i		#For tracking progress of function       

			# Going to take a point mask of the final sonication based on a square spot
			# Square to try and compensate for moving of target by surgeon

			Count=$(ls IntraOp-CEM240-*-Sonication_*_Overlay.nii.gz | grep -v '/$' | wc -l)	
			echo $Count
		
			for filename in IntraOp-CEM240-$i-Sonication_*_Overlay.nii.gz
			do  
    				fname=`$FSLDIR/bin/remove_ext ${filename}`    
    		    	
				if [[ $filename = *12* ]];
		    		then
					# Get pixels in x-dimension for spot mask
					# Contains correction for a sagittal view, by checking if the x dimension is 1 pixel wide

					Xval=`fslval ${fname} dim1`
    		    			if [ "${Xval}" != 1 ];then
	            				xup='1'
	            				xbot=$(echo "$Xval/2" | bc)
    		    			else
                    					xup='1'
	            				xbot='0'
    		    			fi #x-if block
				
					# Get pixels in y-dimension for spot mask
					# Contains correction for an coronal view, by checking if the y dimension is 1 pixel wide
	
    			    		Yval=`fslval ${fname} dim2`
    			    		if [ "$Yval" != 1 ];then
    		    				yup='1'
    		     				ybot=$(echo "$Yval/2" | bc)
    		    			else
		    				yup='1'
	             				ybot='0'
    		    			fi # Y-if block

					# Get pixels in z-dimension for spot mask
					# Contains correction for an axial view, by checking if the z dimension is 1 pixel wide

	    			    	Zval=`fslval ${fname} dim3`
    				    	if [ "$Zval" != 1 ];then
    			    			zup='1'
   		    				zbot=$(echo "$Zval/2" | bc)
    		   	 		else
		    				zup='1'
		    				zbot='0'
    		    			fi # Z-if block

		    			fslmaths ${fname} -mul 0 -add 1 -roi $xbot $xup $ybot $yup $zbot $zup 0 1 2DSpot.nii.gz -odt float # Make the mask
			    	fi #end if block for spot mask

			    	flirt -in ${fname} -ref Sagittal_FIesta.nii.gz -2D -applyxfm -usesqform -setbackground 0 -paddingsize 1 -interp nearestneighbour -out Flirt-${fname}.nii.gz  #Transform 2D overlays into Fiesta space
				mv $filename dose_Overlay
		    
			done #Flirt-Space loop
		
			# Make the ROI mask 
			flirt -in 2DSpot.nii.gz -ref Sagittal_FIesta.nii.gz -2D -applyxfm -usesqform -setbackground 0 -paddingsize 1 -interp nearestneighbour -out 3Dspot.nii.gz 
			fslmaths 3DSpot.nii.gz -kernel sphere 8 -fmean -thr 1e-8 -bin 3DSphere.nii.gz #The sphere has a 8 mm radius

			# Making 3D thermal dose maps
			fslmerge -t 3D_Dose_Map Flirt*
			fslmaths 3D_Dose_Map.nii.gz -Tmax 3D_Dose_Map.nii.gz
			
			mv Flirt* fiesta_space #housekeeping

			# Make lesion mask		
			fslmaths 3D_Dose_Map.nii.gz -mas 3DSphere.nii.gz Predicted-Lesion-Mask.nii.gz
			mv 3D_Dose_Map.nii.gz Auxilliary_Files

			# More housekeeping
			mv 2DSpot.nii.gz Auxilliary_Files
			mv 3DSpot.nii.gz Auxilliary_Files
			mv 3DSphere.nii.gz Auxilliary_Files

			# Threshold the lesion mask
			for ((var=80; var<200; var+=40))
			do
				fslmaths Predicted-Lesion-Mask.nii.gz -thr $var -bin Predicted-Lesion-Mask-${var}.nii.gz
				#This is where the DSC merging could happen
			done #Threshold loop

			for ((var=200; var<=240; var+=10))
			do
				fslmaths Predicted-Lesion-Mask.nii.gz -thr $var -bin Predicted-Lesion-Mask-${var}.nii.gz
				#This is where the DSC merging could happen
			done #Threshold loop 
		
			mv -f Predicted-Lesion-Mask* Analysis_Files #housekeeping

           		 	cd .. #Go up one directory and start over for TMap 2
    		fi #end TMap check
	done # TMap for loop
else #If thermal dose maps don't exist
	echo Error: Thermal dose maps not made, may not have been made in MATLAB
	exit 14
fi
} #End - Finished making predicted lesion masks

#### 	End Volume Function		###############################################################



#### 	Start DSC Function		###############################################################

DSC() {

# Now take all the needed files to make the DSC values
# Need T1, T1 lesion, and matrix files

for i in {1..2}
do
	getFiles $1 $i

	cd TMap$i

	# Make the PostOp 2 IntraOp matrix and move files
	convert_xfm -omat Post2Intra.mat -concat $1-PreTreat-To-IntraOp.MAT T1_day1_2_T2_pre.mat
	mv $1-PreTreat-To-IntraOp.MAT DSC_Intermediates
	mv T1_day1_2_T2_pre.mat DSC_Intermediates
	
	# Make the lesion mask and T1 image in IntraOp space
	flirt -in T1.nii.gz -ref Sagittal_FIesta.nii.gz -interp nearestneighbour -applyxfm -init Post2Intra.mat -out T1_IntraSpace.nii.gz 			# Convert the T1 to IntraOp space
	flirt -in T1_lesion_mask_filled.nii.gz -ref Sagittal_FIesta.nii.gz -interp nearestneighbour -applyxfm -init Post2Intra.mat -out T1_Mask_Intra.nii.gz	# Convert the T1 mask to IntraOp space
	mv T1_lesion_mask_filled.nii.gz Analysis_Files
	mv T1.nii.gz DSC_Intermediates	

	# Get the DSC files for each threshold
	for ((var=80; var<200; var+=40))
	do 
		fslmaths Analysis_Files/Predicted-Lesion-Mask-${var}.nii.gz -add T1_Mask_Intra.nii.gz -bin DSC_Denom_${var}.nii.gz
		fslmaths Analysis_Files/Predicted-Lesion-Mask-${var}.nii.gz -add T1_Mask_Intra.nii.gz -thr 2 -bin DSC_Num_${var}.nii.gz
		mv DSC_*.nii.gz Analysis_Files/DSC
	done

	for ((var=200; var<=240; var+=10))
	do
		fslmaths Analysis_Files/Predicted-Lesion-Mask-${var}.nii.gz -add T1_Mask_Intra.nii.gz -bin DSC_Denom_${var}.nii.gz
		fslmaths Analysis_Files/Predicted-Lesion-Mask-${var}.nii.gz -add T1_Mask_Intra.nii.gz -thr 2 -bin DSC_Num_${var}.nii.gz
		mv DSC_*.nii.gz Analysis_Files/DSC
	done

	# More housekeeping
	mv T1* DSC_Intermediates
	mv Post2Intra.mat DSC_Intermediates

	cd ..
done
} 
#### 	End DSC Function		###############################################################

#### 	Main Function		###############################################################

# Error handling: must have at least one input, not more than two
if [[ "$#" -lt 1 ]]
then						#Check if there is no input
	echo Error: No input given. Please provide either 1 or 2 inputs.
	exit 786
elif [[ "$#" -ge 3 ]]
then
	echo Error: Too many inputs, max two allowed
	exit 235
fi						#If input exists

base=$(pwd)		#The directory this function will be working from


#Start processing data, two possible ways to proceed. Solo patient, if provided 
if [[ "$#" -eq 1 ]]
then
	if [[ -d $base/Patient_Files/$1 ]]
	then
		cd "$base"
		# Set-up file tree that will store files in logical places
		mkdir -p $base/Results							#Directory to hold the .csv files

		mkdir -p $base/Patient_Files/$1/Raw_Data/Magnitude_Maps				#Directory to hold the nifties from MATLAB, magnitude maps both Map 1 and 2
		mkdir -p $base/Patient_Files/$1/Raw_Data/Temperature_Maps			#Directory to hold the nifties from MATLAB, temp maps both 1 and 2
			
		for x in {1..2}
		do
			mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/PreOp_Dose_Maps	#Directory to hold the PreOp thermal dose maps
			mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/IntraOp_Dose_Maps	#Directory to hold the IntraOp thermal dose maps
			mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/fiesta_space		#Directory to hold the files from FLIRTing the 2D thermal dose slices
			mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/dose_Overlay		#Directory to hold the collapsing the 2D thermal dose time series
			mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/Analysis_Files/DSC	#Directory to hold the files that will be used for analysis, volume and DSC
			mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/Auxilliary_Files	#Directory to hold any other files that were needed
			mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/DSC_Intermediates	#Directory to hold the files that are created for DSC analysis, that are not directly analyzed
		done		
	
		echo $file						#for tracking progress of function
		cd "$base"/Patient_Files/$1
		Volume $1 $base
		echo Volume Done
		cd "$base"/Patient_Files/$1/Processed_Files
		DSC $1
		echo DSC Done	
	else
		echo Patient $1 does not exist, May not have been processed
	fi

# This case is for processing range of patients
elif [[ "$#" -eq 2 ]]
then
	#Put the patients in the correct order, smallest number to largest
	if [[ $1 -gt $2 ]]
	then
		A=$2
		B=$1
	elif [[ $1 -eq $2 ]]
	then
		echo Error: Entered same patient for both range limits
		exit 704
	else
		A=$1
		B=$2
	fi	

	for ((file=$A;file<=$B;file++))
	do
		if [ -d $base/Patient_Files/$1 ] 
		then
			cd "$base"
	
			# Set-up file tree that will store files in logical places
			mkdir -p $base/Results					#Hold the .csv files

			mkdir -p $base/Patient_Files/$1/Raw_Data/Magnitude_Maps			#Hold the nifties from MATLAB, magnitude maps both Map 1 and 2
			mkdir -p $base/Patient_Files/$1/Raw_Data/Temperature_Maps			#Hold the nifties from MATLAB, temp maps both 1 and 2
			
			for x in {1..2}
			do
				mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/PreOp_Dose_Maps		#Hold the PreOp thermal dose maps
				mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/IntraOp_Dose_Maps	#Hold the IntraOp thermal dose maps
				mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/fiesta_space		#Hold the files from FLIRTing the 2D thermal dose slices
				mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/dose_Overlay		#Hold the collapsing the 2D thermal dose time series
				mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/Analysis_Files/DSC	#Hold the files that will be used for analysis, volume and DSC
				mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/Auxilliary_Files		#Holds any other files that were needed
				mkdir -p $base/Patient_Files/$1/Processed_Files/TMap$x/DSC_Intermediates	#Hold the files that are created for DSC analysis, that are not directly analyzed
			done		
			cd "$base"/Patient_Files/$file					
			Volume $file $base
			echo Volume Done
			cd "$base"/Patient_Files/$1/Processed_Files
			DSC $file
			echo DSC Done		
		else
			echo Patient $1 either does not exist or has not been processed in MATLAB
			exit 704
		fi
	done
fi #end elif statements

###########		Thus endeth this script 	###############
