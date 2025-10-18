#!/bin/bash -e
#SBATCH --job-name=A3_S4B_Validate_TS_Backwards_Step
#SBATCH --ntasks=32
#SBATCH --mem-per-cpu=2500MB
#SBATCH --partition=genoa,milan
#SBATCH --time=3-00:00     # Walltime
#SBATCH --output=slurm-%j.out      # %x and %j are replaced by job name and ID
#SBATCH --error=slurm-%j.err
#SBATCH --nodes=1 # OpenMPI can have problems with ORCA over multiple nodes sometimes, depending on your system.
#SBATCH -A nesi99999

# Load ORCA
module load ORCA/6.1.0-f.0-OpenMPI-4.1.5

# ORCA under MPI requires that it be called via its full absolute path
orca_exe=$(which orca)

# Don't use "srun" as ORCA does that itself when launching its MPI process.
${orca_exe} orca.inp > output.out