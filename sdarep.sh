#!/bin/bash
#SBATCH --job-name=sdarep
#SBATCH --partition=compute
#SBATCH --time=84:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --ntasks=1
#SBATCH --input=none
#SBATCH --output=sda_%j.out
#SBATCH --error=sda_%j.err

module load R/3.3.2

d=$1
r=$2
m=$3
z=$4

Rscript runSDAreport.R $d $r $m $z

