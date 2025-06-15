conda create -n ncbi_datasets #create a conda environment
conda activate ncbi_datasets #activate it
conda install -c conda-forge ncbi-datasets-cli #install the datasets conda package

conda activate ncbi_datasets

#create your gene input file. It should be in .txt format. No headers, only NCBI compatible gene symbols. 

#if the file is made in windows and then imported in linux system, it has to made compatible with linux system
conda install -c conda-forge dos2unix
dos2unix gene_input_list.txt

#get the path of datasets, which you have to paste in the shellscript
which datasets

nano fetch_orthologs.sh
#opens text editor nano to create or edit file named "fetch_orthologs.sh" .sh indicates it is a shellscript. 

#paste the following commands in the window

########################################
#!/bin/bash
#this shebang line tells OS to use bash shell to run this script. It is required at the top of executable scripts.

# Define the input file containing gene symbols
INPUT_FILE="gene_input_list.txt"

# Specify the full path to the datasets executable. It defines the absolute path the the "datasets" CLI tool downloaded from NCBI
DATASETS_PATH="/home/pranav/ncbi-datasets-cli/datasets" # <<< REPLACE WITH YOUR ACTUAL PATH

#Define the output directory. All downloaded ortholog files will be stored here.
OUTPUT_DIR="./ortholog_data"

# Create the output directory if it doesn't exist. The "-p" flag ensures it would not error if the directory already exists.
mkdir -p "$OUTPUT_DIR"

# Read each gene symbol from the input file and process it
while IFS= read -r gene_symbol; do  #IFS: Internal field seperator. Here it is space " ". reads one line from the input into the variable "gene_symbol". -r prevents interpretting backslashes.
  echo "Fetching orthologs for: $gene_symbol"

  # Construct the output file name for the current gene
  OUTPUT_FILENAME="${OUTPUT_DIR}/${gene_symbol}_orthologs.zip" #Defines where the output ZIP for each gene will be saved.

  # Run the datasets command to download orthologs using the full path
  "$DATASETS_PATH" download gene symbol "$gene_symbol" --ortholog vertebrates --filename "$OUTPUT_FILENAME" 
  #Tells the NCBI CLI to download gene by symbol, include ortholog in vertebrates, and save the output the named ZIP file.

  # Optional: Add a small delay to avoid overwhelming the server (e.g., 1 second)
  sleep 1

done < "$INPUT_FILE" 
#ends the while loop. The < "$INPUT_FILE" tells the loop to read from your gene list. 

echo "Ortholog fetching complete. All data saved in the '$OUTPUT_DIR' directory."
###############################

#Ctrl + O to write(save) the file.
#Enter to confirm the file name.
#Ctrl + X to exit nano

chmod +x fetch_orthologs.sh #gives the file executable permissions so that it can be run as a program.

./fetch_orthologs.sh #./ tells the shell to execute the script from current directory.




