#!/bin/bash -e
#SBATCH --job-name=A3_S4B_Validate_TS_Forwards_Step
#SBATCH --ntasks=32
#SBATCH --mem=72GB
#SBATCH --partition=long
#SBATCH --time=10-00:00     # Walltime
#SBATCH --nodes=1
#SBATCH --output=slurm-%j.out      # %x and %j are replaced by job name and ID
#SBATCH --error=slurm-%j.err
#SBATCH --nodes=1 # OpenMPI can have problems with ORCA over multiple nodes sometimes, depending on your system.

# Load ORCA
#module load GCC/9.2.0 #                <-- Originally used this, but try using ORCA/5.0.4 from now on.
#module load ORCA/5.0.3-OpenMPI-4.1.1 # <-- Originally used this, but try using ORCA/5.0.4 from now on.
module load GCC/12.3.0
module load ORCA/5.0.4-OpenMPI-4.1.5

# ORCA under MPI requires that it be called via its full absolute path
orca_exe=$(which orca)

# Don't use "srun" as ORCA does that itself when launching its MPI process.
${orca_exe} orca.inp > output.out
