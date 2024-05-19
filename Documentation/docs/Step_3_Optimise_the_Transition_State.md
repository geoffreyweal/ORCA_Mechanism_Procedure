# Step 3: Optimise the Transition State

!!! tip

    Download the template folder for this step by clicking the button below and work on the files in the template folder as you read through this tutorial. 

    [Download Templates.zip :octicons-download-24:](Files/Templates.zip){ .md-button .md-button--primary :download }

While your SCAN or NEB calculation will have done a good job at finding the transition state, it is a good idea to perform a transition state geometry optimisation to make sure that your transition state lies on the saddlepoint as best as possible. 

To do this, we will optimise the transition state using the ``OptTS`` tag: 

* The ``OptTS`` method is designed to find the most optimal transition state by allowing the molecule to follow the eigenvector (vibrational mode) for the most negative eigenvalue (frequency).

To perform a ``OptTS`` calculation, we include the following line in the ``orca.inp``: 

```
!OptTS NumFreq TightOPT TightSCF defgrid2
```

The tags here indicate the following: 

* ``OptTS``: Indicates that we want to optimise the molecule towards the transition state
* ``NumFreq``: We want to calculate the numerical frequency after the optimisation process to make sure that our transition state only has one negative vibrational frequency (transition states are defined as the lowest energy point between two local minima that has only 1 negative vibrational frequency). 
    * We are using ``NumFreq`` rather than ``Freq``  (analytically calculated vibrational frequency) because of the ``GEOM`` settings below (I think, based on the [tutorial here](https://sites.google.com/site/orcainputlibrary/geometry-optimizations/tutorial-saddlepoint-ts-optimization-via-relaxed-scan#h.pnxa1btinh0w))

We also include the following in our ``inp`` file: 

```
%GEOM
    Calc_Hess true # Calculate Hessian in the beginning
    NumHess true   # Request numerical Hessian (analytical not available)
    Recalc_Hess 1  # Recalculate the Hessian for every step
END
```

The reason for these settings is because we want to refine the transition state without converging towards a different saddlepoint unexpectly. This can happen if the Hessian is slightly off, which can happen when using the Hessian approximation methods commonly used in computational chemistry applications.

* The Hessian is the second derivative of the potential energy surface (PES), equivalent to the curvature of the PES. It is used to make a desision about how to modify your chemical system so you gets closer to a converged system. It needs to be obtained for each geometric step you perform
* Calculating the full hessian is very computationally expensive, so commonly approximations are made so that the full hessian does not need to calculated after each geometric step. 
* In this case, I have chosen to calculate the full hessian after each step because I assume I am near the transition state after the SCAN/NEB, and want to make sure it doesn't deviate from converging. This is probably overdoing it however and not completely necessary. 
* From the [tutorial here](https://sites.google.com/site/orcainputlibrary/geometry-optimizations/tutorial-saddlepoint-ts-optimization-via-relaxed-scan#h.pnxa1btinh0w), they recalculate the full hessian after 5 geometric step.

!!! note

    See the [tutorial here](https://sites.google.com/site/orcainputlibrary/geometry-optimizations/tutorial-saddlepoint-ts-optimization-via-relaxed-scan#h.pnxa1btinh0w) for a reference for these settings

!!! info 

    For all other ORCA calculations such as geometric optimisations, approximations to the Hessian are general helpful and are recommended/set by default. 

The full ``orca.inp`` file for this example is given below (also [located here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step3_Opt_TS/orca.inp)):

```title="Example of a ORCA input file for a transition state optimisation calculation"
!B3LYP DEF2-TZVP D3BJ
!OptTS NumFreq TightOPT TightSCF defgrid2
%SCF
    MaxIter 2000       # Here setting MaxIter to a very high number. Intended for systems that require sometimes 1000 iterations before converging (very rare).
    DIISMaxEq 5        # Default value is 5. A value of 15-40 necessary for difficult systems.
    directresetfreq 15 # Default value is 15. A value of 1 (very expensive) is sometimes required. A value between 1 and 15 may be more cost-effective.
END
%CPCM EPSILON 6.02 REFRAC 1.3723 END
%PAL NPROCS 32 END
%maxcore 2000
%GEOM
    Calc_Hess true # Calculate Hessian in the beginning
    NumHess true # Request numerical Hessian (analytical not available)
    Recalc_Hess 1  # Recalculate the Hessian for every step
END
* xyzfile 1 1 orca.073.xyz

```

## Outputs from ORCA

ORCA will create a number of files. These are the imporant ones to looks at for optimising the transition state geometry: 

* ``output.out``: The output file, which will tell you if the transition state converged or not.
* ``orca.xyz``: This is the transition state found (if convergence was successful)
* ``orca_trj.xyz``: This is the trajectory file that indicates the steps for how the calculation proceeded. 

Once ORCA has finished, you want to do the following checks.

### Check 1: Look at your transition state structure and the energy profile and make sure it looks ok

Just like in [Step 1 for the reactants and products](Step_1_Locally_Optimise_Reactant_and_Product.md), you also want to look at your transition state and make sure it makes sense to you. 

!!! tip "IMPORTANT"

    This is a very important check, as it is very possible that ORCA goes off track when locating the transition state. This is a problem not just for ORCA, but for any computational chemistry software. 

You can check the transition state by opening up the ``orca.xyz`` file. You can do this in ASE by:

1. Opening a new terminal
2. ``cd`` into the optimisation folder
3. Type ``ase gui orca.xyz`` into the terminal

```bash
# cd into your trasnition state optimisation folder
cd ORCA_Mechanism_Procedure/Examples/Step3_Opt_TS

# View the trasnrtiion state 
ase gui orca.xyz
```

This is what I got for this example (see below). 

* When comparing this transition state to the reactants and products, I can see that the hydrogen atom attached to the Cu atom has moved closer to the C atom.
* For this reason, I am happy with this transition state.

<figure markdown="span">
    <img src="Figures/3_OptTS/optTS_example.png?raw=true" alt="OptTS Example" width="600"/>
    <figcaption>Example of an optimised transition state</figcaption>
</figure>

### Check 2: Did the transition state converge successfully

Just like when we were [checking convergence of the product and reactant in Step 1](Step_1_Locally_Optimise_Reactant_and_Product.md#check-2-did-the-geometry-optimisation-converge-successfully), we want to find the geometry convergence table from the [ORCA output file](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step3_Opt_TS/output.out#L4273) and check that we are happy that the transition state converged properly, and we have got the ``HURRAY THE OPTIMIZATION HAS CONVERGED`` message: 

```title="Extract of geometry convergence information from the ORCA output file"
                                .--------------------.
          ----------------------|Geometry convergence|-------------------------
          Item                value                   Tolerance       Converged
          ---------------------------------------------------------------------
          Energy change      -0.0000006729            0.0000010000      YES
          RMS gradient        0.0000019507            0.0000300000      YES
          MAX gradient        0.0000087391            0.0001000000      YES
          RMS step            0.0000876984            0.0006000000      YES
          MAX step            0.0003670792            0.0010000000      YES
          ........................................................
          Max(Bonds)      0.0000      Max(Angles)    0.00
          Max(Dihed)        0.02      Max(Improp)    0.00
          ---------------------------------------------------------------------

                    ***********************HURRAY********************
                    ***        THE OPTIMIZATION HAS CONVERGED     ***
                    *************************************************
```

### Check 3: Check that we have only 1 negative vibrational frequency

We want to look at the frequency calculation results from the [ORCA output file](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step3_Opt_TS/output.out#L5989) and check that there is only 1 negative frequency. This tells us that we are on a saddlepoint on the potential energy landscape.

* Generally any negative frequency is good, but a negative frequency that is greater than $-100cm^{-1}$ is a good sign that the transition state is good. 
    * This is because the value of the frequency indicates the curvative of the transition state across the saddlepoint. The bigger the number, the steeper the energy decent on each side of the saddlepoint.
* A negative frequency between $-20cm^{-1}$ and $-100cm^{-1}$ is fine, but just beware you may have problems with [Step 4](Step_4_Validate_TS/index.md) for technical reasons.

[In the example below](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step3_Opt_TS/output.out#L5989), you can see we only have one negative vibrational frequency, so our transition state is good to go!

```title="Extract of vibrational frequency information from the ORCA output file"
-----------------------
VIBRATIONAL FREQUENCIES
-----------------------

Scaling factor for frequencies =  1.000000000 (already applied!)

   0:         0.00 cm**-1
   1:         0.00 cm**-1
   2:         0.00 cm**-1
   3:         0.00 cm**-1
   4:         0.00 cm**-1
   5:         0.00 cm**-1
   6:      -825.23 cm**-1 ***imaginary mode***
   7:        49.91 cm**-1
   8:        82.22 cm**-1
   9:       173.50 cm**-1
  10:       227.95 cm**-1
  11:       261.81 cm**-1
  12:       358.33 cm**-1
  13:       410.98 cm**-1
  14:       424.28 cm**-1
  15:       488.31 cm**-1
  16:       526.93 cm**-1
  17:       582.32 cm**-1
  18:       632.43 cm**-1
  19:       634.34 cm**-1
  20:       691.62 cm**-1
  21:       709.44 cm**-1
  22:       791.66 cm**-1
  23:       809.30 cm**-1
  24:       855.97 cm**-1
  25:       945.21 cm**-1
  26:       989.13 cm**-1
  27:      1016.46 cm**-1
  28:      1021.89 cm**-1
  29:      1049.78 cm**-1
  30:      1094.43 cm**-1
  31:      1105.44 cm**-1
  32:      1140.24 cm**-1
  33:      1182.51 cm**-1
  34:      1183.23 cm**-1
  35:      1208.66 cm**-1
  36:      1246.13 cm**-1
  37:      1336.77 cm**-1
  38:      1369.03 cm**-1
  39:      1435.39 cm**-1
  40:      1493.01 cm**-1
  41:      1533.74 cm**-1
  42:      1622.65 cm**-1
  43:      1623.55 cm**-1
  44:      1639.65 cm**-1
  45:      1778.18 cm**-1
  46:      3167.30 cm**-1
  47:      3174.81 cm**-1
  48:      3183.83 cm**-1
  49:      3192.85 cm**-1
  50:      3196.63 cm**-1
  51:      3201.45 cm**-1
  52:      3527.56 cm**-1
  53:      3628.36 cm**-1
```

###  Check 4 (Optional): Check how ORCA optimised your transition state

If you think there might be something funny happening, it is sometimes a good idea to check how ORCA optimised your transition state.

You can do this by changing directory into the transition state folder and typing ``viewORCA opt`` into the terminal. 

```bash
# change directory into the Step3_Opt_TS folder
cd ORCA_Mechanism_Procedure/Examples/Step3_Opt_TS

# View the geometry optimisation by ORCA in ASE using viewORCA opt
viewORCA opt
```

!!! note "**NOTE 1**"

    ``viewORCA opt`` will also create a xyz file called ``OPT_images.xyz`` that you can copy to your computer if you are using a high-capacity computer (HPC) system and view on your own computer. 

    * If you just want to create the ``OPT_images.xyz`` file, type into the terminal ``viewORCA opt --view False`` (which will create the ``OPT_images.xyz`` file without opening an ``ase gui`` window). 

!!! note "**NOTE 2**"

     Do not expect the energy to go down. The energy may go up during the geometry optimisation, as we are trying to find a saddlepoint on the potential energy surface rather than a local mininum. 

## Other Information about performing SCANs in ORCA

[Click here](https://sites.google.com/site/orcainputlibrary/geometry-optimizations/tutorial-saddlepoint-ts-optimization-via-relaxed-scan#h.pnxa1btinh0w) to learn more about transition state calculations from the ORCA Input Library.

!!! note

    The [ORCA Input Library](https://sites.google.com/site/orcainputlibrary) is a great source of information about performing calculations in ORCA.


## Troubleshooting transition state geometry optimisations (``OptTS``) calculations

Here are some troubleshooting tips for performing this optimisation step.

No troubleshooting issues have been found yet. 

!!! info

    If you have any issues about this step, [raise a ``New issue`` at the Issues section by clicking here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/issues).

