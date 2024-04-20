# Step 4B: Check the Forwards and Backwards Molecules Converge using the ``TightOPT`` or ``NormalOPT`` tags

!!! tip

    [Download the template folder for this step from here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Templates) and work on the files in the template folder as you read through this step.

In [Step 4A](Step_4A_The_IRC_Method.md) we have found the local well that mechanistially connect thought to each other with our transition state using the ``TolMAXG`` and ``TolRMSG`` tags equivalent to the ``LooseOPT`` tag. However, it is best to make sure that our forwards and backwards steps converge using the ``TightOPT`` or ``NormalOPT`` tags, and perform a vibrational frequency calculation to confirm our molecules have fallen into a local energy well. 

* We will then compare this with our reactant and product molecules from [Step 1](../Step_1_Locally_Optimise_Reactant_and_Product.md) to make sure that this mechanistic step is in fact the mechanistic step we are wanting to get the transition state for. 

To do this, we will repeat [Step 1](../Step_1_Locally_Optimise_Reactant_and_Product.md) for our forwards and backwards molecules. To do this, make a ``Forwards`` folder and a ``Backwards`` folder, and add to each folder the ``.inp`` file for performing local optimisations. Make sure you include the following into your ``.inp`` files for both the forwards and backwards input files:

```
!OPT FREQ TightOPT TightSCF defgrid2
```

Here, we perform a geometry optimization to optimize the system. The tags here indicate you want to do the following: 

* ``OPT``: Indicates you want ORCA to perform a local optimisation. 
* ``FREQ``: Indicates you want ORCA to calculation the vibrational frequency for your molecule. This is used to verify that your optimised structure is indeed a local minimum. This will also give you the Gibbs free energy for your molecule that you (may) want to report as your energy. 
* ``TightOPT``: Tells ORCA to tighten the convergence criteria for each geometric step. See ORCA 5.0.4 Manual, page 20 for more info.
* ``TightSCF``: Tells ORCA to tighten the convergence criteria for each electronic step. 
* ``defgrid2``: Indicates how fine we want the intergration grid to be (This is the default)

Also include the ``xyz`` files of your forwards (``orca_IRC_F.xyz``) and backwards (``orca_IRC_B.xyz``) molecules from [Step 4A](Step_4A_The_IRC_Method.md) in your ``Forwards`` and ``Backwards`` folders, respectively.

An example of the complete ``orca.inp`` file for a local optimisation ORCA job is given below (also [located here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4B_Validate_Forwards_and_Backwards/Forwards/orca.inp)): 

```title="Example of a ORCA input file for the local optimisation calculation upon the forwards step"
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
* xyzfile 1 1 orca_IRC_F.xyz

```

## Outputs from ORCA

When ORCA is running, it will output several files, including an ``output.out`` file, an ``orca.xyz`` file, and an ``orca_trj.xyz`` file.

* ``output.out``: This file contains the details about how ORCA ran. This includes the vibrational frequency data to check if the locally optimised structure is in fact a local minimum.
* ``orca.xyz``: This is the locally optimised molecule. This is the file that is called ``reactant_opt.xyz`` from here on out. 
* ``orca_trj.xyz``: This file shows how ORCA locally optimised the molecule. Type ``viewORCA opt`` into the terminal to view how the molecule was optimised, including an energy profile. 

Once ORCA has finished, you should do the following checks. These are the same checks as we performed in [Step 1](../Step_1_Locally_Optimise_Reactant_and_Product.md) (show is an example for the ``Forwards`` step, also repeat this process on the ``Backwards`` step): 

### Check 1: Look at your molecule and the energy profile and make sure it looks ok

The first thing to do is to look at your molecule and check if it looks sensible with your chemical intuition. You can do this by opening up the ``orca.xyz`` in your favourite GUI. I like to use atomic simulation environment (ASE). To look at the molecule and its energy profile:

1. Open a new terminal
2. ``cd`` into the optimisation folder
3. Type ``viewORCA opt`` into the terminal

```bash
# cd into your optimisation folder
cd ORCA_Mechanism_Procedure/Examples/Step4B_Validate_Forwards_and_Backwards/Forwards

# View the optimisation 
viewORCA opt
```

!!! note "**NOTE 1**"

    If ``viewORCA opt`` does not work, type ``ase gui orca_trj.xyz`` into the terminal instead of ``viewORCA opt``. 

!!! note "**NOTE 2**"

    ``viewORCA opt`` will also create a xyz file called ``OPT_images.xyz`` that you can copy to your computer if you are using a high-capacity computer (HPC) system and view on your own computer. 

    * If you just want to create the ``OPT_images.xyz`` file, type into the terminal ``viewORCA opt --view False`` (which will create the ``OPT_images.xyz`` file without showing the ``ase gui`` window). 

Here, you want to **check that this molecule looks like either the product or reactant**. In this example, we can see that this molecule is equivalent to the product, where the Cu has inserted itself into the C-H bond: 

<figure markdown="span">
    <img src="../Figures/4B_Opt/Opt_example.png?raw=true" alt="Opt Image" width="1200"/>
    <figcaption>Image of the optimisation calculation upon the forward state</figcaption>
</figure>

``viewORCA opt`` will also show you the energy profile for this optimisation. 

<figure markdown="span">
    <img src="../Figures/4B_Opt/Opt_energy.png?raw=true" alt="Opt Energy Profile" width="700"/>
    <figcaption>Energy Profile of the optimisation calculation upon the forward state</figcaption>
</figure>

### Check 2: Did the geometry optimisation converge successfully

