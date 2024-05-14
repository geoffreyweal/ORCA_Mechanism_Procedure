# Procedure for Investigating Chemical Mechanisms with ORCA

This page describes the procedure for investigating mechanistic steps for mechanisms in chemistry using ORCA.

<div class="grid cards" markdown>

- <p align="center"> <font size="+1"> :mag: <b>Goal: To find the transition state of a mechanistic step.</b> </font> </p>

</div>

## Background

We are wanting to find the transition state for a single mechanistic step. Visually, we are trying to find a 1st order saddlepoint to get from the reactant to the product on the potential energy surface (See image below). In this procedure/tutorial, we will look at how to obtain the transition state using ORCA.

<figure markdown="span">
    <img src="Figures/Potential_Energy_Surface/Mechanistic_Step_on_PES.png?raw=true#only-light" alt="Mechanistic step on Potential Energy Surface" width="750"/>
    <img src="Figures/Potential_Energy_Surface/Mechanistic_Step_on_PES.png?raw=true#only-dark"  alt="Mechanistic step on Potential Energy Surface" width="750"/>
    <figcaption>Mechanistic Step Example (Image adapted from [J. A. Keith, V. Vassilev-Galindo, B. Cheng, S. Chmiela, M. Gastegger, K.-R. Müller, and A. Tkatchenko; Chem. Rev. 2021, 121, 16, 9816–9872]( https://doi.org/10.1021/acs.chemrev.1c00107)).</figcaption>
</figure>

!!! note
    
    The x and y axis given as R<sub>1</sub> and R<sub>2</sub> in the image above just indicate there is a change in spatial coordinates of the atoms in your molecule going from the reactant to the product. 


## General Steps

The general steps that we will follow in this procedure are:

1. Locally optimise the reactants and products to their ground state.
2. Obtain the transition state by using either the SCAN or NEB method.
3. Optimise the transition state.
4. Validate the transition state using the IRC method. 
5. Perform some final checks, and then obtain the structures and energies of your reactants, products, and transition state for presentation. 

Repeat steps 2-4 until you find the transition state for your mechanism. Sometimes it requires a bit of playing around. 

!!! tip "**IMPORTANT**"

	Before you begin, make sure you have read the [What You Need to Consider Before Beginning](Before_You_Begin.md#what-you-need-to-consider-before-beginning) section. This section gives what decisions and considerations you need to make before performing this procedure on your reaction mechanisms. 

## ORCA

I have written this procedure for: 

* ORCA 5.0.4
* ORCA 5.0.3

This method should be valid for future versions of ORCA, but just in case any problems occur it may be due to ORCA version issues. 


## Programs to Install

There are several programs that you should install on your computer for running this procedure. See the [Programs to Install](Programs_to_Install.md) guide to learn about what programs to install and how to install them on your computer.


## ORCA Templates 

[This folder](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Templates) contains all the templates for running all ORCA jobs for this procedure. 

!!! tip "IMPORTANT"

	**You should [download these templates from here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Templates) and customise them for your needs.**

	Make sure that you change the ORCA settings in the ``.inp`` files for your specifications, such as the functional, basis set, solvent model, etc. See the [Before You Begin](Before_You_Begin.md#what-you-need-to-consider-before-beginning) section for more information about the various ORCA settings for the ``.inp`` file.


## Examples

You can find examples of completed ORCA jobs for each step in this procedure [here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/tree/main/Examples). These files will be referenced in this repository as examples of what you expect to see as you work this procedure.


## Questions, Feedback, and Things to Add

I am very keen for feedback about how you find the information in this github page, both the process and the clarity of what I have written. If you have any questions about this process, feed free to write me a message.

To do this, open the [``Issues`` Github webpage](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/issues), click the ``New issue`` button, and write you question/give you feedback. 

* Also if there are any features that you would like added to this procedure or to the ``viewORCA`` program, write them in the [``Issues`` section](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/issues).

Thanks!

