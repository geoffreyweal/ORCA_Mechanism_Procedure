# ``viewORCA`` Manual

The ``viewORCA`` program is designed to allow the user to view ORCA calculations. 

* To install ``viewORCA``, see the [viewORCA installation webpage](Programs_to_Install.md#the-vieworca-program). 
* You can see the [Github repository here](https://github.com/geoffreyweal/viewORCA).

Run ``viewORCA`` by typing ``viewORCA`` into the terminal

```bash
viewORCA
```

If you want ``viewORCA`` to provide help information, type ``viewORCA --help`` into the terminal

```bash
username@computer name Desktop % viewORCA --help
usage: viewORCA [-h] [-T] {help,opt,scan,neb,irc} ...

Program for viewing jobs from ORCA

optional arguments:
  -h, --help            show this help message and exit
  -T, --traceback

Sub-commands:
  {help,opt,scan,neb,irc}
    help                Help for sub-command.
    opt                 This method is designed to allow the user to view the output of an ORCA geometric
                        optimisation job visually.
    scan                This method is designed to allow the user to view the output of an ORCA SCAN job
                        visually.
    neb                 This method is designed to allow the user to view the output of an ORCA geometric
                        optimisation job visually.
    irc                 This method is designed to allow the user to view the output of an ORCA IRC job
                        visually.
```

There are several modules available for viewing ORCA calculations. 

## ``viewORCA opt``: View Geometric Optimisation Calculation

This method is designed to allow the user to view the output of an ORCA geometric optimisation job visually. 

* Included are the images of the optimisation, along with the energy profile of the optimisation. 
* This program will also create an xyz file called ``OPT_images.xyz`` that contains the images and the energy profile from the optimisation. You can view this by typing ``ase gui OPT_images.xyz`` into the terminal

	```bash
	ase gui OPT_images.xyz
	```

Optional inputs for ``viewORCA opt`` include:

* ``--path``: This is the path to the folder containing the ORCA optimisation calculation. If not given, the default path is the current directory you are in. 
* ``--view``: If tag indicates if you want to view the ASE GUI for the optimisation job immediate after this program has run. By default this is ``True``. If you only want to create the ``OPT_images.xyz`` file and not view it immediately, set this to ``False``.
	* Setting this to ``False`` is ideal if you are running ``viewORCA`` on an HPC, where ``ase gui`` windows may be more responsive if ``ase gui`` is run from your own computer rather than directly on the HPC. 
	* You can view ``OPT_images.xyz`` on your computer by typing the following into the terminal: ``ase gui OPT_images.xyz``.

???+ example

	An example of a geometric optimisation viewed using ``viewORCA opt`` is shown below, along with the energy profile for this optimisation.

	<figure markdown="span">
	<img src="Figures/view_ORCA_Manual/opt/optimisation.gif?raw=true" alt="NEB Images from a geometric optimisation" width="600"/>
	<figcaption>NEB Images from a geometric optimisation</figcaption>
	</figure>

	The energy profile for this example is given below:

	<figure markdown="span">
	    <img src="Figures/view_ORCA_Manual/opt/energy_profile.png?raw=true" alt="Energy Profile from a geometric optimisation" width="600"/>
	    <figcaption>Energy Profile from a geometric optimisation</figcaption>
	</figure>


## ``viewORCA scan``: View SCAN Calculation

This method is designed to allow the user to view the output of an ORCA SCAN job visually. 

* Included are the images of the SCAN calculation, along with the energy profile of the SCAN calculation. 
* This program will also create an xyz file called ``SCAN_images.xyz`` that contains the images and the energy profile from the SCAN calculation. You can view this by typing ``ase gui SCAN_images.xyz`` into the terminal

	```bash
	ase gui SCAN_images.xyz
	```

Optional inputs for ``viewORCA scan`` include:

* ``--path``: This is the path to the folder containing the ORCA SCAN calculation. If not given, the default path is the current directory you are in. 
* ``--view``: If tag indicates if you want to view the ASE GUI for the SCAN job immediate after this program has run. By default this is ``True``. If you only want to create the ``SCAN_images.xyz`` file and not view it immediately, set this to ``False``.
	* Setting this to ``False`` is ideal if you are running ``viewORCA`` on an HPC, where ``ase gui`` windows may be more responsive if ``ase gui`` is run from your own computer rather than directly on the HPC. 
	* You can view ``SCAN_images.xyz`` on your computer by typing the following into the terminal: ``ase gui SCAN_images.xyz``.

???+ example

	An example of a SCAN calculation viewed using ``viewORCA scan`` is shown below, along with the energy profile for this SCAN calculation.

	<figure markdown="span">
	<img src="Figures/view_ORCA_Manual/scan/SCAN_example.gif?raw=true" alt="NEB Images from a SCAN calculation" width="600"/>
	<figcaption>NEB Images from a SCAN calculation</figcaption>
	</figure>

	The energy profile for this example is given below:

	<figure markdown="span">
	    <img src="Figures/view_ORCA_Manual/scan/SCAN_energy.png?raw=true" alt="Energy Profile from a SCAN calculation" width="600"/>
	    <figcaption>Energy Profile from a SCAN calculation</figcaption>
	</figure>


## ``viewORCA neb``: View Nudged Elastic Band (NEB) Calculation

This method is designed to allow the user to view the output of an ORCA NEB job visually. 

* Included are the images of the NEB calculation, along with the energy profile of the NEB calculation. 
* This program will also create an xyz file called ``NEB_images.xyz`` that contains the images and the energy profile from the NEB calculation. You can view this by typing ``ase gui NEB_images.xyz`` into the terminal

	```bash
	ase gui NEB_images.xyz
	```

Optional inputs for ``viewORCA neb`` include:

* ``--path``: This is the path to the folder containing the ORCA NEB calculation. If not given, the default path is the current directory you are in. 
* ``--view``: If tag indicates if you want to view the ASE GUI for the NEB job immediate after this program has run. By default this is ``True``. If you only want to create the ``NEB_images.xyz`` file and not view it immediately, set this to ``False``.
	* Setting this to ``False`` is ideal if you are running ``viewORCA`` on an HPC, where ``ase gui`` windows may be more responsive if ``ase gui`` is run from your own computer rather than directly on the HPC. 
	* You can view ``NEB_images.xyz`` on your computer by typing the following into the terminal: ``ase gui NEB_images.xyz``.

???+ example

	An example of a NEB calculation viewed using ``viewORCA neb`` is shown below, along with the energy profile for this NEB calculation.

	<figure markdown="span">
	<img src="Figures/view_ORCA_Manual/neb/NEB_example.gif?raw=true" alt="NEB Images from a NEB calculation" width="500"/>
	<figcaption>NEB Images from a NEB calculation</figcaption>
	</figure>

	The energy profile for this example is given below:

	<figure markdown="span">
	    <img src="Figures/view_ORCA_Manual/neb/NEB_energy.png?raw=true" alt="Energy Profile from a NEB calculation" width="600"/>
	    <figcaption>Energy Profile from a NEB calculation</figcaption>
	</figure>


## ``viewORCA irc``: View ntrinsic Reaction Coordinate (IRC) Calculation

This method is designed to allow the user to view the output of an ORCA IRC job visually. 

* Included are the images of the IRC calculation, along with the energy profile of the IRC calculation. 
* This program will also create an xyz file called ``IRC_images.xyz`` that contains the images and the energy profile from the IRC calculation. You can view this by typing ``ase gui IRC_images.xyz`` into the terminal

	```bash
	ase gui IRC_images.xyz
	```

Optional inputs for ``viewORCA irc`` include:

* ``--path``: This is the path to the folder containing the ORCA IRC calculation. If not given, the default path is the current directory you are in. 
* ``--view``: If tag indicates if you want to view the ASE GUI for the IRC job immediate after this program has run. By default this is ``True``. If you only want to create the ``SCAN_images.xyz`` file and not view it immediately, set this to ``False``.
	* Setting this to ``False`` is ideal if you are running ``viewORCA`` on an HPC, where ``ase gui`` windows may be more responsive if ``ase gui`` is run from your own computer rather than directly on the HPC. 
	* You can view ``IRC_images.xyz`` on your computer by typing the following into the terminal: ``ase gui IRC_images.xyz``.

???+ example

	An example of a IRC calculation viewed using ``viewORCA irc`` is shown below, along with the energy profile for this IRC calculation.

	<figure markdown="span">
	<img src="Figures/view_ORCA_Manual/irc/IRC_example.gif?raw=true" alt="NEB Images from a IRC calculation" width="500"/>
	<figcaption>NEB Images from a IRC calculation</figcaption>
	</figure>

	The energy profile for this example is given below:

	<figure markdown="span">
	    <img src="Figures/view_ORCA_Manual/irc/IRC_energy_original.png?raw=true" alt="Energy Profile from a IRC calculation" width="600"/>
	    <figcaption>Energy Profile from a IRC calculation</figcaption>
	</figure>




