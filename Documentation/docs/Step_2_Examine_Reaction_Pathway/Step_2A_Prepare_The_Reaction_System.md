# Step 2A - Prepare The Reaction System

Consider that you have a mechanistic step that contains two or more reactants/products. To perform Step 2 (either by performing a [SCAN](Step_2Ba_The_SCAN_Method.md) or [Nudged Elastic Band](Step_2Bb_The_NEB_Method.md) calculation), you will need to place all your reactants/all your products into the same xyz file. 

This section will look at how to append multiple chemical systems in various xyz files together so that you can examine the reaction pathway in wither [Step 2Ba - SCAN](Step_2Ba_The_SCAN_Method.md) or [Step 2Bb - Nudged Elastic Band](Step_2Bb_The_NEB_Method.md). 

## Step 2A.1 - Move the Centre of Masses of your Chemical Systems

Before we combine multiple chemical systems together, we need to make sure that we dont accidently place one molecule in the middle of another molecule. The easiest way to solve this problem is to move the centre of mass of your chemical systems some distance apart from each other. You can do this by using the ``viewORCA move_com`` module. To run this module: 

1. Change directory into the folder containing the ``xyz`` files of the chemical systems you want to change the centre of masses of.
2. Run the ``viewORCA move_com filepath --move_com_to=move_com_to`` module as shown below, where ``filepath`` is the path to the ``xyz`` file you would like to move the centre of mass of, and ``move_com_to`` is the $(x,y,z)$ coordinates where you would like to move the centre of mass of your system to. 
	* **Note**: The format of ``move_com_to`` should be ``x,y,z``. i.e: ``move_com_to=x,y,z``

```bash
# First, change directory to the folder that contains the xyz files that yuou want to change the centre of masses of.
cd folder_containing_xyz_files

# Second, move the centre of mass of your chemical system
viewORCA move_com filepath --move_com_to=move_com_to
```

The ``viewORCA move_com`` module will create a new xyz file that contains ``move_com_to`` in the filename. This ``xyz`` file will contain your chemical system with its centre of mass moved to move_com_to.

!!! example

	Suppose that we have a Cu(II)-Benzylimine that we want to react with Benzylamine. We decide that we want the Cu(II)-Benzylimine to be centred at the origin while we want Benzylamine to be centered at $(10.0, 0.0, 0.0)$. To do this we would do the following in the terminal:

	```bash
	# First, change directory to the folder that contains the Cu(II)-Benzylimine and Benzylamine xyz files.
	cd folder_containing_xyz_Benzylamine.xyz

	# Second, move the centre of mass of Cu(II)-Benzylimine to the origin (0,0,0).
	viewORCA move_com Cu_II-BnzImine_1+.xyz --move_com_to=0,0,0

	# Third, move the centre of mass of Benzylamine to (10,0,0).
	viewORCA move_com Benzylamine.xyz --move_com_to=10,0,0
	```

	``viewORCA move_com`` will move the centre of masses of Cu(II)-Benzylimine and Benzylamine and save them into the files called ``Cu_II-BnzImine_1+_com_0_0_0.xyz`` and ``Benzylamine_com_10.0_0.0_0.0.xyz``. This example is given in [Examples/Step2_Find_TS/Step_2A/Step_2A1_Move_COM](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Examples/Step2_Find_TS/Step_2A/Step_2A1_Move_COM).

	<figure markdown="span">
	    <img src="../Figures/2A_Prepare_Chemical_System/Step2A1_Move_COM/Cu_II-BnzImine_1+/viewORCA_move_com.png?raw=true" alt="viewORCA_move_com.png" width="700"/>
	    <figcaption>Image of Cu(II)-Benzylimine before and after its centre of mass is moved.</figcaption>
	</figure>

	<figure markdown="span">
	    <img src="../Figures/2A_Prepare_Chemical_System/Step2A1_Move_COM/Benzylamine/viewORCA_move_com.png?raw=true" alt="viewORCA_move_com.png" width="700"/>
	    <figcaption>Image of Benzylamine before and after its centre of mass is moved.</figcaption>
	</figure>


## Step 2A.2 - Combine your ``xyz`` files into One Chemical System

Now that we have moved our molecules in Step 2A.1, we can now combine them together knowing that they wont accidently merge together. There are two ways to do this:


### Option 1: Use ``viewORCA combine``

The first option is to use ``viewORCA combine`` to combine multiple ``xyz`` files together. To do this:

