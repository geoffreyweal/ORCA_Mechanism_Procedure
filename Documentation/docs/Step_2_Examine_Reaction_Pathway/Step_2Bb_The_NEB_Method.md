# Step 2Bb: Nudged Elastic Band (NEB) Calculations

!!! note "Read the theory first"

    Before starting this step, we recommend reading the [theory for this step](../Theory.md#step-2-locate-the-transition-state) to understand why we are performing this step.

    * Make sure you have also read the theory on the [potential energy surface](../Theory.md#the-potential-energy-surface).

!!! tip

    Click the ``Download Templates.zip`` button to download the template folder for this step.

    - If you would like to follow this guide using data already calculated using ORCA, click ``Download Examples.zip``.

    [Download Templates.zip :octicons-download-24:](../Files/Templates.zip){ .md-button .md-button--primary :download }
    [Download Examples.zip :octicons-download-24:](../Files/Examples.zip){ .md-button :download }

In a nudged elastic band (NEB) calculation, we trace a path from the reactant to the product. An optimisation is performed across all the images at the same time in order to try to find the transition state.

!!! note 

	The NEB process is a bit more involved compared to the other steps. 

The general steps for performing an NEB calculation are:

1. [Choose an optimised structure and modify it](Step_2Bb_The_NEB_Method.md#step-2bb1-choose-an-optimised-structure-and-modify-it).
2. [Optimise the modified structure with constraints (optional, but recommended)](Step_2Bb_The_NEB_Method.md#step-2bb2-optimise-reactant-from-product-or-product-from-reactant-with-constraints-optional-but-recommended).
3. [Optimise the modified structure without constraints](Step_2Bb_The_NEB_Method.md#step-2bb3-optimise-reactant-from-product-or-product-from-reactant-without-constraints).
4. [Double-check the reactant and product structures](Step_2Bb_The_NEB_Method.md#step-2bb4-double-check-the-reactant-and-product-structures).
5. [Perform the Climbing Image - Nudged Elastic Band (CI-NEB) calculation](Step_2Bb_The_NEB_Method.md#step-2bb5-perform-the-climbing-image-nudged-elastic-band-ci-neb-calculation).

## Step 2Bb.1: Choose an Optimised Structure and Modify it

To begin, it is a good idea to take either the optimised ``Reactant`` or ``Product`` structure from [Step 1](../Step_1_Locally_Optimise_Reactant_and_Product.md). Then, move the relevant atoms in the structure of the ``Reactant`` (``Product``) so that it resembles the ``Product`` (``Reactant``) somewhat. 

* The reason for doing this is to make sure any atoms not involved directly in the mechanism are: 
    1. Ordered correctly for NEB calculations, and 
    2. Kept in the same position as best as possible. 
* The reason for doing this will be clearer once we perform the NEB calculation in [Step 2Bb.5](Step_2Bb_The_NEB_Method.md#step-2bb5-perform-the-climbing-image-nudged-elastic-band-ci-neb-calculation). 

!!! tip

    Once you have moved the atoms in your modified structure, make sure the modified atoms are fairly close to each other. This is because ORCA (as well as any DFT program) can have trouble optimising structures where atoms are initially far away from each other. 

    * As a rule of thumb, any atoms you have modified that are bonded to each other should be about 0.5 Å - 0.75 Å apart. It is easier for ORCA to increase bond lengths during optimisations rather than decrease them. 

In the example below, I have chosen the ``Product`` structure to focus on. I then moved atom 17 (Cu) to the other side of the N atom (atom 12), and moved atom 16 (H) down so that it was close to the C atom (atom 11). 

<figure markdown="span">
    <img src="../Figures/2Bb_NEB/Step2Bb_1_Choose_an_Optimised_Structure/Make_new_reactant.png?raw=true#only-light" alt="Make Reactant" width="800"/>
    <img src="../Figures/2Bb_NEB/Step2Bb_1_Choose_an_Optimised_Structure/Make_new_reactant_Dark.png?raw=true#only-dark" alt="Make Reactant" width="800"/>
    <figcaption>Example where the optimised product has been modified to resemble the reactant structure.</figcaption>
</figure>


## Step 2Bb.2: Optimise Reactant from Product (or Product from Reactant) With Constraints (Optional but Recommended)

Next, we perform a geometric optimisation calculation on this modified structure. However, we don't want the atoms that are not involved in the mechanism to move. 

* To achieve this, <ins>we constrain the atoms in the molecule that are not involved in the mechanism</ins>.

In this example, we will optimise the newly created reactant structure. Here, we have chosen to constrain the atoms in the benzene moiety from moving. The ``orca.inp`` file for this example is given below (also [located here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step2Bb_NEB/Step2Bb_2_Optimise_Reactant_from_Product_with_constraints/orca.inp)): 

```title="Example orca.inp file used to perform a geometric optimisation calculation, including constrained atoms"
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
%GEOM
    Constraints
        {C 0 C}
        {C 1 C}
        {C 2 C}
        {C 3 C}
        {C 4 C}
        {C 5 C}
    END
END
* xyzfile 1 1 reactant.xyz 

```

The optimisation of this constrained molecule is shown below (`ase gui orca_trj.xyz` or `viewORCA opt`):

<figure markdown="span">
    <img src="../Figures/2Bb_NEB/Step2Bb_2_Optimise_Reactant_from_Product_with_constraints/Optimise_Reactant.gif?raw=true" alt="Optimise Constrained Reactant" width="600"/>
    <figcaption>Optimisation of the constrained reactant.</figcaption>
</figure>

By constraining the benzyl group in benzylamine, we have allowed the Cu atom to optimise to an ideal position while keeping the benzyl group in the same place. 

!!! note

    This is an optional step as we perform another geometric optimisation step in [Step 2Bb.3](Step_2Bb_The_NEB_Method.md#step-2bb3-optimise-reactant-from-product-or-product-from-reactant-without-constraints). 

    * The reason for this constrained geometric optimisation step is that it makes it easier to view the structural change from our reactant to product structures, and to confirm both the reactant and product structures are in fact the structures we want to investigate the mechanistic step for. 
    * While this step is optional, it is highly recommended to perform this constrained optimisation job before performing the unconstrained geometric optimisation in [Step 2Bb.3](Step_2Bb_The_NEB_Method.md#step-2bb3-optimise-reactant-from-product-or-product-from-reactant-without-constraints), as it makes it easier to check you are happy with your reactant and product structures before performing the NEB calculation. 

## Step 2Bb.3: Optimise Reactant from Product (or Product from Reactant) Without Constraints

Now that we have optimised the constrained reactant, we <ins>repeat the optimisation process above, but without the constraints</ins>.

* We do this to make sure that this structure is absolutely in a local minimum.
* We do not expect the atoms in this molecule to move much, as the atoms we constrained were from an already optimised structure. 

The ORCA input file here is the same as in [Step 2Bb.2](Step_2Bb_The_NEB_Method.md#step-2bb2-optimise-reactant-from-product-or-product-from-reactant-with-constraints-optional-but-recommended), excluding the ``Constraints`` component. The ``orca.inp`` file for this example is given below (also [located here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step2Bb_NEB/Step2Bb_3_Optimise_Reactant_from_Product_without_constraints/orca.inp)): 

```title="Example orca.inp file used to perform a geometric optimisation calculation, excluding constrained atoms"
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
* xyzfile 1 1 reactant_opt_constrained.xyz 

```

In this example, the unconstrained optimisation calculation does not change the molecule much, which is what we ideally want. 

!!! warning "IMPORTANT"

    If you find the atoms have changed position significantly compared to their positions in [Step 2Bb.2](Step_2Bb_The_NEB_Method.md#step-2bb2-optimise-reactant-from-product-or-product-from-reactant-with-constraints-optional-but-recommended), this is a problem.

    * If this happens, you likely need to go back to [Step 1](../Step_1_Locally_Optimise_Reactant_and_Product.md) and make sure your original structure is geometrically optimised. 


## Step 2Bb.4: Double-Check the Reactant and Product Structures

Before beginning the NEB calculation, it is a good idea to perform some double checks on your reactant and product structures. These checks have already been mentioned, but it is worth mentioning them again. They are:

* Make sure you are happy with your input reactant and product structures, and
* Make sure the atom index ordering between your input reactant and product structures is as expected (i.e. the same). 

To help perform these two checks, use the ``ase gui`` as follows:

1. Change directory into the folder containing the NEB calculation, and open both your optimised reactant and product in ``ase gui``:

    ```bash
    # change directory into the folder containing your NEB calculation
    cd ORCA_Mechanism_Procedure/Examples/Step2_Find_TS/Step2Bb_NEB/Step2Bb_4_Double_Check

    # View the reactant and product for the NEB calculation using ASE
    ase gui reactant_opt_unconstrained.xyz opt_product.xyz
    ```

2. Next, in the ASE GUI click ``View`` -> ``Show Labels`` -> ``Atom Index``. This will display the indices of the atoms in your reactant and product structures. 

3. Flick between the reactant and product structures and check that the reactant and product structures: 

    * Are as expected (i.e. look like the reactant and product you want to understand the mechanistic step for).
    * Have the same index ordering. 

!!! example

    In the example below, 

    * The reactant and the product match the mechanistic step we described in the [Before You Begin page](../Before_You_Begin.md#mechanistic-step-example), and
    * We see that the atom indices for each atom in the reactant and product align with each other, such that there is a natural way to get from reactants to products. 

    So we are happy :smile:

    <figure markdown="span">
        <img src="../Figures/2Bb_NEB/Step2Bb_4_Double_Check/Compare_Reactant_and_Product.png?raw=true#only-light" alt="Optimised Reactant and Product for NEB Calculation." width="800"/>
        <img src="../Figures/2Bb_NEB/Step2Bb_4_Double_Check/Compare_Reactant_and_Product_Dark.png?raw=true#only-dark" alt="Optimised Reactant and Product for NEB Calculation." width="800"/>
        <figcaption>Optimised Reactant and Product for NEB Calculation.</figcaption>
    </figure>


## Step 2Bb.5: Perform the Climbing Image - Nudged Elastic Band (CI-NEB) Calculation

As a reminder, in an NEB we trace a path from the reactant to the product, and an optimisation is performed across all the images at the same time in order to try to find the transition state.

In the ``.inp`` file, you want to include the following:

```
!NEB-CI TightSCF defgrid2
```

The tags here indicate you want to do the following: 

* ``NEB-CI``: This keyword will perform a nudged elastic band (NEB) calculation upon your system using the climbing image (CI) variant of the NEB algorithm. 
* ``TightSCF``: Tells ORCA to tighten the convergence criteria for each electronic step. 
* ``defgrid2``: Indicates how fine we want the integration grid to be (this is the default).

We also include the following NEB settings: 

```
%NEB
    NEB_END_XYZFILE "opt_product.xyz"
    Nimages 100
    Interpolation IDPP
    Opt_Method LBFGS
END
* xyzfile 1 1 reactant_opt_unconstrained.xyz
```

The tags here indicate you want to do the following in your NEB calculation: 

* ``NEB_END_XYZFILE``: This is the product structure you want to use. Include this file in the same place as your ORCA ``.inp`` file.
* ``Nimages``: This is the number of images you want to include in the NEB calculation (not including the reactant and product images). 
    * In this example, we will create 102 images from ``reactant_opt_unconstrained.xyz`` to ``opt_product.xyz`` (100 images in between but not including ``reactant_opt_unconstrained.xyz`` to ``opt_product.xyz``).
* ``Interpolation``: This is the interpolation scheme first used to create all the initial images. 
* ``Opt_Method``: This is the optimisation method used. 

!!! tip "**IMPORTANT**"

	It is important that the atom ordering in your reactant and product ``xyz`` files is the same, otherwise you will have problems where atoms seem to move about in nonsense ways. If you have checked this during [Step 2Bb.4](Step_2Bb_The_NEB_Method.md#step-2bb4-double-check-the-reactant-and-product-structures), you should be all good to go.

???+ note "**NOTE 1**"

	In this example I have set ``Nimages`` to 100. I chose this to allow for some smoothness between images in the mechanistic step. However, you could set this to a much lower number and everything would probably work. For example, 20 would likely also work fine. 

    * Try not to use too many images, as this can cause problems and also increases the amount of time required for the NEB to converge. 

???+ note "**NOTE 2**"

	I use ``LBFGS`` in this example as the optimisation method. This is a very good algorithm, but it can be a bit loose and cause issues. In testing I tried the ``FIRE`` method. This worked as well, but caused jitters which can lead to problems. 

    * The point is if you have convergence problems, try using another method for ``Opt_Method``. 
    * See the [ORCA manual 6.1.0](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/orca_manual_6_1_0.pdf): Page 651 for options for this setting. 
    * Also see the [comments about the ``Opt_Method`` settings](#comments-about-the-opt_method-settings) at the bottom of this page for more details. 

In this example, we are looking at how a Cu atom could insert itself into a C-H bond. The full ``orca.inp`` file is given below (also [located here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/orca.inp)): 

```title="Example orca.inp file used to perform a NEB calculation"
!B3LYP DEF2-TZVP D3BJ
!NEB-CI TightSCF defgrid2
%SCF
    MaxIter 2000       # Here setting MaxIter to a very high number. Intended for systems that require sometimes 1000 iterations before converging (very rare).
    DIISMaxEq 5        # Default value is 5. A value of 15-40 necessary for difficult systems.
    directresetfreq 15 # Default value is 15. A value of 1 (very expensive) is sometimes required. A value between 1 and 15 may be more cost-effective.
END
%CPCM EPSILON 6.02 REFRAC 1.3723 END
%PAL NPROCS 32 END
%maxcore 2000 # This indicates you want ORCA to use only 2GB per core maximum, so ORCA will use only 2GB*32=64GB of memory in total.
%NEB
    NEB_END_XYZFILE "opt_product.xyz"
    Nimages 100
    Interpolation IDPP
    Opt_Method LBFGS
END
* xyzfile 1 1 reactant_opt_unconstrained.xyz

```


### Outputs from ORCA

ORCA will create a number of files, as well as the ``output.out`` file. These are the important ones to look at for NEB calculations: 

* ``orca_initial_path_trj.xyz``: This is the initial NEB path that ORCA will begin investigating. 
* ``orca_MEP_trj.xyz``: This is the NEB trajectory for the mechanism.
* ``orca_NEB-TS_converged.xyz``: This is the transition state that was obtained from this NEB calculation. 


### **IMPORTANT**: Things to do while the NEB calculation is running

Once ORCA has begun running the NEB calculation, there are two things that you should do:

1. **Check the ``orca_initial_path_trj.xyz`` file.**
2. **Check the NEB calculation daily.**

Below is a description of these two checks:


**1. Check the ``orca_initial_path_trj.xyz`` file**

Once ORCA begins, the first step in the NEB calculation is to create all the initial images connecting the reactant and the product using an interpolation scheme. 

* ORCA will create a [file called ``orca_initial_path_trj.xyz``](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step2_Find_TS/Step2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/orca_initial_path_trj.xyz). This file gives an idea of the initial NEB path that ORCA will begin investigating. 
* <ins>**Check this file in ``ase gui`` and see that this initial mechanistic pathway looks somewhat sensible**</ins>.

```bash
# change directory into the folder containing your NEB calculation
cd ORCA_Mechanism_Procedure/Examples/Step2_Find_TS/Step2Bb_NEB/Step2Bb_5_Run_NEB_Calculation

# View the reactant and product for the NEB calculation using ASE
ase gui orca_initial_path_trj.xyz
```

???+ example

    For this example, the ``orca_initial_path_trj.xyz`` file looks like this:

    <figure markdown="span">
        <img src="../Figures/2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/Check_NEB_using_orca_initial_path_trj/Check_orca_initial_path_trj.gif?raw=true" alt="Check orca_initial_path_trj.xyz file" width="400"/>
        <figcaption>Check the initial interpolation path given in the orca_initial_path_trj.xyz file</figcaption>
    </figure>

    In this example, atom 16 (H) floats away in free space from atom 11 (C), and there is a bit of time before atom 16 bonds to atom 17 (Cu). 

    * This indicates there *may be* a problem and the NEB calculation might have trouble. 
    * However, NEB calculations are designed to change the mechanistic path to account for this and will find a more likely mechanistic pathway, so this is not a horrible initial NEB pathway. 

    I would be happy for this calculation to proceed as it is, but it would be wise to check this calculation daily as it runs. 

!!! tip

    The general rule is: The simpler you can make the initial NEB pathway, the more likely the NEB calculation will converge. 


**2. Check the NEB calculation daily**

Any ORCA or DFT calculation has the potential to go in weird directions that make convergence unlikely, and this is particularly the case for NEB calculations. For this reason, it is important to do the following checks on a daily basis: 

1. Check the ``orca_MEP_trj.xyz`` file. This file describes the current reaction pathway as calculated by NEB. 

    * View this file by running ``ase gui orca_MEP_trj.xyz`` in the terminal. 
    * Hopefully the NEB path given in this file looks better and better as ORCA proceeds. 
    * <ins>**The main thing is to check that the NEB path given by ``orca_MEP_trj.xyz`` is still sensible by your chemical intuition**</ins>. 

2. Check the ``output.out`` file to make sure everything is running smoothly.

    * The best way to check the ``output.out`` file is to scroll to the bottom of the ``output.out`` file. 
    * If there are any problems, they may show up in the ``output.out`` file.
    * If you are using slurm, you should also look at the slurm output and error files to see if there are any issues reported there. 

3. Check how the energy profile of the NEB calculation has changed by running the ``viewORCA neb_snap`` command in your terminal. 

    * This command will present the energy profile snapshots of all the NEB iterations that ORCA has performed thus far. 
    * Run this command by changing directory to the folder containing your NEB run in the terminal, and then running the ``viewORCA neb_snap`` command.

    ```bash
    # cd into your optimisation folder
    cd ORCA_Mechanism_Procedure/Examples/Step2_Find_TS/Step2Bb_NEB/Step2Bb_5_Run_NEB_Calculation

    # View the NEB calculation 
    viewORCA neb_snap
    ```

    * ``viewORCA neb_snap`` will create two files. These are: 

        * ``orca_NEB_optimization.png``: This file contains the plots of all the NEB optimisation iterations that have been performed so far.
        * ``orca_NEB_last_iteration.png``: This is the plot of the last NEB optimisation iteration.

    ???+ example

        Examples of the ``orca_NEB_optimization.png`` and ``orca_NEB_last_iteration.png`` files are shown below:

        <figure markdown="span">
            <img src="../Figures/2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/Successful_NEB_using_NEB_CI/orca_NEB_optimization.png?raw=true" alt="orca_NEB_optimization.png" width="500"/>
            <figcaption>Energy profile of each NEB optimisation iteration performed by ORCA. This is given by the 'orca_NEB_optimization.png' file.</figcaption>
        </figure>

        <figure markdown="span">
            <img src="../Figures/2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/Successful_NEB_using_NEB_CI/orca_NEB_last_iteration.png?raw=true" alt="orca_NEB_last_iteration.png" width="500"/>
            <figcaption>Energy profile of the last NEB optimisation iteration, as performed by ORCA. This is given by the 'orca_NEB_last_iteration.png' file.</figcaption>
        </figure>


### How to analyse the output files after the NEB calculation has finished

Once ORCA has finished performing the NEB calculation, we will want to visualise the NEB. You can visualise how ORCA has performed the mechanistic step by typing ``viewORCA neb`` into the terminal. 

```bash
# cd into your optimisation folder
cd ORCA_Mechanism_Procedure/Examples/Step2_Find_TS/Step2Bb_NEB/Step2Bb_5_Run_NEB_Calculation

# View the NEB calculation 
viewORCA neb
```

You will get a GUI that shows you the following NEB pathway:

<figure markdown="span">
    <img src="../Figures/2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/Successful_NEB_using_NEB_CI/NEB_example.gif?raw=true" alt="NEB Images" width="600"/>
    <figcaption>Images of the NEB pathway.</figcaption>
</figure>

The energy profile for this example is given below:

<figure markdown="span">
    <img src="../Figures/2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/Successful_NEB_using_NEB_CI/NEB_energy.png?raw=true" alt="NEB Energy Profile" width="600"/>
    <figcaption>Energy profile of the NEB calculation.</figcaption>
</figure>

You can see that a transition state is given by ORCA as the ``orca_NEB-CI_converged.xyz`` file. This is what the given transition state looks like in this example:

<figure markdown="span">
    <img src="../Figures/2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/Successful_NEB_using_NEB_CI/CI_NEB.png?raw=true" alt="Transition State from the CI-NEB calculation" width="600"/>
    <figcaption>Transition State as obtained by the CI-NEB calculation.</figcaption>
</figure>

## Other comments about NEBs

### Comments about the ``Opt_Method`` settings

``LBFGS`` is a common optimisation algorithm used in geometric optimisations. The note from ORCA is that *The L-BFGS is more aggressive and efficient, but also more error-prone.* Because of this, it is a common strategy to change the optimisation algorithm used to help the NEB calculation. 

* In testing this procedure I also tried the ``FIRE`` method, which is another good algorithm. 
* However in this case, the ``FIRE`` algorithm was less able to scout the NEB. 

This is the NEB path that I got from the same NEB calculation shown above, but using the ``FIRE`` algorithm: 

<figure markdown="span">
    <img src="../Figures/2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/NEB_using_FIRE/NEB_example.gif?raw=true" alt="NEB Images using the FIRE algorithm" width="600"/>
    <figcaption>NEB Images using the FIRE algorithm</figcaption>
</figure>

The energy profile for this example is given below:

<figure markdown="span">
    <img src="../Figures/2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/NEB_using_FIRE/NEB_energy.png?raw=true" alt="NEB Energy Profile using the FIRE algorithm" width="600"/>
    <figcaption>NEB Energy Profile using the FIRE algorithm</figcaption>
</figure>

You can see from the NEB path and the energy profile that it's a bit jittery, but overall the NEB did work as we found a good transition state:

<figure markdown="span">
    <img src="../Figures/2Bb_NEB/Step2Bb_5_Run_NEB_Calculation/NEB_using_FIRE/CI_NEB.png?raw=true" alt="Transition State from the CI-NEB calculation using the FIRE algorithm" width="600"/>
    <figcaption>Transition State as obtained by the CI-NEB calculation using the FIRE algorithm.</figcaption>
</figure>

At the end of the day, it doesn't matter how "well" the NEB calculation did; what matters is whether we found a sufficient transition state that we can further optimise in [Step 3: Optimise the Transition State](../Step_3_Optimise_the_Transition_State.md). So I would be happy with how this NEB ran, and would have continued to Step 3. 


## Other Information about performing NEBs in ORCA

The following links have good information for performing NEBs in ORCA:

* https://www.faccts.de/docs/orca/6.0/tutorials/react/nebts.html: Nice article from the developers about how to perform an NEB in ORCA.
* https://sites.google.com/site/orcainputlibrary/geometry-optimizations/tutorial-neb-calculations: Nice extra information for performing and analysing NEBs.
* https://github.com/via9a/neb_visualize: Contains another program for analysing how the NEB optimised. This program is really good for figuring out how the NEB optimised itself, very helpful!


## Troubleshooting the Nudged Elastic Band (``NEB``) Calculation

Here are some troubleshooting tips for performing NEB calculations.

No troubleshooting issues have been found yet. 

Also look at the following websites for help:

* https://sites.google.com/site/orcainputlibrary/scf-convergence-issues (a part of https://sites.google.com/site/orcainputlibrary)

!!! info

    If you have any issues about this step, [raise a ``New issue`` at the Issues section by clicking here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/issues).


