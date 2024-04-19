# Step 2A: The SCAN Method

!!! tip

    [Download the template folder for this step from here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Templates/Step2_Find_TS) and work on the files in the template folder as you read through this step.

In a SCAN calculation, we want to map how a reaction proceeds by gradually changing the distance between two atoms. The SCAN calculation works as follows:

1. Perform a geometric optimisation on the chemical system, where the distance between two atoms are fixed.
2. Repeat the geometric optimisation on the same chemical system, where the position of the two atoms is changed by $dx$.
3. Repeat this until the distance between the two atoms changes to the desired final length. 

To perform a SCAN, we first include this line in our input file:

```
!OPT NormalOPT TightSCF defgrid2 # Try TightOPT if you have convergence problems. 
```

The tags here indicate you want to do the following: 

* ``OPT``: Indicates you want ORCA to perform a local optimisation. 
* ``TightSCF``: Tells ORCA to tighten the convergence criteria for each electronic step. 
* ``defgrid2``: Indicates how fine we want the intergration grid to be (This is the default)
* ``NormalOPT``: Indicate we want to use normal geometric convergence settings. 

!!! tip

    For these calculations we want to use ``NormalOPT`` rather than ``TightOPT`` because we are only wanting to get a good idea of what the transition state looks like. 

    * ``NormalOPT`` is ideal for SCAN calculations as it is the usual convergence criteria for performing optimisations, and will run faster than using ``TightOPT``. 
    * However, if you have problems with convergence issues, you can try using ``TightOPT``. See the [ORCA 5.0.4 Manual](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/orca_manual_5_0_4.pdf), page 20 for more information.

We also include the following lines:

```title="Extra lines required for a SCAN calculation"
%geom 
    SCAN B atom_index_1 atom_index_2 = initial_distance, final_distance, linspace+1 END 
END
```

where:

* ``atom_index_1``: This is the index of the first atom. Obtain this using ``ase gui``.
* ``atom_index_2``: This is the index of the second atom. Obtain this using ``ase gui``.
* ``initial_distance``: The initial distance between the two atoms. Get this by measuring the distance between the two atoms in your system using a GUI (such as avogadro or ``ase gui``) and record it here.
* ``final_distance``: The final distance between the two atoms. 
* ``linspace``: The number of SCAN steps you want to perform. 

An example for these lines is given below:

```title="Extra lines required for a SCAN calculation"
%geom 
    SCAN B 11 14 = 3.242, 0.742, 126 END 
END
```

In this example, we have told ORCA to begin by setting the distance between atom 11 and 14 to 3.242 Å, and then decrease the distance between these two atoms to 0.742 Å in increments of $\frac{3.242-0.742}{126-1} = 0.02$ Å. 

!!! note "**NOTE 1**"

    You will want to measure the initial distance between your two atoms using a GUI like ``ase gui``. This is the value you want to put in for the initial bond distance. 

    * This is how I got the bond distance between atom 11 and 14 to 3.242 Å for this example. 

!!! note "**NOTE 2**"

    ORCA counts atoms starting from 0. This means that in some GUIs (like GView), atom 11 here is atom 12 in GView. **In the ASE GUI and all the programs given here, atoms numbers are equal to ORCA. I.e.: atom 11 in the ASE GUI means atom 11 in ORCA**. 

!!! note "**NOTE 3**"

    We have set the number of steps to perform to 126 rather than 125. This is because we are including the endpoint in our SCAN, and I want the increments to be spaced by a rational value (i.e.: $\frac{3.242-0.742}{126-1} = 0.02$ Å step size). 

    * This is just a personal preference of mine, and is not a hard rule. 

In this example, we are looking at how a Cu atom could insert itself into a C-H bond. The ``orca.inp`` file for this example is given below (also [located here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step_2A_SCAN/SCAN_NormalOPT/orca.inp)): 

```title="Example orca.inp file used to perform a SCAN calculation"
!B3LYP DEF2-TZVP D3BJ
!OPT NormalOPT TightSCF defgrid2 # Try TightOPT if you have convergence problems. 
%SCF
    MaxIter 2000       # Here setting MaxIter to a very high number. Intended for systems that require sometimes 1000 iterations before converging (very rare).
    DIISMaxEq 5        # Default value is 5. A value of 15-40 necessary for difficult systems.
    directresetfreq 15 # Default value is 15. A value of 1 (very expensive) is sometimes required. A value between 1 and 15 may be more cost-effective.
END
%CPCM EPSILON 6.02 REFRAC 1.3723 END
%PAL NPROCS 32 END
%maxcore 2000
%geom 
    SCAN B 11 14 = 3.242, 0.742, 126 END 
END
* xyzfile 1 1 opt_product.xyz

```


## Outputs from ORCA

