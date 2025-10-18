# Step 2Ba: The SCAN Method

!!! tip

    Download the template folder for this step by clicking the button below and work on the files in the template folder as you read through this tutorial. 

    [Download Templates.zip :octicons-download-24:](../Files/Templates.zip){ .md-button .md-button--primary :download }

In a SCAN calculation, we want to map how a reaction proceeds by gradually changing the distance between two atoms. The SCAN calculation works as follows:

1. Perform a geometric optimisation on the chemical system, where the distance between two atoms are fixed.
2. Repeat the geometric optimisation on the same chemical system, where the position of the two atoms is changed by $dx$.
3. Repeat this until the distance between the two atoms changes to the desired final length. 

To perform a SCAN, we first include this line in our input file:

```
!OPT NormalOPT TightSCF defgrid2 # Try TightOPT if you have convergence problems. 
```

The tags here indicate you want to do the following: 

* ``OPT``: Indicates you want ORCA to perform local optimisations during your SCAN calculation. 
* ``TightSCF``: Tells ORCA to tighten the convergence criteria for each electronic step. 
* ``defgrid2``: Indicates how fine we want the intergration grid to be (This is the default)
* ``NormalOPT``: Indicate we want to use normal geometric convergence settings. 

!!! tip

    For these calculations we want to use ``NormalOPT`` rather than ``TightOPT`` because we are only wanting to get a good idea of what the transition state looks like. 

    * ``NormalOPT`` is ideal for SCAN calculations as it is the usual convergence criteria for performing optimisations, and will run faster than using ``TightOPT``. 
    * However, if you have problems with convergence issues, you can try using ``TightOPT``. See the [ORCA 6.1.0 Manual](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/orca_manual_6_1_0.pdf), page 618 for more information.

We also include the following lines:

```title="Extra lines required for a SCAN calculation"
%GEOM 
    SCAN B atom_index_1 atom_index_2 = initial_distance, final_distance, linespace+1 END 
END
```

where:

* ``atom_index_1``: This is the index of the first atom. Obtain this using ``ase gui``.
* ``atom_index_2``: This is the index of the second atom. Obtain this using ``ase gui``.
* ``initial_distance``: The initial distance between the two atoms. Get this by measuring the distance between the two atoms in your system using a GUI (such as avogadro or ``ase gui``) and record it here.
* ``final_distance``: The final distance between the two atoms. 
* ``linespace``: The number of SCAN steps you want to perform. 

An example for these lines is given below:

```title="Extra lines required for a SCAN calculation"
%GEOM 
    SCAN B 11 16 = 3.245, 0.745, 126 END 
END
```

In this example, we have told ORCA to begin by setting the distance between atom 11 and 16 to 3.245 Å, and then decrease the distance between these two atoms to 0.745 Å in increments of $\frac{3.245-0.745}{126-1} = 0.02$ Å. 

!!! note "**NOTE 1**"

    You will want to measure the initial distance between your two atoms using a GUI like ``ase gui``. This is the value you want to put in for the initial bond distance. 

    * This is how I got the bond distance between atom 11 and 16 to 3.245 Å for this example. 

!!! note "**NOTE 2**"

    ORCA counts atoms starting from 0. This means that in some GUIs (like GView), atom 11 here is atom 12 in GView. **In the ASE GUI and all the programs given here, atoms numbers are equal to ORCA. I.e.: atom 11 in the ASE GUI means atom 11 in ORCA**. 

!!! note "**NOTE 3**"

    We have set the number of steps to perform to 126 rather than 125. This is because we are including the endpoint in our SCAN, and I want the increments to be spaced by a rational value (i.e.: $\frac{3.245-0.745}{126-1} = 0.02$ Å step size). 

    * This is just a personal preference of mine, and is not a hard rule. 

In this example, we are looking at how a Cu atom could insert itself into a C-H bond. The ``orca.inp`` file for this example is given below (also [located here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step2Ba_SCAN/SCAN_NormalOPT/orca.inp)): 

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
%GEOM 
    SCAN B 11 16 = 3.245, 0.745, 126 END 
