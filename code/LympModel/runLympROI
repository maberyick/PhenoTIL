#!/bin/bash
#SBATCH --job-name=LympIdentROI
#SBATCH -o outcome/LIR_%A_%a.out
#SBATCH -e outcome/LIR_%A_%a.err
#SBATCH --array=2-163
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=90G
#SBATCH --time=1:00:00

module load matlab/R2016b
matlab -nodisplay -r "fullLympIdent_ROI("$SLURM_ARRAY_TASK_ID");exit"