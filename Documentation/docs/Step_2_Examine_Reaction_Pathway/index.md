# Step 2: Examine the Reaction Pathway

Next, we want to determine what the path that the mechanistic step takes and obtain the transition state for this step. 

* If you have two or more reactants/products that you would like to react together, you will first want to append them into the same xyz file.
* **See [Step 2A - Prepare Reaction System](Step_2A_Prepare_The_Reaction_System.md) to learn more about preparing the xyz file for your reaction system when dealing with two or more reactants/products**.

Once you have prepared your reaction system or you are happy with the xyz file that you will use, you will want to examine the reaction pathway for your mechanistic step of interest. **There are two methods for doing this**:

<div class="grid cards" markdown>

-   __Step 2Ba - The SCAN method__

    ---

    This method works by gradually changing the distance between two atoms (or the bonding angle between three atoms) to force atoms to rearrange or bonds to form/break.

    [:octicons-arrow-right-24: Click here to learn how to run a SCAN job](Step_2Ba_The_SCAN_Method.md)

-   __Step 2Bb - The Nudged Elastic Band (NEB) method__

    ---

    This method works by tracing a number of images across the mechanism from reactant to product, and optimising the images across the potential energy surface (PES). 

    [:octicons-arrow-right-24: Click here to learn how to run a NEB job](Step_2Bb_The_NEB_Method.md)

</div>

**Choose one of these methods for this step**.

!!! tip "Recommendation"

	I usually perform the SCAN method rather than the NEB method. This is because the NEB method is a bit more involved and requires some preprocessing before running the actual NEB calculation. The SCAN method is a bit more straight-forward. 

	1. Try running the SCAN method first.
	2. If you have difficulty using the SCAN method for your system, or you think your mechanism is more complicate than a single bond forming/breaking event, switch to using the NEB method. 