1. In the terminal, change directory into the directory containing the xyz files of the chemical systems you want to combine together. 
2. type ``viewORCA combine filepath_for_system_1 filepath_for_system_2 filepath_for_system_3 ...`` into the terminal, where:
	
	* ``filepath_for_system_1, filepath_for_system_2, ...`` are the paths to all the xyz files you would like to combine together.  

``viewORCA combine`` will print the shortest distances between the chemical system you combine together so you know they are a good distance from each other. If you see that any distance is less than 3.0 Å, you may have accidently merged your chemical systems together. 

The output file will be save into your current working directory as ``overall_chemical_system.xyz``. **Check you have not accidently merged your chemical systems by looking at the xyz file in a GUI (like Avogadro or ``ase gui``)**. Once you are happy with the contents of this file, change the filename of this ``xyz`` file to what you want it to be named. 

!!! example

	Say we want to combine an ``xyz`` file containing a Cu(II)-benzylimine molecule (with centre of mass = $(0.0, 0.0, 0.0)$) with another ``xyz`` file containing a benylamine molecule (with centre of mass = $(10.0, 0.0, 0.0)$). We would run the code below to achieve this:

	```bash
	# First, change directory into the folder containing your xyz files you want to combine together. 
	cd path_to_xyz_files

	# Second, run "viewORCA move_com".
	viewORCA combine Benzylamine_com_10.0_0.0_0.0.xyz Cu_II-BnzImine_1+_com_0_0_0.xyz
	```

	``viewORCA combine`` will print the shortest distances between the chemical system you combine together so you know they are a good distance from each other. If you see that any distance is less than 3.0 Å, you may have accidently merged your chemical systems together. 

	You will also see a new file has been made called ``overall_chemical_system.xyz`` that contains your overall chemical system. This example is given in [Examples/Step2_Find_TS/Step_2A/Step_2A2_Combine](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Examples/Step2_Find_TS/Step_2A/Step_2A2_Combine).

	<figure markdown="span">
	    <img src="../Figures/2A_Prepare_Chemical_System/Step2A2_Combine/combine.png?raw=true" alt="combine.png" width="1000"/>
	    <figcaption>Combining Benzylamine and Cu(II)-benzylimine into one xyz file.</figcaption>
	</figure>


### Option 2: Copy the coordinates of one ``xyz`` file into another ``xyz`` file

The other way to combine multiple ``xyz`` files together is to copy and paste each ``xyz`` file one after the other in a new xyz ``file``. This is what is happening in [Option 1: Use ``viewORCA combine``](Step_2A_Prepare_The_Reaction_System.md#option-1-use-vieworca-combine), but done automatically by ``viewORCA``. 

* If you do this, make sure you change the first line in your ``xyz`` file to the total number of atoms in your combined system.

!!! example

	Consider now that we want to manually combine the xyz file for Cu(II)-benzylimine molecule (with centre of mass = $(0.0, 0.0, 0.0)$) with another ``xyz`` file containing a benylamine molecule (with centre of mass = $(10.0, 0.0, 0.0)$). 

	```txt title="Benzylamine_com_10.0_0.0_0.0.xyz"
	--8<-- "docs/Step_2_Examine_Reaction_Pathway/Step_2A2_Combine_Option_2_files/Benzylamine_com_10.0_0.0_0.0.xyz"
	```

	```txt title="Cu_II-BnzImine_1+_com_0_0_0.xyz"
	--8<-- "docs/Step_2_Examine_Reaction_Pathway/Step_2A2_Combine_Option_2_files/Cu_II-BnzImine_1+_com_0_0_0.xyz"
	```

	To do this, we open a new file in our text editor (such as [``Sublime``](https://www.sublimetext.com/)), and copy the elements and positions of all the atoms in Benzylamine_com_10.0_0.0_0.0.xyz, then do the same for ``Cu_II-BnzImine_1+_com_0_0_0.xyz``. 

	At the top of this new file, we will need to add two lines:

	1. The first line indicates the number of atoms in this combined system, which in this case is ``32``
	2. The second line indicates what information about the atoms given in this file (i.e., the element and $(x,y,z)$ position). This should be ``Properties=species:S:1:pos:R:3 pbc="F F F"`` (``pbc`` here indicates there is no periodic boundary condition set).

	```txt title="overall_chemical_system.xyz"
	--8<-- "docs/Step_2_Examine_Reaction_Pathway/Step_2A2_Combine_Option_2_files/overall_chemical_system.xyz"
	```

