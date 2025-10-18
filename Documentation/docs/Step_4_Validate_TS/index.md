# Step 4: Validate the Transition State

Now that we have a transition state, we need to confirm that this is the transition state for this mechanistic step. 

* We need to check this because the transition state we have obtained may not connect the reactant to the product. 

We will use the intrinsic reaction coordinate (IRC) method to check this is the transition state we are looking for. This method works by:

1. Nudging the transition state slightly along each direction of the negative frequency eigenvector. This gives two nudged versions of the transition state, called the ``forward`` and ``backward`` states. Then, 
2. Perform a geometric optimisation upon both the ``forward`` and ``backward`` states. These two calculations will optimise into a local minimum.
3. If everything goes well, one of the optimised ``forward`` and ``backward`` states will resemble the ``reactant``, and the other will resemble the ``product``. 

<figure markdown="span">
    <img src="../Figures/4A_IRC/IRC_Step_on_PES.png?raw=true" alt="Mechanistic step on Potential Energy Surface" width="750"/>
    <figcaption>Mechanistic step on Potential Energy Surface (Image adapted from [J. A. Keith, V. Vassilev-Galindo, B. Cheng, S. Chmiela, M. Gastegger, K.-R. Müller, and A. Tkatchenko; Chem. Rev. 2021, 121, 16, 9816–9872](https://doi.org/10.1021/acs.chemrev.1c00107)).</figcaption>
</figure>

!!! note

    The x and y axis given as R<sub>1</sub> and R<sub>2</sub> in the image above just indicate there is a change in spatial coordinates of the atoms in your molecule going from the reactant to the product. 

## How to Validate the Transition State

There are two main substeps that will be performed here:

1. Perform the [intrinsic reaction coordinate (IRC) method](Step_4A_The_IRC_Method.md) to obtain the forward and backwards states from the transition state.
2. [Geometrically optimise the forward and backwards states](Step_4B_Local_Optimisation.md) obtained from the IRC method, and check that they resemble the reactant and product obtained in [Step 1](../Step_1_Locally_Optimise_Reactant_and_Product.md#step-1-locally-optimise-reactant-and-product). 