END
* xyzfile 1 1 opt_product.xyz
```


## Outputs from ORCA

As well as the [``output.out``](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step2Ba_SCAN/SCAN_NormalOPT/output.out) and [``orca_trj.xyz``](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step2Ba_SCAN/SCAN_NormalOPT/orca_trj.xyz) files, ORCA will also give:

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

    ``viewORCA scan`` will also create a xyz file called ``SCAN_images.xyz`` that you can copy and view on your own computer. 

    * If you just want to create the ``SCAN_images.xyz`` file, type into the terminal ``viewORCA scan --view False`` (which will create the ``SCAN_images.xyz`` file without launching ``ase gui``). 

Once you run ``viewORCA scan``, you will get a GUI that shows you the following SCAN pathway:

<figure markdown="span">
    <img src="../Figures/2Ba_SCAN/SCAN_example.gif?raw=true" alt="SCAN Images" width="700"/>
    <figcaption>GIF of the SCAN job</figcaption>
</figure>

The energy profile for this example is given below:

<figure markdown="span">
    <img src="../Figures/2Ba_SCAN/SCAN_energy.png?raw=true" alt="SCAN Energy Profile" width="700"/>
    <figcaption>Energy Profile of the SCAN job</figcaption>
</figure>

!!! note "**NOTE 2**"

    The energy goes up at the end because the hydrogen atom is probably getting too close to the carbon atom. We can ignore this part of the SCAN (after around step 110), as it is not relavant to us for finding the transition state for this mechanistic step. 

The easiest way to use this GUI is to zoom in on the part of the energy profile looks like the transition state (by clicking on the <img src="../Figures/2Ba_SCAN/Magnifying_Glass.png?raw=true" alt="drawing" width="25"/> button), and from this determine the image this corresponds to by looking at the x axis. Move the cursor over the highest point along the energy profile, and read the x value:

<figure markdown="span">
    <img src="../Figures/2Ba_SCAN/SCAN_energy_zoomed_in.png?raw=true" alt="SCAN Energy Profile - Zoomed in on Transition State" width="700"/>
    <figcaption>SCAN Energy Profile - Zoomed in on Transition State</figcaption>
</figure>

This is what the given transition state looks like in this example:

<figure markdown="span">
    <img src="../Figures/2Ba_SCAN/TS_SCAN.png?raw=true" alt="SCAN Energy Profile" width="700"/>
    <figcaption>Energy Profile of the SCAN job</figcaption>
</figure>

This is a promising transition state, but we need to proceed with [steps 3](../Step_3_Optimise_the_Transition_State.md) and [4](../Step_4_Validate_TS/index.md) to make sure it is ok. 

Once ORCA has finished and you have viewed your SCAN pathway and obtained your transition state, you should do the following check:

### Check: Does the SCAN path make sense chemically and physically

You will want to look at the SCAN path and check if it chemically and physically makes sense. If it does not, you need to redo the SCAN and try something else, like making the two atoms contract closer to each other rather than stretch, or maybe try contracting or expanding the distance between other atoms.  

### Advice about SCANs

In this example, I forced the SCAN to gradually decrease the distance between atom 11 (C) and atom 16 (H). However, this is not the only way I could have performed this SCAN. 

* For example, I could have started with the Cu atom bonded to the N atom, and gradually decrease the distance between atoms 11 (C) and 17 (Cu) to force them to form a bond.
* I decided to start with a C-Cu-H bond and force the C and H to come together because I thought this was the best way to obtain the transition state for this mechanistic step.
* It is not uncommon that you need to try a few different SCAN paths to get the transition state you are looking for. 


## What should I do if I need to restart a SCAN run

Sometimes a SCAN job may fail. However, rather than resetting the SCAN job from beginning, you may want your SCAN job to resume from the last converged SCAN image. 

If you want to restart the SCAN job from the last converged image, here is a guide to how to do this ([click here to see the example files for this procedure in Github](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Examples/Step2_Find_TS/Step2Ba_SCAN/SCAN_Restarted_Example)):

1. **If you are restarting your SCAN job for the first time**: Make a new folder called ``SCAN_1``, and move all your SCAN files into this folder. Do this by running the lines below in your terminal:

    ```bash title="Make a new SCAN folder and place all SCAN files into it"
    mkdir SCAN_1
    mv -v * SCAN_1
    ```

    !!! note

        You will see a message like this when you run the ``mv -v * SCAN_1`` command. 

        ```bash
        mv: cannot move ‘SCAN_1’ to a subdirectory of itself, ‘SCAN_1/SCAN_1’
        ```

        This is normal and expected. Ignore this issue. 

2. Make a new folder called ``SCAN_2``:

    ```bash title="Make a new SCAN folder"
    mkdir SCAN_2
    ```

3. Copy the ORCA input file, slurm submit file, and the last converged SCAN xyz file. This is the latest numbered xyz file. An example of this is given below:

    ```bash title="Copy SCAN file from the previous SCAN job over to the new SCAN folder"
    cp -rv SCAN_1/orca.inp     SCAN_2/orca.inp
    cp -rv SCAN_1/submit.sl    SCAN_2/submit.sl
    cp -rv SCAN_1/orca.059.xyz SCAN_2/orca.059.xyz
    ```

4. Change directory into the new SCAN folder, then change the name of the last converged SCAN xyz file to another name, such as ``last_converged_SCAN_image_restart.xyz``

    ```bash title="Copy SCAN file from the previous SCAN job over to the new SCAN folder"
    cd SCAN_2
    mv orca.059.xyz last_converged_SCAN_image_restart.xyz
    ```

5. Open the copied ``orca.inp`` file, and make two changes to this file

    1. Change the name of the xyz file give in in the ``xyzfile`` line to ``last_converged_SCAN_image_restart.xyz``

        ```
        * xyzfile 1 1 last_converged_SCAN_image_restart.xyz
        ```

    2. In the ``GEOM`` section: 

        * Change the bond distance between the two atoms of interest as given in ``last_converged_SCAN_image_restart.xyz``. Get this by measuring the distance between the two atoms of interest in ``ase gui last_converged_SCAN_image_restart.xyz``
        * Change the number of SCAN iterations to perform in order to keep displacement between SCAN images the same. For example, here the original displacement was $\frac{\rm{d_f} - \rm{d_i}}{(\rm{no.\:SCAN\:interations})-1} = \frac{3.245 - 0.745}{126-1} = 0.02$. The distance between atoms 11 and 16 in ``last_converged_SCAN_image_restart.xyz`` is ``2.285 Å``. Therefore, we need to perform $\frac{d_f(\rm{new}) - d_i}{\rm{displacement}}+1 = \frac{2.085 - 0.745}{0.02}+1 = 68$ (The $+1$ is so we include the initial image in the SCAN procedure).

        An examples of the two components of ``GEOM`` that need to be changed are given below

        ```
        %GEOM
            SCAN B 11 16 = new_initial_distance, 0.745, no_of_SCAN_iterations END
        END
        ```
        
        For example:

        ```
        %GEOM
            SCAN B 11 16 = 2.085, 0.745, 68 END
        END
        ```

    An example of the updated ``orca.inp`` file is shown below

    ```title="Example of the orca.inp file for the updated SCAN job"
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
    %GEOM 
        SCAN B 11 16 = 2.085, 0.745, 68 END
        MaxIter 200 
    END
    * xyzfile 1 1 last_converged_SCAN_image_restart.xyz

    ```

    !!! note

        I have also included ``MaxIter 200`` in thr ``GEOM`` section. This was because I was having convergence issues because the number of geometry optimisations was going over the default value of ``50``. I increased this to ``200`` so that it would run without problems in this example. 


6. Submit your ORCA job to slurm, or run your ORCA job however you usually run ORCA. 

Once your SCAN job has completed to your satisfaction, you can use ``viewORCA scan`` to view all your SCAN runs together. To do this, run ``viewORCA scan`` in the folder containing your ``SCAN_1``, ``SCAN_2``, ``SCAN_3``, ... folders. ``viewORCA scan`` will collate all the SCAN jobs together in numerical order so that it looks as if only one SCAN job ran.

!!! tip 

    ``viewORCA scan`` will also still create a ``SCAN_images.xyz`` file, containing the SCANs from all your SCAN folders pasted together. 

!!! note

    * [Click here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Examples/Step2_Find_TS/Step2Ba_SCAN/SCAN_Restarted_Example) to see the example files for this procedure in Github. 
    * [Click here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step2Ba_SCAN/SCAN_Restarted_Example/SCAN_images.xyz) for the ``SCAN_images.xyz`` created for this restarted SCAN job. You should see that it gives the same ``SCAN_images.xyz`` file as if the SCAN job ran successfully in one go ([as given here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step2Ba_SCAN/SCAN_NormalOPT/SCAN_images.xyz)).

## Other information about performing ``SCAN`` calculations in ORCA

[Click here](https://sites.google.com/site/orcainputlibrary/geometry-optimizations/tutorial-saddlepoint-ts-optimization-via-relaxed-scan) to learn more about SCAN calculations from the ORCA Input Library.

!!! note

    The [ORCA Input Library](https://sites.google.com/site/orcainputlibrary) is a great source of information about performing calculations in ORCA.


## Troubleshooting the ``SCAN`` calculation

Here are some troubleshooting tips for performing this optimisation step.

No troubleshooting issues have been found yet. 

!!! info

    If you have any issues about this step, [raise a ``New issue`` at the Issues section by clicking here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/issues).