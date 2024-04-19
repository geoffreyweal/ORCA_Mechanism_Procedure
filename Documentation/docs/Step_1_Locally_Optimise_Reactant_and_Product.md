# Step 1: Locally Optimise Reactant and Product

!!! tip

    [Download the template folder for this step from here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Templates) and work on the files in the template folder as you read through this step.

First we need to locally optimize the reactants and products. To do this, [make a ``Reactant`` folder and a ``Product`` folder](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Templates/Step1_Geo_Opt), and add to each folder the ``.inp`` file for performing local optimisations. Make sure you include the following into your ``.inp`` files for both the reactant and product:

```
!OPT FREQ TightOPT TightSCF defgrid2
```

Here, we perform a geometry optimisation to optimize the system. The tags here indicate you want to do the following: 

* ``OPT``: Indicates you want ORCA to perform a local optimisation. 
* ``FREQ``: Indicates you want ORCA to calculation the vibrational frequency for your molecule. 
    * This is used to verify that your optimised structure is indeed a local minimum. 
    * This will also give you the Gibbs free energy for your molecule that you (may) want to report as your energy. 
* ``TightOPT``: Tells ORCA to tighten the convergence criteria for each geometric step. See the [ORCA 5.0.4 Manual](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/orca_manual_5_0_4.pdf), page 20 for more info.
* ``TightSCF``: Tells ORCA to tighten the convergence criteria for each electronic step. 
* ``defgrid2``: Indicates how fine we want the intergration grid to be (This is the default).

!!! note "**NOTE 1**"

    I have set the electronic optimisation steps to be tight (``TightSCF``). This is just to make sure the electronic are well converged, but it may be a bit extreme. 

    * If you have problems, you can try using the normal convergence criteria for the electronic steps (``NormalSCF``)

