#!/bin/bash

export MM_ERROR=
export ROOT_INCLUDE_PATH=${MM_ERROR}/include:$ROOT_INCLUDE_PATH
function MM_userdata(){
    INPUT_FILE="$(pwd)/"
    while [[ ${#} -gt 0 ]]; do
		key="$1"
		case $key in
			-o|--output)
				if [[ $2 != *".txt"* ]]; then
					if [[ ${#} -lt 2 ]]; then
						echo "[MM]: ${1} expected a value."
						return 0
					else
						echo "[MM]: the output file must be a .txt file."
						return 0
					fi
				fi
				INPUT_FILE+="$2"
				echo "[MM]: Outputing a base file of name == $INPUT_FILE"
				shift # past argument
				;;
			-h|--help)
				echo "[MM]: Returns a .txt file with variables needed to produce fcl file and node points"
				echo "[MM]:	-o|--output 	[output file in form of .txt]"

				return 0
		esac
		shift
	done
	echo "[MM]: Creating User Data file of name $INPUT_FILE"
    root -b -q -l "$MM_ERROR/include/execute_scripts/CreateUserData.cpp(\"$INPUT_FILE\")"
}

function MM_Init_Setup()
{
	INPUT_FILE=""
	GENIE_FCL=""
	NODE_FILE=""
	OUTPUT_FILE=""
	NUM_OF_THROWS=250
	CUSTOM_FCL=false
	while [[ ${#} -gt 0 ]]; do
		key="$1"
		case $key in
			-i|--input)
				if [ $(grep -c "GENIE_FILE:" $2) -eq 0]; then
					echo "[MM]: Something is missing ..."
					return 0
				fi
				INPUT_FILE+="$2"
				echo "[OPT]: Using input: $INPUT_FILE"
				shift # past argument
				;;
			--custom_fcl)
				CUSTOM_FCL=true
			;;
			-f|--fcl)
				if [[ $2 != *".fcl"* ]]; then
					echo "[MM]: need a .fcl"
					return 0
				fi
				GENIE_FCL+="$2"
				shift
				;;
			-n|--nodes)
				if [[ $2 != *".root"* ]]; then
					echo "[MM]: need a .root"
					return 0
				fi
				NODE_FILE+="$2"
				shift
				;;
			-t|--throws)
				NUM_OF_THROWS=$2
				shift
				;;
			-o|--output)
				if [[ $2 != *".root"* ]]; then
					echo "[MM]: ${1} expected a file in form of .root to store node points"
					return 0
				fi
				OUTPUT_FILE+="$2"
				echo "[MM]: Creating an output of $2 to store Throw hists"
				shift # past arguement
				;;
			-h|--help)
				echo "[MM]: Initial set-up --> requires the userdata file to be complete"
				echo "[MM]: Creates the fcl file necessary for NUSYSTEMATICS"
				echo "[MM]: Proceeds to create MAXIMUM necessary node points for spline computation for each event for each systematic"
				echo "[MM]: Finishes by creating a throw file containg ReWeight record for each systematic"
				echo "[MM]: Necessary for inputs: "
				echo "[MM]:	-i|--input		[User .txt file, generate by running ... and fill"
				echo "[MM]: -f|--fcl		[Wanted name for fcl file produced or Your own custom fcl if
																															--custom_fcl is applied]"
				echo "[MM]: -n|--nodes		[Wanted name for node point production]"
				echo "[MM]: -t|--throws		[Wanted number of throws, defaulted to 250]"
				echo "[MM]: -o|--output		[Wanted name for throw file production]"
				return 0
		esac
		shift
	done

	if [ $CUSTOM_FCL = false ] ; then
		root -b -q -l "$MM_ERROR/include/execute_scripts/CreateFCL.cpp(\"$INPUT_FILE\", \"$GENIE_FCL\")"
	fi
	root -b -q -l "$MM_ERROR/include/execute_scripts/CreateNodePoints.cpp(\"$INPUT_FILE\",\"$GENIE_FCL\",\"$NODE_FILE\")"

	root -b -q -l "$MM_ERROR/include/execute_scripts/CreateThrows_MultiSyst.cpp(\"$INPUT_FILE\", \"$GENIE_FCL\", \"$NODE_FILE\", \"$OUTPUT_FILE\", $NUM_OF_THROWS)"

}

function MM_Draw_txt(){
	 INPUT_FILE=""
  while [[ ${#} -gt 0 ]]; do
			key="$1"
			case $key in
				-o|--output)
					if [[ $2 != *".txt"* ]]; then
						if [[ ${#} -lt 2 ]]; then
							echo "[MM]: ${1} expected a value."
							return 0
						else
							echo "[MM]: the output file must be a .txt file."
							return 0
						fi
					fi
					INPUT_FILE+="$2"
					echo "[MM]: Outputing a base file of name == $INPUT_FILE"
					shift # past argument
					;;
				-h|--help)
					echo "[MM]: Returns a .txt file with variables needed to draw your Errorband!!!!"
					echo "[MM]:	-o|--output 	[output file in form of .txt]"

					return 0
			esac
		shift
		done
	echo "[MM]: Creating User Data file of name $INPUT_FILE"
 root -b -q -l "$MM_ERROR/include/execute_scripts/CreateDrawFile.cxx(\"$INPUT_FILE\")"
}


function MM_New_Draw(){
	USER_FILE=""
	OUTPUT_FILE=""
	NUM_OF_THROWS=250
	while [[ ${#} -gt 0 ]]; do
		key="$1"
		case $key in 
			-i|--input)
				if [[ $2 != *".txt"* ]]; then
					return 0		
				fi
				USER_FILE+="$2"
				shift 
				;;
		 -o|--output)
				if [[ $2 != *".root"* ]]; then
					echo "[MM]: ${1} expected a file in form of .root to save drawn errorbands"
					return 0
				fi
				OUTPUT_FILE+="$2"
				echo "[MM]: Creating an output of $2 to display errorband"
				shift # past arguement
				;;
		 -t|--throws)
				NUM_OF_THROWS=$2
				echo "[MM]: number of throws $2"
				shift
				;;
		 -h|--help)
				echo "[MM]: Drawing step for errorband production"
				echo "[MM]: -o|--output 	[Output for your errorband]"
				echo "[MM]: -i|--input   [User Draw txt document]"
				echo "[MM]: -t|--throws  [Number of throws]"
				return 0
			esac
		shift
		done
	root -b -q -l "$MM_ERROR/include/execute_scripts/CreateErrorBand_ALL.cxx(\"$USER_FILE\",\"$OUTPUT_FILE\", $NUM_OF_THROWS)"

}
		
				
