#! /bin/bash

base=$(pwd)
analysis_folder=${base}/Results #Place to place the report 

line="Patient,TMap,Standard Volume [mm^3],CEM240 Volume [mm^3],Error,Dice Coefficient,CEM230 Volume [mm^3],Error,Dice Coefficient,CEM220 Volume [mm^3],Error,Dice Coefficient,CEM210 Volume [mm^3],Error,Dice Coefficient,CEM200 Volume [mm^3],Error,Dice Coefficient,CEM160 Volume [mm^3],Error,Dice Coefficient,CEM120 Volume [mm^3],Error,Dice Coefficient,CEM80 Volume [mm^3],Error,Dice Coefficient"

#Place the report in the analysis folder
cd "$analysis_folder" 
echo "$line" > TotalReport.csv

#Case 1: No inputs, do patients 9002 to 9021

if [[ "$#" -eq 0 ]]
then
	for file in {9002..9021}
	do
	echo $file
		if [[ -d $base/Patient_Files/${file} ]] #Check if patients exist
		then
			cd "$base/Patient_Files/${file}/Processed_Files"
				
			for i in {1..2} #TMap
			do
				line="$file,TMap $i "
				cd "$base/Patient_Files/${file}/Processed_Files/TMap$i/Analysis_Files"

				# Get volume of standard lesion

				Standard="$(fslstats T1_lesion_mask_filled.nii.gz -V)"
				Standard_Volume=($(echo "$Standard" | tr ' ' '\n'))
				Std=${Standard_Volume[1]}
				line="$line,$Std"
				
				
	
				for ((var=240;var>=200;var-=10))
				do
					# Get volume of predicted lesion volume, 
					Predicted="$(fslstats Predicted-Lesion-Mask-${var}.nii.gz -V)"	
					Predicted_Volume=($(echo "$Predicted" | tr ' ' '\n'))
					Predict=${Predicted_Volume[1]}

					# Calculate error between predicted volume and standard volume
					Error=$(echo "($Predict-$Std)/$Std*100" | bc -l)
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
					Error=$(echo "($Predict-$Std)/$Std*100" | bc -l)
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
				echo "$line" >> TotalReport.csv		
			done #TMap loop
		fi #check if block
	done #Patient loop

# Case 2: Generate report for only one patient
elif [[ "$#" -eq 1 ]]
then
	if [[ -d $base/Patient_Files/${1} ]]
	then		
		for i in {1..2}
		do
			line="$1,TMap $i "
			cd "$base/Patient_Files/${1}/Processed_Files/TMap$i/Analysis_Files"
			
			# Get volume of standard lesion

			Standard="$(fslstats T1_lesion_mask_filled.nii.gz -V)"
			Standard_Volume=($(echo "$Standard" | tr ' ' '\n'))
			Std=${Standard_Volume[1]}

			line="$line,$Std"
			
			
			for ((var=240;var>=200;var-=10))
			do
				# Get volume of predicted lesion volume, 
				Predicted="$(fslstats Predicted-Lesion-Mask-${var}.nii.gz -V)"	
				Predicted_Volume=($(echo "$Predicted" | tr ' ' '\n'))
				Predict=${Predicted_Volume[1]}

				# Calculate error between predicted volume and standard volume
				Error=$(echo "($Predict-$Std)/$Std*100" | bc -l)
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
				Error=$(echo "($Predict-$Std)/$Std*100" | bc -l)
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
			echo "$line" >> TotalReport.csv		
		done #TMap loop
	fi #End block checking if file exists

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
		if [[ -d $base/Patient_Files/${file} ]]
		then		
			for i in {1..2}
			do
				line="$file,TMap $i "
				cd "$base/Patient_Files/${file}/Processed_Files/TMap$i/Analysis_Files"

				# Get volume of standard lesion

				Standard="$(fslstats T1_lesion_mask_filled.nii.gz -V)"
				Standard_Volume=($(echo "$Standard" | tr ' ' '\n'))
				Std=${Standard_Volume[1]}
				line="$line,$Std"

				for ((var=240;var>=200;var-=10))
				do
					# Get volume of predicted lesion volume, 
					Predicted="$(fslstats Predicted-Lesion-Mask-${var}.nii.gz -V)"	
					Predicted_Volume=($(echo "$Predicted" | tr ' ' '\n'))
					Predict=${Predicted_Volume[1]}
				
					# Calculate error between predicted volume and standard volume
					Error=$(echo "($Predict-$Std)/$Std*100" | bc -l)
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
					Error=$(echo "($Predict-$Std)/$Std*100" | bc -l)
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
				echo "$line" >> TotalReport.csv		
				cd "$base/Patient_Files/${file}/Processed_Files"
			done #TMap loop
		fi #end if block that checks if patient exists
	done #Patient loop

else
	echo Please enter 0, 1, or 2 inputs

fi