As well as the [``output.out``](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step_2A_SCAN/SCAN_NormalOPT/output.out) and [``orca_trj.xyz``](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step_2A_SCAN/SCAN_NormalOPT/orca_trj.xyz) files, ORCA will also give:

* A series of files called ``orca.001.xyz``, ``orca.002.xyz``, ``orca.003.xyz``, ... up to ``orca.126.xyz``. These are the steps in the SCAN process. 

!!! note "**NOTE**"

    The ``orca_trj.xyz`` contains the xyz files for every geometric optimisation across all SCAN steps, so it can be unhelpful to view on its own. However, keep it as it will be used by the ``viewORCA`` program.

To view the SCAN mechanism and the energy path, type ``viewORCA scan`` in the terminal and hit enter. This will load a program that will allow you to see how the SCAN calculation performed your mechanism, along with the energy profile. 

```bash
# cd into your optimisation folder
cd ORCA_Mechanism_Procedure/Examples/Step2_Find_TS/SCAN

# View the SCAN calculation 
viewORCA scan
```

!!! note "**NOTE 1**"

    ``viewORCA scan`` will also create a xyz file called ``SCAN_images.xyz`` that you can copy to your computer if you are using a high-capacity computer (HPC) system and view on your own computer. 

    * If you just want to create the ``SCAN_images.xyz`` file, type into the terminal ``viewORCA scan --view False`` (which will create the ``SCAN_images.xyz`` file without launching ``ase gui``). 

Once you run ``viewORCA scan``, you will get a GUI that shows you the following SCAN pathway:

<figure markdown="span">
    <img src="../Figures/2A_SCAN/SCAN_example.gif?raw=true" alt="SCAN Images" width="700"/>
    <figcaption>GIF of the SCAN job</figcaption>
</figure>

The energy profile for this example is given below:

<figure markdown="span">
    <img src="../Figures/2A_SCAN/SCAN_energy.png?raw=true" alt="SCAN Energy Profile" width="700"/>
    <figcaption>Energy Profile of the SCAN job</figcaption>
</figure>

!!! note "**NOTE 2**"

    The energy goes up at the end because the hydrogen atom is probably getting too close to the carbon atom. We can ignore this part of the SCAN (after around step 110), as it is not relavant to us for finding the transition state for this mechanistic step. 

The easiest way to use this GUI is to zoom in on the part of the energy profile looks like the transition state (by clicking on the <img src="https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Documentation/docs/Figures/2A_SCAN/Magnifying_Glass.png?raw=true" alt="drawing" width="25"/> button), and from this determine the image this corresponds to by looking at the x axis. Move the cursor over the highest point along the energy profile, and read the x value:

<figure markdown="span">
    <img src="../Figures/2A_SCAN/SCAN_energy_zoomed_in.png?raw=true" alt="SCAN Energy Profile - Zoomed in on Transition State" width="700"/>
    <figcaption>SCAN Energy Profile - Zoomed in on Transition State</figcaption>
</figure>

This is what the given transition state looks like in this example:

<figure markdown="span">
    <img src="../Figures/2A_SCAN/TS_SCAN.png?raw=true" alt="SCAN Energy Profile" width="700"/>
    <figcaption>Energy Profile of the SCAN job</figcaption>
</figure>

This is a promising transition state, but we need to proceed with steps 3 and 4 to make sure it is ok. 

Once ORCA has finished and you have viewed your SCAN pathway and obtained your transition state, you should do the following check:

### Check: Does the SCAN path make sense chemically and physically

You will want to look at the SCAN path and check if it chemically and physically makes sense. If it does not, you need to redo the SCAN and try something else, like making the two atoms contract closer to each other rather than stretch, or maybe try contracting or expanding the distance between other atoms.  

### Advice about SCANs

In this example, I forced the SCAN to gradually decrease the distance between atom 11 (C) and atom 14 (H). However, this is not the only way I could have performed this SCAN. 

* For example, I could have started with the Cu atom bonded to the N atom, and gradually decrease the distance between atoms 11 (C) and 17 (Cu) to force them to form a bond.
* I decided to start with Cu inserted into the C-H bond and force the C and H to come together because I thought this was the best way to obtain the transition state for this mechanistic step.
* It is not uncommon that you need to try a few different SCAN paths to get the transition state you are looking for. 


## Other Information about performing ``SCAN`` calculations in ORCA

[Click here](https://sites.google.com/site/orcainputlibrary/geometry-optimizations/tutorial-saddlepoint-ts-optimization-via-relaxed-scan) to learn more about SCAN calculations from the ORCA Input Library.

!!! note

    The [ORCA Input Library](https://sites.google.com/site/orcainputlibrary) is a great source of information about performing calculations in ORCA.


## Troubleshooting the ``SCAN`` calculation

Here are some troubleshooting tips for performing this optimisation step.

No troubleshooting issues have been found yet. 

!!! info

    If you have any issues about this step, [raise a ``New issue`` at the Issues section by clicking here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/issues).