!!! note "**NOTE 2**"

    [Click here](https://sites.google.com/site/orcainputlibrary/numerical-precision?authuser=0) for more information about other electronic convergence and interaction grid settings (besides ``TightSCF`` and ``defgrid2``)

An example of the complete ``orca.inp`` file for a local optimisation ORCA job is given below (also [located here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step1_Geo_Opt/Products/orca.inp)): 

```title="Example orca.inp file used to geometrically optimise the product structure"
!B3LYP DEF2-TZVP D3BJ 
!OPT FREQ TightOPT TightSCF defgrid2
%SCF
    MaxIter 2000       # Here setting MaxIter to a very high number. Intended for systems that require sometimes 1000 iterations before converging (very rare).
    DIISMaxEq 5        # Default value is 5. A value of 15-40 necessary for difficult systems.
    directresetfreq 15 # Default value is 15. A value of 1 (very expensive) is sometimes required. A value between 1 and 15 may be more cost-effective.
END
%CPCM EPSILON 6.02 REFRAC 1.3723 END
%PAL NPROCS 32 END
%maxcore 2000 # This indicates you want ORCA to use only 2GB per core maximum, so ORCA will use only 2GB*32=64GB of memory in total.
* xyzfile 1 1 product.xyz 

```

!!! note "**NOTE 3**"

    Make sure you include a newline or two at the end of your ``orca.inp`` file, otherwise ORCA will get confused and not run.

Here, ``xyzfile`` allows you to import an xyz file into ORCA. You can add the xyz data directly in the ``.inp`` file, but I find having a separate ``xyz`` file is better because this allow you to look at the xyz file in a gui like in [atomic simulation environment (ASE)](https://wiki.fysik.dtu.dk/ase/ase/gui/basics.html). 

* Include the ``xyz`` files of your reactant and product molecules in the ``Reactant`` and ``Product`` folders, respectively. 
* If your reactants or product contain more than one molecule/chemical system, split them up and localise them individually in their own individual folders. 

Submit the job to slurm (if you use slurm) using the [``submit.sl`` file](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step1_Geo_Opt/Products/submit.sl):

```bash title="Example of a submit.sl file for submitting ORCA jobs to slurm"
#!/bin/bash -e
#SBATCH --job-name=A3_Step1_Products
#SBATCH --ntasks=32
#SBATCH --mem=72GB
#SBATCH --partition=large
#SBATCH --time=3-00:00     # Walltime
#SBATCH --output=slurm-%j.out      # %x and %j are replaced by job name and ID
#SBATCH --error=slurm-%j.err
#SBATCH --nodes=1 # OpenMPI can have problems with ORCA over multiple nodes sometimes, depending on your system.

# Load ORCA
module load GCC/9.2.0
module load ORCA/5.0.3-OpenMPI-4.1.1

# ORCA under MPI requires that it be called via its full absolute path
orca_exe=$(which orca)

# Don't use "srun" as ORCA does that itself when launching its MPI process.
${orca_exe} orca.inp > output.out

```

!!! note "**NOTE 4**"

    While ORCA has been told to use ``maxcore`` = 2000 (MB) * 32 = 64 GB in the ``.inp`` file, we have told slurm to reserve ``72GB`` of memory. It is a good idea to give your ORCA job a few GBs of RAM extra in slurm just in case ORCA accidentally goes over it's allocated RAM. Here, I have abitrarily given this job 8 GB more RAM just in case. 

### What to do if you have more than one reactant (or product)

Sometimes if you have more reactant (or product), you may also need to obtain the energy of the reactants (or products) when they are separated. Often you can just calculate these separately as their own ORCA calculations. However, for systems involving metals in particular, it is a good idea to check if there is a transition state for a metal coordinating to a ligand. There probably should not be a transition state, but is good to check. In this case, read the [ORCA Coalesce Reactants Procedure](https://github.com/geoffreyweal/ORCA_Coalesce_Reactants_Procedure) tutorial to understand how to check this. 


## Outputs from ORCA

While ORCA is running, it will output several files, including an ``output.out`` file, an ``orca.xyz`` file, and an ``orca_trj.xyz`` file.

* ``output.out``: This file contains the details about how ORCA ran. This includes the vibrational frequency data to check if the locally optimised structure is in fact a local minimum.
* ``orca.xyz``: This is the locally optimised molecule. 
* ``orca_trj.xyz``: This file shows how ORCA locally optimised the molecule. Type ``viewORCA opt`` into the terminal to view how the molecule was optimised, including an energy profile. 

**Once ORCA has finished, you should do the following checks**:

### Check 1: Look at your molecule and the energy profile and make sure it looks ok

The first thing to do is to look at your molecule and check if it looks sensible with your chemical intuition. You can do this by opening up the ``orca.xyz`` in your favourite GUI. I like to use atomic simulation environment (ASE). To look at the molecule and its energy profile:

1. Open a new terminal
2. ``cd`` into the optimisation folder
3. Type ``viewORCA opt`` into the terminal

```bash
# cd into your optimisation folder
cd ORCA_Mechanism_Procedure/Examples/Step1_Geo_Opt/Products

# View the optimisation 
viewORCA opt
```

!!! note "**NOTE 1**"

    If ``viewORCA opt`` does not work, type ``ase gui orca_trj.xyz`` into the terminal instead of ``viewORCA opt``. 

!!! note "**NOTE 2**"

    ``viewORCA opt`` will also create a xyz file called ``OPT_images.xyz`` that you can copy to your computer if you are using a high-capacity computer (HPC) system and view on your own computer. 
    
    * If you just want to create the ``OPT_images.xyz`` file and not view the optimisation, type into the terminal ``viewORCA opt --view False`` (which will create the ``OPT_images.xyz`` file). 

Here, you want to **check that the molecule looks ok from your chemical and physical intuition**. Here is an example of what the optimised molecule looks like (the ``orca.xyz`` file here). If we look at the initial molecule geometry (by typing ``viewORCA opt`` or ``ase gui product.xyz`` into the terminal), we can see how the molecule has changed after being geometrically optimised: 

<figure markdown="span">
    <img src="Figures/1_Opt/opt_example.png?raw=true" alt="Opt Image" width="1200"/>
    <figcaption>Image of optimisation process by ORCA.</figcaption>
</figure>

``viewORCA opt`` will also show you the energy profile for this optimisation. 

<figure markdown="span">
    <img src="Figures/1_Opt/opt_energy.png?raw=true" alt="Opt Energy Profile" width="700"/>
    <figcaption>Energy profile of optimisation process by ORCA.</figcaption>
</figure>

### Check 2: Did the geometry optimisation converge successfully

You want to look for a table in the [``output.out`` file](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step1_Geo_Opt/Products/output.out#L17079) for a table with the title ``Geometry convergence``. There will be many of these tables, as one is given for each geometric step performed. 

* **You want to look at the [last ``Geometry convergence`` table](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step1_Geo_Opt/Products/output.out#L17079) in the output file** as this will display the information for the latest geometrically optimised step. An example for the ``Products`` is given below:

```title="Extract of geometry convergence information from the ORCA output file"
                                .--------------------.
          ----------------------|Geometry convergence|-------------------------
          Item                value                   Tolerance       Converged
          ---------------------------------------------------------------------
          Energy change      -0.0000006152            0.0000010000      YES
          RMS gradient        0.0000177282            0.0000300000      YES
          MAX gradient        0.0000821491            0.0001000000      YES
          RMS step            0.0004097121            0.0006000000      YES
          MAX step            0.0015679250            0.0010000000      NO
          ........................................................
          Max(Bonds)      0.0003      Max(Angles)    0.05
          Max(Dihed)        0.09      Max(Improp)    0.00
          ---------------------------------------------------------------------

       The energies and gradients are converged
       and the convergence on bond distances, angles, dihedrals and impropers
       is acceptable.
       Convergence will therefore be signaled now


                    ***********************HURRAY********************
                    ***        THE OPTIMIZATION HAS CONVERGED     ***
                    *************************************************
```

In this example, you can see that the majority of the items of interest have converged, and ORCA has happy that the convergence criteria have been met. ORCA also tells you this by giving you a ``HURRAY`` message as well as a ``THE OPTIMIZATION HAS CONVERGED`` message (as you can see in above). 

### Check 3: Does the molecule have any non-negative vibrational frequencies

After performing a local optimisation, it is important that you look at the vibrational frequencies that are calculated. These are the frequencies that you could see in an IR or Raman spectra. You want to look through your [ORCA ``output.out`` file](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step1_Geo_Opt/Products/output.out#L18756) for a heading called ``VIBRATIONAL FREQUENCIES``. **We want to make sure that all the frequencies are non-negative**. This means we are in a local energy well. 

* If one or more frequency is negative, this means we are not in a local minimum. In this case, you need to tighten the optimisation, or need to look at your molecule and see if any part of it structurally does not make sense with your chemical intuition. 

In the [example below (for ``Products``)](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step1_Geo_Opt/Products/output.out#L18756), you can see that there are no non-negative frequencies from the ``FREQ`` calculation, therefore we are in a local energy well: 

```title="Extract of vibrational frequency information from the ORCA output file"
-----------------------
VIBRATIONAL FREQUENCIES
-----------------------

Scaling factor for frequencies =  1.000000000  (already applied!)

   0:         0.00 cm**-1
   1:         0.00 cm**-1
   2:         0.00 cm**-1
   3:         0.00 cm**-1
   4:         0.00 cm**-1
   5:         0.00 cm**-1
   6:        52.20 cm**-1
   7:        71.30 cm**-1
   8:       146.78 cm**-1
   9:       226.53 cm**-1
  10:       282.60 cm**-1
  11:       302.99 cm**-1
  12:       392.29 cm**-1
  13:       402.58 cm**-1
  14:       414.78 cm**-1
  15:       473.15 cm**-1
  16:       495.75 cm**-1
  17:       585.93 cm**-1
  18:       628.71 cm**-1
  19:       678.81 cm**-1
  20:       709.76 cm**-1
  21:       778.78 cm**-1
  22:       797.94 cm**-1
  23:       810.91 cm**-1
  24:       844.28 cm**-1
  25:       953.22 cm**-1
  26:       978.70 cm**-1
  27:       996.50 cm**-1
  28:      1019.06 cm**-1
  29:      1030.63 cm**-1
  30:      1046.65 cm**-1
  31:      1102.99 cm**-1
  32:      1137.60 cm**-1
  33:      1187.17 cm**-1
  34:      1210.13 cm**-1
  35:      1237.46 cm**-1
  36:      1309.92 cm**-1
  37:      1358.89 cm**-1
  38:      1377.61 cm**-1
  39:      1480.76 cm**-1
  40:      1514.47 cm**-1
  41:      1543.18 cm**-1
  42:      1608.95 cm**-1
  43:      1633.11 cm**-1
  44:      1647.22 cm**-1
  45:      1845.64 cm**-1
  46:      3184.30 cm**-1
  47:      3186.78 cm**-1
  48:      3189.57 cm**-1
  49:      3192.88 cm**-1
  50:      3203.72 cm**-1
  51:      3209.16 cm**-1
  52:      3487.08 cm**-1
  53:      3585.59 cm**-1
```

## Troubleshooting Geometric Optimisation (``Opt``) Calculations

Here are some troubleshooting tips for performing this optimisation step.

!!! note

    Also read more about electronic convergence issues that are commonly encountered during geometric optimisation jobs in from the ORCA Input Library by [clicking here](https://sites.google.com/site/orcainputlibrary/scf-convergence-issues).

    * The [ORCA Input Library](https://sites.google.com/site/orcainputlibrary) is generally a great source of information about performing calculations in ORCA.

!!! info

    If you have any issues about this step, [raise a ``New issue`` at the Issues section by clicking here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/issues).


### ORCA would not ``converge but reached the maximum number of optimization cycles.``

A common problem that can arise is the message from ORCA saying that it could not converge because it had reached the maximum number of optimisation cycles.

```
    ----------------------------------------------------------------------------
                                   ERROR !!!
       The optimization did not converge but reached the maximum
       number of optimization cycles.
       As a subsequent Frequencies calculation has been requested
       ORCA will abort at this point of the run.
       Please restart the calculation with the lowest energy geometry and/or
       a larger maxiter for the geometry optimization.
    ----------------------------------------------------------------------------
```

This indicates that the electronic step could not converged for the last geometric step. This means that ORCA could not find a way to optimise the molecular orbitals for this geometric step. This is a very common issue. In this case, you can replace your initial structure with the last optimised structure given by ORCA. Do this by changing the name of the input file in the ``orca.inp`` file from ``reactant.xyz`` to ``orca.xyz``

```bash
* xyzfile 1 1 orca.xyz 
```

**However**, before proceeding you should check the initial structure you gave to ORCA. 

* The ``converge but reached the maximum number of optimization cycles.`` problem can arises because the initial structure you gave to ORCA was not a good starting point. 
* ORCA requires that you apply your chemical intuition to your system before you run it. Otherwise it can fail. 

For example, consider that we want to optimise the following chemical system, where Cu<sup>+</sup> coordinates to the nitrogen in benzylamine: 

<figure markdown="span">
    <img src="Figures/Troubleshooting/Opt_Calculations/Electronic_Convergence/reactant_opt.png?raw=true" alt="Optimised Reactant" width="600"/>
    <figcaption>Optimised Reactant</figcaption>
</figure>

If we wanted to obtain this chemical system, we would want to make sure that most of the atoms are roughly in a good bonding position. This is a good example of a good structure to begin with:

<figure markdown="span">
    <img src="Figures/Troubleshooting/Opt_Calculations/Electronic_Convergence/reactant.png?raw=true" alt="Initial Structure - Reactant" width="600"/>
    <figcaption>Initial Structure - Reactant</figcaption>
</figure>

This is an example of a structure that might have convergence issues because the Cu<sup>+</sup> atom is very far away from the nitrogen. Generally, it is best not to combine separate molecules/compounds in an ORCA calculations unless they are well separated and are not meant to come together for geometry optimisations. This does not apply to ``SCAN`` calculations, where you might want to separate two components from each other (For example, separate Cu<sup>+</sup> from benzylamine).

<figure markdown="span">
    <img src="Figures/Troubleshooting/Opt_Calculations/Electronic_Convergence/bad_reactant_structure.png?raw=true" alt="Initial Structure - Reactant - Not ideal" width="600"/>
    <figcaption>Initial Structure - Reactant - Not ideal</figcaption>
</figure>

In this case, it would be best to try using a better initial structure where the Cu atom is coordinated to the benzylamine molecule. 




