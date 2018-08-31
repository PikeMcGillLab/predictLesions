#! /bin/bash

########	Start subfunction: makeReport		#############################

makeReport(){

for i in {1..2} 			#TMap loop
do
		
	line="$folder,TMap $i "
	cd "$2/Patient_Files/${folder}/Processed_Files/TMap$i/Analysis_Files"

	# Get volume of T1 lesion mask
	T1="$(fslstats T1_lesion_mask_filled.nii.gz -V)"

	T1_Volume=($(echo "$T1" | tr ' ' '\n'))
	T1_Vol=${T1_Volume[1]}
	line="$line,$T1_Vol"
				
				
	for ((var=240;var>=200;var-=10))
	do

		# Get volume of predicted lesion volume, 
		Predicted="$(fslstats Predicted-Lesion-Mask-${var}.nii.gz -V)"	
		Predicted_Volume=($(echo "$Predicted" | tr ' ' '\n'))
		Predict=${Predicted_Volume[1]}

		# Calculate error between predicted volume and standard volume
		Error=$(echo "($Predict-$T1_Vol)/$T1_Vol*100" | bc -l)
		Error=${Error}%

		cd DSC
		# Next get the DSC data				
		Numerator="$(fslstats DSC_Num_${var}.nii.gz -V)"
		Num=($(echo "$Numerator" | tr ' ' '\n'))
		Denominator="$(fslstats DSC_Denom_${var}.nii.gz -V)"
		Denom=($(echo "$Denominator" | tr ' ' '\n'))

		# Calculate the DSC
		N=$(echo ${Num[0]})
		D=$(echo ${Denom[0]})
		DSC=$(echo "$N/$D" | bc -l)
	
		line="$line,$Predict,$Error,$DSC"	
		cd ..
	done # Threshold loop 1


	for ((var=160;var>=80;var-=40))
	do
					
		# Get volume of predicted lesion volume, 
		Predicted="$(fslstats Predicted-Lesion-Mask-${var}.nii.gz -V)"
		Predicted_Volume=($(echo "$Predicted" | tr ' ' '\n'))
		Predict=${Predicted_Volume[1]}
			
		# Calculate error between predicted volume and standard volume
		Error=$(echo "($Predict-$T1_Vol)/$T1_Vol*100" | bc -l)
		Error=${Error}%
	
		cd DSC
		# Next get the DSC data				
		Numerator="$(fslstats DSC_Num_${var}.nii.gz -V)"
		Num=($(echo "$Numerator" | tr ' ' '\n'))
		Denominator="$(fslstats DSC_Denom_${var}.nii.gz -V)"
		Denom=($(echo "$Denominator" | tr ' ' '\n'))

		# Calculate the DSC
		N=$(echo ${Num[0]})
		D=$(echo ${Denom[0]})
		DSC=$(echo "$N/$D" | bc -l)
		
		line="$line,$Predict,$Error,$DSC"	
		cd ..
								
	done # Threshold loop 2

			
	cd "$analysis_folder"
	echo "$line" >> Volume-and-DSC-report.csv		
done #TMap loop


} #End makeReport

########	End subfunction: makeReport		#############################



########	Start Main Function			#############################

base=$(pwd)

analysis_folder=${base}/Results #Place to place the report 

line="Patient,TMap,T1 Lesion Mask Volume [mm^3],240 CEM43 Volume [mm^3],Error,Dice Coefficient,230 CEM43 Volume [mm^3],Error,Dice Coefficient,220 CEM43 Volume [mm^3],Error,Dice Coefficient,210 CEM43 Volume [mm^3],Error,Dice Coefficient,200 CEM43 Volume [mm^3],Error,Dice Coefficient,160 CEM43 Volume [mm^3],Error,Dice Coefficient,120 CEM43 Volume [mm^3],Error,Dice Coefficient,80 CEM43 Volume [mm^3],Error,Dice Coefficient"

cd "$analysis_folder" 
echo "$line" > Volume-and-DSC-report.csv


cd ${base}/Patient_Files

# Case 1: No inputs, do all patients
if [[ "$#" -eq 0 ]]						# zero input if block
then

	for FOLDER in 9*/ 					# etects directories or files that start with a 9
	do 
   	 	if [[ -d ${FOLDER} ]]				# Check that the found object is a directory
		then
			folder=$(echo "${FOLDER//[!0-9]/}") 	# Extract all numbers from caught object
			# Need to see if files have been processed
			echo $folder

			if  [[ -d $base/Patient_Files/$folder/Processed_Files ]]
			then
				makeReport $folder $base
			else
				echo Thermal dose maps have not been processed into lesion masks for patient $folder

			fi
		fi
		cd ${base}/Patient_Files
	done
			


# Case 2: Generate report for only one patient
elif [[ "$#" -eq 1 ]]
then 
   	if [[ -d $1 ]]						# Check that the found object is a directory
	then
		folder=$(echo "${1//[!0-9]/}") 			# Extract all numbers from caught object
		# Need to see if files have been processed

		if  [[ -d $base/Patient_Files/$folder/Processed_Files ]]
		then
			makeReport $folder $base
		else
			echo Thermal dose maps have not been processed into lesion masks for patient $folder
			exit 12
		fi
	fi



#Case 3: Process a range of patients
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
		echo $file
   	 	cd ${base}/Patient_Files

		if [[ -d ${file} ]]					# Check that the found object is a directory
		then
			folder=$(echo "${file//[!0-9]/}") 		# Extract all numbers from caught object
			# Need to see if files have been processed
			
			if [[ $folder -gt 0 ]] && [[ $folder -lt 10000 ]]
			then
				exit 12
			fi	

			if  [[ -d $base/Patient_Files/$folder/Processed_Files ]]
			then
				makeReport $folder $base
			else
				echo Thermal dose maps have not been processed into lesion masks
				exit 12
			fi
		fi
	done
# End case 3
else
	echo Please enter 0, 1, or 2 inputs

fi

########	End Main Function			#############################
