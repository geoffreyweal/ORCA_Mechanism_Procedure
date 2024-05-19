# Step 5: Compile Results

Having now finished the full reaction mechanism investigation using ORCA, we can now compile the results from our calculations in order to present information about the structures and energies of the reactants, products, and the transition state. Follow the steps below: 


## Step 5A: Double Check Results

Before finalising everything, it is important to do a final check that everything is all good and that there are no issues with your output files from this proceedure and you are happy with all the calculations and the decisions you made, as this process is often not smooth and requires playing around. So finalising everything is a good idea to make sure you haven't missed anything important. 

!!! tip "**IMPORTANT**"

	It is very important that you double check your calculations. Do not skip this step. 

## Step 5B: Obtain the Energies and Structures of your Reactants, Products, and Transition State

We now can obtain the energies and structures for the reactant, product, and transition state. To do this, we want to compare the energies of the ``Reactant`` and ``Product`` with the ``Forward`` and ``Backwards`` structure from Step 4B steps. It is good to do this because sometimes the structures from 4B might be slightly lower energy than what was obtain from Step 1. 

!!! note "**NOTE 1**"

	We want to take the Gibb's Free Energy, so make sure you take this energy value from the ``output.out`` files. We can obtain this value because we have run the vibrational frequency calculation, which allows the vibrational entropy to be calculated. You will find these if you look for the ``GIBBS FREE ENERGY`` header in the ``output.out`` file. 

!!! note "**NOTE 2**"

	The energy values you get will be in hartrees (unit are Eh or Ha). It is important to record the whole hartrees energy value to the full decimal places. 

In this example:

* The energy of the ``Reactant`` is -1967.08223843 Eh, while the ``Backwards`` structure from Step 4B did not converge. As we saw in Step 5 the ``Reactant`` and ``Backwards`` structures are very similar, so I would not be worried about this, and take the ``Reactant`` structure as the reactant. 
* The energy of the ``Product`` is -1967.03515273 Eh, while the energy of the ``Forwards`` structure from Step 4B is -1967.03512026 Eh. The ``Product`` structure has a lower energy than the ``Forwards`` structure. 

From Step 3, the energy of the transition state is -1967.01474746 Eh. 

!!! note "**NOTE 3**"

	Record all these numbers, as you will need the absolute values when collecting the energy for all the mechanistic step across the one or more mechanisms that you are studying. 

!!! note "**NOTE 4**"

	The conversion from Hartrees (Eh or Ha) to kJ/mol to multiply the Hartree energy by 2625.5 to get the energy in kJ/mol

The energy profile for this example is shown below

<figure markdown="span">
    <img src="Figures/6_Info/Energy_Profile.png?raw=true" alt="Energy Profile for this Example" width="600"/>
    <figcaption>Energy Profile for this Example</figcaption>
</figure>

Here: 

* The energy from the reactant to transition state is $-1967.01474746 \rm{Eh} - -1967.08223843 \rm{Eh} = 0.06749096999 \rm{Eh}$ which in kJ/mol is $0.06749096999 \rm{Eh} \times 2625.5 = 177.2 \rm{kJ/mol}$ (1dp).
* The energy from the product  to transition state is $-1967.01474746 \rm{Eh} - -1967.03515273 \rm{Eh} = 0.02040526999 \rm{Eh}$ which in kJ/mol is $0.02040526999 \rm{Eh} \times 2625.5 = 53.6  \rm{kJ/mol}$ (1dp).

From this result, the activation energy for this reaction is 177 kJ/mol. 

