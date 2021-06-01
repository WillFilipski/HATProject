#!/bin/bash
#SBATCH --mem=16G             # memory, roughly 2 times %mem defined in the input name.com file
#SBATCH --time=02-00:00       # expect run time (DD-HH:MM)
#SBATCH --cpus-per-task=16    # No. of cpus for the job as defined by %nprocs in the name.com file
module load gaussian/g16.c01
g16 < name.com                # g16 command, input: name.com, output: slurm-<jobid>.out by default
