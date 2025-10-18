# Before You Begin

We will now perform the machanistic investigation procedure in ORCA. We will 

* Present the example that we will use to describe the steps to this procedure
* Indicate what settings you would include in all your ``inp`` files for this procedure
* Present the steps for performing the machanistic investigation procedure

## Mechanistic Step Example

For this tutorial, we will be using this procedure to understand the following mechanistic step. Here, we want to determine the transition state for a Cu<sup>+</sup> atom inserting itself into the alpha C-H bond in benzylamine. 

<figure markdown="span">
    <img src="Figures/Mechanistic_Step_Example/Split_Mechanistic_Steps_Step_2.png?raw=true#only-light" alt="Mechanistic Step Example" width="600"/>
    <img src="Figures/Mechanistic_Step_Example/Split_Mechanistic_Steps_Step_2_Dark.png?raw=true#only-dark"  alt="Mechanistic Step Example" width="600"/>
    <figcaption>Mechanistic Step Example.</figcaption>
</figure>

## What You Need to Consider Before Beginning

Before beginning, you need to decide what universal setting you want to use for your mechanisms. This includes:

* what functional you want to use, 
* what basis set you want to use, 
* if you want to use a solvent model, and if so what model and solvent you want to include, 
* etc...

```title="Example of functional, basis set, and solvent model included in the ORCA input script."
!B3LYP DEF2-TZVP D3BJ
%CPCM EPSILON 6.02 REFRAC 1.3723 END
```

Other options that are good to include in all your ORCA input files are:

```title="Options that are good to add into your ORCA input files. You may need to change these if you have convergence issues."
%SCF
    MaxIter 2000       # Here setting MaxIter to a very high number. Intended for systems that require sometimes 1000 iterations before converging (very rare).
    DIISMaxEq 5        # Default value is 5. A value of 15-40 necessary for difficult systems.
    directresetfreq 15 # Default value is 15. A value of 1 (very expensive) is sometimes required. A value between 1 and 15 may be more cost-effective.
END
%PAL NPROCS 32 END # The number of CPUs you want ORCA to use
%maxcore 2000 # This indicates you want ORCA to use only 2GB per core maximum, so ORCA will use only 2GB*32=64GB of memory in total.
```

!!! tip "RECOMMENDATIONS"

    With regards to the functional, basis set, solvent model, etc., it is recommended that you discuss what you are wanting to do with a computational chemist (if you are not a computational chemist) to get advice about what functional, basis set, solvent model, etc are most appropriate for your project and the questions you are wanting to answer using ORCA. 

    * It is important to make these choices before beginning your calculations, as you will need to keep these settings consistent across all the mechanistic steps you want to perform. 

    I would personally recommend reading several computational papers that are related to the system you are looking at understanding, as well as reading the following papers to understand what functional and basis set is most appropriate for your project:
    
    * https://onlinelibrary.wiley.com/doi/epdf/10.1002/anie.202205735 (This paper is VERY recommended to non-computational chemists and computational chemist. It is a very good guide at all the considerations you should make and best practices)
    * https://pubs.rsc.org/en/content/articlelanding/2017/cp/c7cp04913g (The results section (particularly the end of the results section) provides a list of good functionals to use based on scientific validations)
    * https://bpb-ap-se2.wpmucdn.com/blogs.unimelb.edu.au/dist/0/196/files/2021/05/GOERIGK_GroundStateDFT_RACI2021_handout.pdf (Slides from Larz Goerik based on the paper above)
    * https://www.publish.csiro.au/CH/CH20093 (This paper give an idea of what you need to think about for excited state calculations)

## The ORCA Documentation and Other Resources

It is a good idea to have the ORCA manual on hand to figure out what keywords to give in your ``orca.inp`` file that you would like to use for your calculations, as well as to help toubleshoot problems that arise when you run your ORCA jobs. 

!!! note

    You can download the ORCA manual for the Github page by [clicking here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/orca_manual_6_1_0.pdf?raw=true).

There are other resources which are great to read for help and troubleshooting. Here are some of these resources:

* The ORCA Input Library: https://sites.google.com/site/orcainputlibrary
* ORCA tutorials from orcasoftware.de: https://www.faccts.de/docs/orca/6.0/tutorials/