You want to look for a table in the [ORCA ``output.out`` file](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4B_Validate_Forwards_and_Backwards/Forwards/output.out#L12480) for a table with the title ``Geometry convergence``. There will be many of these tables, as one is given for each geometric step performed. You want to look at the last ``Geometry convergence`` table as this will give the detailed for the latest geometrically optimised step. An example for the ``Forwards`` is given below:

```
                                .--------------------.
          ----------------------|Geometry convergence|-------------------------
          Item                value                   Tolerance       Converged
          ---------------------------------------------------------------------
          Energy change      -0.0000002764            0.0000010000      YES
          RMS gradient        0.0000138184            0.0000300000      YES
          MAX gradient        0.0000877801            0.0001000000      YES
          RMS step            0.0002032624            0.0006000000      YES
          MAX step            0.0010942793            0.0010000000      NO
          ........................................................
          Max(Bonds)      0.0006      Max(Angles)    0.03
          Max(Dihed)        0.03      Max(Improp)    0.00
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

After performing a local optimization, it is important that you look at the vibrational frequencies that were calculated in the [ORCA output file](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4B_Validate_Forwards_and_Backwards/Forwards/output.out#L14172). These are the frequencies that you could see in an IR or Raman spectra. You want to look through your ``.out`` file for a heading called ``VIBRATIONAL FREQUENCIES``. **We want to make sure that all the frequencies are non-negative**. This means we are in a local energy well. If one or more frequency is negative, this means we are not in a local minimum. In this case, you need to tighten the optimization, or need to look at your molecule and see if any part of it structurally does not make sense with your chemical intuition. 

In the [example below (for ``Forwards``)](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4B_Validate_Forwards_and_Backwards/Forwards/output.out#L14172), you can see that there are no non-negative frequencies from the ``FREQ`` calculation, therefore we are in a local energy well: 

```
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
   6:        54.16 cm**-1
   7:        71.96 cm**-1
   8:       147.41 cm**-1
   9:       228.29 cm**-1
  10:       282.50 cm**-1
  11:       302.87 cm**-1
  12:       392.52 cm**-1
  13:       402.94 cm**-1
  14:       415.05 cm**-1
  15:       473.02 cm**-1
  16:       495.91 cm**-1
  17:       586.24 cm**-1
  18:       628.69 cm**-1
  19:       679.01 cm**-1
  20:       708.85 cm**-1
  21:       778.84 cm**-1
  22:       798.28 cm**-1
  23:       811.07 cm**-1
  24:       844.48 cm**-1
  25:       953.61 cm**-1
  26:       979.08 cm**-1
  27:       996.60 cm**-1
  28:      1019.09 cm**-1
  29:      1030.67 cm**-1
  30:      1046.72 cm**-1
  31:      1103.08 cm**-1
  32:      1138.13 cm**-1
  33:      1187.13 cm**-1
  34:      1210.47 cm**-1
  35:      1237.89 cm**-1
  36:      1310.15 cm**-1
  37:      1358.96 cm**-1
  38:      1378.00 cm**-1
  39:      1480.82 cm**-1
  40:      1514.56 cm**-1
  41:      1543.31 cm**-1
  42:      1608.99 cm**-1
  43:      1633.23 cm**-1
  44:      1647.50 cm**-1
  45:      1846.29 cm**-1
  46:      3184.34 cm**-1
  47:      3186.87 cm**-1
  48:      3189.62 cm**-1
  49:      3192.92 cm**-1
  50:      3203.74 cm**-1
  51:      3209.18 cm**-1
  52:      3487.40 cm**-1
  53:      3585.97 cm**-1
```

## Example of an issue with Step 4 in this case, but all is well.

In this example, the optimised reactant from Step 1 looks like this:

<figure markdown="span">
    <img src="../Figures/4_Issue_but_Fine_Example/1_Reactant.png?raw=true" alt="Optimised reactant" width="600"/>
    <figcaption>Optimised reactant</figcaption>
</figure>

However, we get the following for the backwards structure from step 4A.

<figure markdown="span">
    <img src="../Figures/4_Issue_but_Fine_Example/4A_Backwards.png?raw=true" alt="Backwards structure" width="600"/>
    <figcaption>Backwards structure</figcaption>
</figure>

This is fine because the IRC is set by default with loose convergence criteria. These are the best settings for 4A, otherwise it takes forever to complete the IRC process. This is the reason for step 4B, we then tighten the converged with a regular geometric optimisation. By doing this, we get the following for the tightly converged backwards step.

<figure markdown="span">
    <img src="../Figures/4_Issue_but_Fine_Example/Comparison.png?raw=true" alt="Compare optimisations" width="1200"/>
    <figcaption>Compare optimisations</figcaption>
</figure>

We see that the tightly converged backwards structure from 4B gives a similar structure to the converged reactant from step 1, so this is great.

One problem however is that the [backwards structure from Step 4B did not converge](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4B_Validate_Forwards_and_Backwards/Backwards/output.out#L32808). However, as we have mentioned this structure is very similar to the optimised reactant structure in step 1. 

* We could retry this calculation from the last geometric step from step 4B, as it is common that ORCA will fail for various reason and restarting ORCA sorts everything out
* However, because the backwards structure we got from step 4B is pretty much the same as the optimised reactant from step 1, I would be pragmatic and be happy that step 4B backwards gave us the result we were looking for. 

## Troubleshooting the geometric optimisation (``Opt``) calculation

See the [Troubleshooting Geometric Optimisation Calculations](../Step_1_Locally_Optimise_Reactant_and_Product.md#troubleshooting-geometric-optimisation-opt-calculations) page for troubleshooting tips for geoemtric optimisations.






