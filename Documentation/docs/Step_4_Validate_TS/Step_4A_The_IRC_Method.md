# Step 4A: Validate the Transition State using the Intrinsic Reaction Coordinate (IRC) Method

!!! tip

    Download the template folder for this step by clicking the button below and work on the files in the template folder as you read through this tutorial. 

    [Download Templates.zip :octicons-download-24:](../Files/Templates.zip){ .md-button .md-button--primary :download }

To perform the IRC method, we want to include the following in the ``orca.inp`` file:

```
!IRC TightSCF defgrid2
```

We also want to include the following options for the IRC method:

```
%IRC
    MaxIter 2000
    InitHess calc_numfreq
    Direction both
    TolMAXG 2.e-3  # Max gradient (a.u.). Currently set to values equivalent to LooseOpt.
    TolRMSG 5.e-4  # RMS gradient (a.u.). Currently set to values equivalent to LooseOpt.
    PrintLevel 1
END
```

!!! note "Notes about the ``TolMAXG`` and ``TolRMSG`` keywords"

    1. The ``TightOPT`` keyword (and other geometric convergence like ``NormalOPT`` and ``LooseOPT``) does not work with ``IRC``. Instead, we include the ``TolMAXG`` and ``TolRMSG`` keywords in the ``orca.inp`` file. 
    2. It is recommended to set ``TolMAXG`` and ``TolRMSG`` to values equivalent to the ``LooseOPT`` keyword. This is because IRC can take a very long time to run to you use tighter convergence criteria. We will check the outputs from the IRC method with the ``TightOPT`` keyword in Step 4B. 
    3. While we are using the default setting ``TolMAXG`` and ``TolRMSG`` (set to that of ``LooseOPT``), you can change this. If you want to tighten the geometric convergence criteria for the IRC method, see the following below. However, for this procedure it is recommended to keep the ``LooseOPT`` settings for ``TolMAXG`` and ``TolRMSG``, and use tighter convergence settings in [Step 4B](Step_4B_Local_Optimisation.md). 

        ```
        # TolMAXG and TolRMSG settings for:

        LooseOpt
        TolMAXG 2.e-3  # Max gradient (a.u.). Currently set to values equivalent to LooseOpt.
        TolRMSG 5.e-4  # RMS gradient (a.u.). Currently set to values equivalent to LooseOpt.

        NormalOpt
        TolMAXG 3.e-4  # Max gradient (a.u.). Currently set to values equivalent to NormalOpt.
        TolRMSG 1.e-4  # RMS gradient (a.u.). Currently set to values equivalent to NormalOpt.

        TightOPT
        TolMAXG 1.e-4  # Max gradient (a.u.). Currently set to values equivalent to TightOPT.
        TolRMSG 3.e-5  # RMS gradient (a.u.). Currently set to values equivalent to TightOPT.

        ```

An example of the complete ``orca.inp`` file for running a IRC calculation in ORCA is given below (also [located here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4_Validate_TS/Step4A_IRC/orca.inp)): 

```title="Example of a ORCA input file for a IRC calculation"
!B3LYP DEF2-TZVP D3BJ
!IRC TightSCF defgrid2
%SCF
    MaxIter 2000       # Here setting MaxIter to a very high number. Intended for systems that require sometimes 1000 iterations before converging (very rare).
    DIISMaxEq 5        # Default value is 5. A value of 15-40 necessary for difficult systems.
    directresetfreq 15 # Default value is 15. A value of 1 (very expensive) is sometimes required. A value between 1 and 15 may be more cost-effective.
END
%CPCM EPSILON 6.02 REFRAC 1.3723 END
%PAL NPROCS 32 END
%maxcore 2000
%IRC
    MaxIter 2000
    InitHess calc_numfreq
    Direction both
    TolMAXG 1.e-4  # Max gradient (a.u.). Currently set to values equivalent to TightOPT.
    TolRMSG 3.e-5  # RMS gradient (a.u.). Currently set to values equivalent to TightOPT.
    PrintLevel 1
END
* xyzfile 1 1 TS.xyz

```

## Outputs from ORCA

ORCA will create a number of files. These are the important ones to looks at for the IRC method:

* ``output.out``: We will want to look at this file to make sure the IRC method has not run into any problems. 
* ``orca_IRC_F_trj.xyz``: This is the geometric optimisation steps performed for the forward step
* ``orca_IRC_B_trj.xyz``: This is the geometric optimisation steps performed for the backwards step
* ``orca_IRC_Full_trj.xyz``: This is the geometric optimisation steps performed for the full IRC method. This include the steps from the ``orca_IRC_B_trj.xyz`` and ``orca_IRC_F_trj.xyz`` files. 

!!! note

    You will find that the output from the ``Forward`` step maybe either the reactant or the product. So don't worry if the ``Forward`` step gives you your reactant. This only means that in that case your ``Backward`` step should be your product. 

**Once ORCA has finished, you want to do the following checks**:

### Check 1: Make sure the ``output.out`` file indicates the calculation finished successfully

Look at the end of the [``output.out`` file](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4_Validate_TS/Step4A_IRC/output.out#L2877) and makes sure there is some sort of message that says that ORCA finished successfully, like that below:

```title="Successful ORCA calculation message expected at the end of the ORCA output file"
****ORCA TERMINATED NORMALLY****
```

Also, make sure you see the following messages for the forward and reverse components of the calculation

```title="Example of HURRAY message indicating the IRC calculation completed successfully"
***********************HURRAY********************
***            THE IRC HAS CONVERGED          ***
*************************************************
```

See an [example of this below](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4_Validate_TS/Step4A_IRC/output.out#L2675):

```title="Example of IRC optimisation calculation text from the ORCA output file"
         *************************************************************
         *                          FORWARD IRC                      *
         *************************************************************

Iteration    E(Eh)      dE(kcal/mol)  max(|G|)   RMS(G) 
Convergence thresholds                0.002000  0.000500            
    0     -1967.123543   -0.979797    0.009308  0.001940
    1     -1967.125107   -1.961029    0.010517  0.002247
    2     -1967.125685   -2.324148    0.009427  0.002005
    3     -1967.126638   -2.922291    0.008829  0.001902
    4     -1967.127685   -3.579032    0.008935  0.001925
    5     -1967.128743   -4.242983    0.008811  0.001918
    6     -1967.129792   -4.901037    0.008480  0.001886
    7     -1967.130808   -5.538586    0.008103  0.001825
    8     -1967.131785   -6.151559    0.007581  0.001749
    9     -1967.132714   -6.734522    0.007043  0.001660
   10     -1967.133593   -7.286174    0.006451  0.001567
   11     -1967.134421   -7.805729    0.005867  0.001475
   12     -1967.135196   -8.292411    0.005297  0.001379
   13     -1967.135923   -8.748126    0.005132  0.001291
   14     -1967.136596   -9.170984    0.004920  0.001196
   15     -1967.137223   -9.564303    0.004676  0.001112
   16     -1967.137799   -9.925919    0.004390  0.001024
   17     -1967.138332   -10.259902    0.004096  0.000946
   18     -1967.138819   -10.565546    0.003785  0.000899
   19     -1967.139249   -10.835330    0.003514  0.000948
   20     -1967.139400   -10.929956    0.003402  0.000992
   21     -1967.139472   -10.975463    0.003359  0.000805
   22     -1967.139573   -11.038703    0.003294  0.000752
   23     -1967.139676   -11.103301    0.003226  0.000737
   24     -1967.139777   -11.166565    0.003160  0.000725
   25     -1967.139875   -11.228295    0.003094  0.000709
   26     -1967.139972   -11.288928    0.003030  0.000696
   27     -1967.140066   -11.348413    0.002966  0.000683
   28     -1967.140159   -11.406639    0.002904  0.000668
   29     -1967.140250   -11.463913    0.002843  0.000659
   30     -1967.140339   -11.519754    0.002784  0.000642
   31     -1967.140427   -11.574934    0.002725  0.000632
   32     -1967.140513   -11.628772    0.002668  0.000617
   33     -1967.140598   -11.681774    0.002611  0.000610
   34     -1967.140680   -11.733339    0.002555  0.000593
   35     -1967.140761   -11.784354    0.002500  0.000584
   36     -1967.140840   -11.834091    0.002445  0.000571
   37     -1967.140918   -11.883058    0.002391  0.000562
   38     -1967.140994   -11.930757    0.002338  0.000548
   39     -1967.141069   -11.977763    0.002283  0.000540
   40     -1967.141142   -12.023625    0.002231  0.000526
   41     -1967.141214   -12.068727    0.002177  0.000517
   42     -1967.141284   -12.112766    0.002126  0.000505
   43     -1967.141353   -12.155984    0.002072  0.000495
   44     -1967.141421   -12.198270    0.002021  0.000484
   45     -1967.141487   -12.239663    0.001968  0.000474

                      ***********************HURRAY********************
                      ***            THE IRC HAS CONVERGED          ***
                      *************************************************


         *************************************************************
         *                          BACKWARD IRC                     *
         *************************************************************

Iteration    E(Eh)      dE(kcal/mol)  max(|G|)   RMS(G) 
Convergence thresholds                0.002000  0.000500            
    0     -1967.124311   -1.461728    0.013600  0.003053
    1     -1967.128051   -3.808494    0.019714  0.004397
    2     -1967.133340   -7.127757    0.025829  0.005526
    3     -1967.139701   -11.118892    0.028311  0.006052
    4     -1967.146117   -15.145537    0.025173  0.005719
    5     -1967.151801   -18.711772    0.021770  0.004970
    6     -1967.156328   -21.552647    0.019496  0.003996
    7     -1967.160222   -23.995928    0.017140  0.003405
    8     -1967.163541   -26.079063    0.014761  0.002952
    9     -1967.166543   -27.962685    0.012861  0.002663
   10     -1967.169310   -29.699090    0.011409  0.002469
   11     -1967.171890   -31.318299    0.010454  0.002305
   12     -1967.174306   -32.834058    0.009581  0.002151
   13     -1967.176514   -34.219361    0.008704  0.001979
   14     -1967.178474   -35.449270    0.007565  0.001857
   15     -1967.180070   -36.450828    0.006486  0.002120
   16     -1967.180383   -36.647601    0.006324  0.001676
   17     -1967.181098   -37.096403    0.006063  0.001440
   18     -1967.181826   -37.552813    0.005805  0.001339
   19     -1967.182504   -37.978531    0.005485  0.001245
   20     -1967.183123   -38.366555    0.005144  0.001163
   21     -1967.183672   -38.711135    0.004725  0.001095
   22     -1967.184138   -39.003554    0.004304  0.001179
   23     -1967.184249   -39.073229    0.004180  0.000973
   24     -1967.184460   -39.205562    0.003928  0.000823
   25     -1967.184673   -39.339210    0.003658  0.000768
   26     -1967.184868   -39.461483    0.003377  0.000705
   27     -1967.185048   -39.574485    0.003127  0.000649
   28     -1967.185213   -39.678191    0.002876  0.000597
   29     -1967.185364   -39.773179    0.002658  0.000556
   30     -1967.185501   -39.858798    0.002432  0.000539
   31     -1967.185617   -39.931798    0.002267  0.000595
   32     -1967.185652   -39.953849    0.002204  0.000520
   33     -1967.185706   -39.987374    0.002116  0.000434
   34     -1967.185763   -40.023646    0.002029  0.000418
   35     -1967.185819   -40.058388    0.001937  0.000401

                      ***********************HURRAY********************
                      ***            THE IRC HAS CONVERGED          ***
                      *************************************************
```

### Check 2: Make sure that the energies of each geometric optimisation step is less than the transition step from the ``output.out`` file

We want to make sure that the energy of our transition state is in fact lower than all points along the energy profile. This is because:

* The IRC method works by initially pushing the molecule down the saddle of the potential energy surface towards the reactant and product minima, so the energy should have decreased from transition state in the forward and backwards directions. 

To do this, you want to look at the ``IRC PATH SUMMARY`` in your output file and make sure your transition state (``TS``) is the highest energy step in the IRC path. 

The transition state should be the number of the final ``Convergence Iteration`` from the backwards step, plus 2. [In this example](Step_4A_The_IRC_Method.md#check-1-make-sure-the-outputout-file-indicates-the-calculation-finished-successfully), our ``BACKWARD IRC`` process required 35 geometry optimisation steps, so we expect our transition state to be at step 37 in the ``IRC PATH SUMMARY`` table. 

Below show an [example of this from ``Examples/Step4_Validate_TS/Step4A_IRC/output.log``](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4_Validate_TS/Step4A_IRC/output.out#L2781). You can see that the transition step occurs at step 37, as expected. We also see that the energy of the transition state is the largest for all steps. 

```title="Example of IRC PATH SUMMARY text from the ORCA output file"
---------------------------------------------------------------
                       IRC PATH SUMMARY              
---------------------------------------------------------------
All gradients are in Eh/Bohr.

Step        E(Eh)      dE(kcal/mol)  max(|G|)   RMS(G) 
   1     -1967.185819   -40.058388    0.001937  0.000401
   2     -1967.185763   -40.023646    0.002029  0.000418
   3     -1967.185706   -39.987374    0.002116  0.000434
   4     -1967.185652   -39.953849    0.002204  0.000520
   5     -1967.185617   -39.931798    0.002267  0.000595
   6     -1967.185501   -39.858798    0.002432  0.000539
   7     -1967.185364   -39.773179    0.002658  0.000556
   8     -1967.185213   -39.678191    0.002876  0.000597
   9     -1967.185048   -39.574485    0.003127  0.000649
  10     -1967.184868   -39.461483    0.003377  0.000705
  11     -1967.184673   -39.339210    0.003658  0.000768
  12     -1967.184460   -39.205562    0.003928  0.000823
  13     -1967.184249   -39.073229    0.004180  0.000973
  14     -1967.184138   -39.003554    0.004304  0.001179
  15     -1967.183672   -38.711135    0.004725  0.001095
  16     -1967.183123   -38.366555    0.005144  0.001163
  17     -1967.182504   -37.978531    0.005485  0.001245
  18     -1967.181826   -37.552813    0.005805  0.001339
  19     -1967.181098   -37.096403    0.006063  0.001440
  20     -1967.180383   -36.647601    0.006324  0.001676
  21     -1967.180070   -36.450828    0.006486  0.002120
  22     -1967.178474   -35.449270    0.007565  0.001857
  23     -1967.176514   -34.219361    0.008704  0.001979
  24     -1967.174306   -32.834058    0.009581  0.002151
  25     -1967.171890   -31.318299    0.010454  0.002305
  26     -1967.169310   -29.699090    0.011409  0.002469
  27     -1967.166543   -27.962685    0.012861  0.002663
  28     -1967.163541   -26.079063    0.014761  0.002952
  29     -1967.160222   -23.995928    0.017140  0.003405
  30     -1967.156328   -21.552647    0.019496  0.003996
  31     -1967.151801   -18.711772    0.021770  0.004970
  32     -1967.146117   -15.145537    0.025173  0.005719
  33     -1967.139701   -11.118892    0.028311  0.006052
  34     -1967.133340   -7.127757    0.025829  0.005526
  35     -1967.128051   -3.808494    0.019714  0.004397
  36     -1967.124311   -1.461728    0.013600  0.003053
  37     -1967.121981    0.000000    0.000025  0.000010 <= TS
  38     -1967.123543   -0.979797    0.009308  0.001940
  39     -1967.125107   -1.961029    0.010517  0.002247
  40     -1967.125685   -2.324148    0.009427  0.002005
  41     -1967.126638   -2.922291    0.008829  0.001902
  42     -1967.127685   -3.579032    0.008935  0.001925
  43     -1967.128743   -4.242983    0.008811  0.001918
  44     -1967.129792   -4.901037    0.008480  0.001886
  45     -1967.130808   -5.538586    0.008103  0.001825
  46     -1967.131785   -6.151559    0.007581  0.001749
  47     -1967.132714   -6.734522    0.007043  0.001660
  48     -1967.133593   -7.286174    0.006451  0.001567
  49     -1967.134421   -7.805729    0.005867  0.001475
  50     -1967.135196   -8.292411    0.005297  0.001379
  51     -1967.135923   -8.748126    0.005132  0.001291
  52     -1967.136596   -9.170984    0.004920  0.001196
  53     -1967.137223   -9.564303    0.004676  0.001112
  54     -1967.137799   -9.925919    0.004390  0.001024
  55     -1967.138332   -10.259902    0.004096  0.000946
  56     -1967.138819   -10.565546    0.003785  0.000899
  57     -1967.139249   -10.835330    0.003514  0.000948
  58     -1967.139400   -10.929956    0.003402  0.000992
  59     -1967.139472   -10.975463    0.003359  0.000805
  60     -1967.139573   -11.038703    0.003294  0.000752
  61     -1967.139676   -11.103301    0.003226  0.000737
  62     -1967.139777   -11.166565    0.003160  0.000725
  63     -1967.139875   -11.228295    0.003094  0.000709
  64     -1967.139972   -11.288928    0.003030  0.000696
  65     -1967.140066   -11.348413    0.002966  0.000683
  66     -1967.140159   -11.406639    0.002904  0.000668
  67     -1967.140250   -11.463913    0.002843  0.000659
  68     -1967.140339   -11.519754    0.002784  0.000642
  69     -1967.140427   -11.574934    0.002725  0.000632
  70     -1967.140513   -11.628772    0.002668  0.000617
  71     -1967.140598   -11.681774    0.002611  0.000610
  72     -1967.140680   -11.733339    0.002555  0.000593
  73     -1967.140761   -11.784354    0.002500  0.000584
  74     -1967.140840   -11.834091    0.002445  0.000571
  75     -1967.140918   -11.883058    0.002391  0.000562
  76     -1967.140994   -11.930757    0.002338  0.000548
  77     -1967.141069   -11.977763    0.002283  0.000540
  78     -1967.141142   -12.023625    0.002231  0.000526
  79     -1967.141214   -12.068727    0.002177  0.000517
  80     -1967.141284   -12.112766    0.002126  0.000505
  81     -1967.141353   -12.155984    0.002072  0.000495
  82     -1967.141421   -12.198270    0.002021  0.000484
  83     -1967.141487   -12.239663    0.001968  0.000474
```

### Check 3 (Optional): Make sure that the energies of each geometric optimisation step is less than the transition step using the ``viewORCA irc`` program

We can also repeat **Check 2** by looking at the energy profile from the [``orca_IRC_Full_trj.xyz`` file](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4_Validate_TS/Step4A_IRC/orca_IRC_Full_trj.xyz) so that we can see how the IRC ran visually. This is a good idea as an extra check. 

To do this, we want to use the ``viewORCA irc`` program by performing the following steps:

1. Open a terminal.
2. ``cd`` into the folder with the ``orca_IRC_Full_trj.xyz`` file.
3. Run the ``viewORCA irc`` program in the terminal.

For example:

```bash
# cd into the folder with the ``orca_IRC_Full_trj.xyz`` file
cd Examples/Step4_Validate_TS/Step4A_IRC

# Run the ``viewORCA irc`` program in the terminal
viewORCA irc
```

!!! note

    ``viewORCA irc`` will also create a xyz file called ``IRC_images.xyz`` that you can copy to your computer if you are using a high-capacity computer (HPC) system and view on your own computer. 

    * If you just want to create the ``IRC_images.xyz`` file, type into the terminal ``viewORCA irc --view False`` (which will create the ``IRC_images.xyz`` file without creating a ``ase gui`` window). 

You will get a GUI that shows you the following IRC pathway:

<figure markdown="span">
    <img src="../Figures/4A_IRC/IRC_example.gif?raw=true" alt="IRC Images" width="600"/>
    <figcaption>GIF of the IRC calculation</figcaption>
</figure>

The energy profile for this example is given below:

<figure markdown="span">
    <img src="../Figures/4A_IRC/IRC_energy.png?raw=true" alt="IRC Energy Profile" width="600"/>
    <figcaption>Energy Profile of the IRC calculation</figcaption>
</figure>

If you put the cursor over the energy profile, you will see in this example that the maximum peak occurs at ``x=36``. Because ASE starts at ``0`` rather than ``1``, ``x=36`` here means ``step 37``, so we are happy. 

## Other Information about performing the IRC method with ORCA

The following links have good information for performing NEBs in ORCA:

* This link helped me set up the IRC scripts for ORCA: https://www.molphys.org/orca_tutorial_2020/en/irc_path.html

## Troubleshooting Intrinsic Reaction Coordinate (``IRC``) calculations

Here are some troubleshooting tips for performing IRC calculations

No troubleshooting issues have been found yet. 

!!! info

    If you have any issues about this step, [raise a ``New issue`` at the Issues section by clicking here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/issues).




