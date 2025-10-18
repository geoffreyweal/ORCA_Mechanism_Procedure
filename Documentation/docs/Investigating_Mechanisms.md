# How to Investigate Reaction Mechanisms using ORCA

It is possible to investigate reaction mechanisms using ORCA, as long as you know what the mechanisms are that you want to investigate. You can:

* Obtain the activation energies of a mechanism, 
* Determine the rate determining step for a reaction mechanism, and
* Investigate multiple mechanisms for getting from a reactant to a product to determine the kinetically likely pathways.[^1]

!!! note

    You need to have some idea about your mechanism before hand. ORCA can not determine pathways automatically, it can only investigate potential mechanistic pathways that you give it to investigate. 

    * However, the mechanisms you propose don't have to be correct. ORCA can be used to determine if mechanisms are likely or not. 

[^1]: You can also investigate the thermodynamically-limiting reaction mechanisms as well using ORCA. This is generally easier to do as you don't have to understand kinetics to do this, which means you dont need to run all the steps you need to do here to obtain activation energies and transition states. 

## How do we Investigate Reaction Mechanisms using Computational Chemistry

To investigate reaction mechanisms using computational chemistry, we need to make sure we have clear mechanistic pathways that we can interrogate. 

For example, consider the following overall reaction:

<figure markdown="span">
    <img src="Figures/Investigating_Mechanisms/overall_reaction.png?raw=true#only-light" alt="Example Overall Reaction" width="800"/>
    <img src="Figures/Investigating_Mechanisms/overall_reaction_Dark.png?raw=true#only-dark"  alt="Example Overall Reaction" width="800"/>
    <figcaption>An example overall reaction.</figcaption>
</figure>

There are several ways that this mechanism could proceed. Here, it is important that we **give explicit details about how we believe this reaction reaction proceed**. Given below is an example of some of the ways this reaction could proceed, given in a mechanistic scheme:

<figure markdown="span">
    <img src="Figures/Investigating_Mechanisms/Example_Reaction_Mechanism.png?raw=true#only-light" alt="Example Reaction Mechanism Scheme" width="1000"/>
    <img src="Figures/Investigating_Mechanisms/Example_Reaction_Mechanism_Dark.png?raw=true#only-dark"  alt="Example Reaction Mechanism Scheme" width="1000"/>
    <figcaption>An example of reaction mechanism scheme for this overall reaction. This scheme give multiple pathways that this reaction could proceed. Only the beginning segment of the reaction mechanisms have been shown here.</figcaption>
</figure>

We can use ORCA to study each mechanistic step in this mechanistic scheme. The way to do this is to give a name to each step. An example of this is shown below:

<figure markdown="span">
    <img src="Figures/Investigating_Mechanisms/Example_Reaction_Mechanism_Named.png?raw=true#only-light" alt="Labelled Example Reaction Mechanism Scheme" width="1000"/>
    <img src="Figures/Investigating_Mechanisms/Example_Reaction_Mechanism_Named_Dark.png?raw=true#only-dark"  alt="Labelled Example Reaction Mechanism Scheme" width="1000"/>
    <figcaption>An example of reaction mechanism scheme for this overall reaction, where each mechanistic step has been labelled.</figcaption>
</figure>

It is important to set up your folder system very clearly, as you may be running lots of calculations at the same time and will be collecting a lot of information about numerous mechanistic steps. Below is the recommended way to set up your folder system for studying this example mechanism:

<figure markdown="span">
    <img src="Figures/Investigating_Mechanisms/Folder_Holding_Reaction_Mechanism_Investigation.png?raw=true" alt="Labelled Example Reaction Mechanism Scheme" width="800"/>
    <figcaption>An example of reaction mechanism scheme for this overall reaction, where each mechanistic step has been labelled.</figcaption>
</figure>

For the rest of this tutorial, we will focus on understanding the kinetics of just one of these mechanistic steps. In this example, we will focus on [Step C](Before_You_Begin.md#mechanistic-step-example). Read the [Before You Begin](Before_You_Begin.md) section to proceed with this tutorial. 
