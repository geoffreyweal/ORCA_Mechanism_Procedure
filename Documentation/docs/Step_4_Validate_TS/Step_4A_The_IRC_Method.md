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
    TolMAXG 2.e-3  # Max gradient (a.u.). Currently set to values equivalent to LooseOpt.
    TolRMSG 5.e-4  # RMS gradient (a.u.). Currently set to values equivalent to LooseOpt.
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

Look at the end of the [``output.out`` file](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4_Validate_TS/Step4A_IRC/output.out#L2342) and makes sure there is some sort of message that says that ORCA finished successfully, like that below:

```title="Successful ORCA calculation message expected at the end of the ORCA output file"
****ORCA TERMINATED NORMALLY****
```

Also, make sure you see the following ``HURRAY`` messages for the [forward](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4_Validate_TS/Step4A_IRC/output.out#L2014) and [reverse](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4_Validate_TS/Step4A_IRC/output.out#L2099) components of the calculation

```title="Example of HURRAY message indicating the IRC calculation completed successfully"
***********************HURRAY********************
***            THE IRC HAS CONVERGED          ***
*************************************************
```

See an [example of this below](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4_Validate_TS/Step4A_IRC/output.out#L1958):

```title="Example of IRC optimisation calculation text from the ORCA output file"
         *************************************************************
         *                          FORWARD IRC                      *
         *************************************************************

Iteration    E(Eh)      dE(kcal/mol)  max(|G|)   RMS(G) 
Convergence thresholds                0.002000  0.000500            
    0     -1967.123694   -0.987880    0.009347  0.001949
    1     -1967.125262   -1.971692    0.010633  0.002266
    2     -1967.125852   -2.342362    0.009561  0.002027
    3     -1967.126824   -2.951750    0.009004  0.001925
    4     -1967.127879   -3.613810    0.009124  0.001951
    5     -1967.128956   -4.289687    0.009018  0.001951
    6     -1967.130017   -4.955706    0.008720  0.001916
    7     -1967.131043   -5.599642    0.008250  0.001895
    8     -1967.132027   -6.216796    0.007772  0.001775
    9     -1967.132967   -6.806843    0.007140  0.001741
   10     -1967.133844   -7.356805    0.006597  0.001594
   11     -1967.134673   -7.877617    0.005964  0.001505
   12     -1967.135396   -8.330929    0.005465  0.001403
   13     -1967.136183   -8.824805    0.005304  0.001313
   14     -1967.136867   -9.254130    0.005093  0.001211
   15     -1967.137494   -9.647347    0.004860  0.001251
   16     -1967.138020   -9.977561    0.004589  0.001172
   17     -1967.138244   -10.118093    0.004476  0.001128
   18     -1967.138493   -10.274561    0.004343  0.000969
   19     -1967.138760   -10.441927    0.004194  0.000937
   20     -1967.138998   -10.591222    0.004041  0.000929
   21     -1967.139225   -10.734009    0.003895  0.000876
   22     -1967.139452   -10.875971    0.003749  0.000835
   23     -1967.139718   -11.043042    0.003608  0.000801
   24     -1967.139845   -11.122736    0.003467  0.000761
   25     -1967.140080   -11.270521    0.003330  0.000731
   26     -1967.140277   -11.393680    0.003197  0.000702
   27     -1967.140464   -11.511368    0.003070  0.000674
   28     -1967.140637   -11.619494    0.002943  0.000741
   29     -1967.140715   -11.668661    0.002891  0.000664
   30     -1967.140798   -11.720524    0.002835  0.000631
   31     -1967.140860   -11.759730    0.002776  0.000609
   32     -1967.140961   -11.823302    0.002717  0.000597
   33     -1967.141042   -11.873813    0.002660  0.000598
   34     -1967.141120   -11.922679    0.002603  0.000572
   35     -1967.141197   -11.971354    0.002547  0.000604
   36     -1967.141268   -12.015933    0.002493  0.000551
   37     -1967.141345   -12.064045    0.002437  0.000559
   38     -1967.141415   -12.107775    0.002382  0.000528
   39     -1967.141487   -12.152988    0.002325  0.000535
   40     -1967.141553   -12.194724    0.002273  0.000507
   41     -1967.141623   -12.238554    0.002219  0.000504
   42     -1967.141688   -12.279047    0.002162  0.000485
   43     -1967.141757   -12.322336    0.002107  0.000474
   44     -1967.141804   -12.352192    0.002052  0.000620
   45     -1967.141837   -12.372873    0.002037  0.000479
   46     -1967.141883   -12.401622    0.002011  0.000491
   47     -1967.141897   -12.410438    0.001987  0.000502
   48     -1967.141921   -12.425304    0.001963  0.000447

                      ***********************HURRAY********************
                      ***            THE IRC HAS CONVERGED          ***
                      *************************************************


         *************************************************************
         *                          BACKWARD IRC                     *
         *************************************************************

Iteration    E(Eh)      dE(kcal/mol)  max(|G|)   RMS(G) 
Convergence thresholds                0.002000  0.000500            
    0     -1967.124432   -1.450797    0.013548  0.003054
    1     -1967.128179   -3.802362    0.019874  0.004412
    2     -1967.133463   -7.118203    0.025990  0.005520
    3     -1967.139815   -11.103897    0.028442  0.006038
    4     -1967.146176   -15.095469    0.025081  0.005721
    5     -1967.151785   -18.615266    0.021519  0.004885
    6     -1967.156345   -21.476904    0.019615  0.004011
    7     -1967.160267   -23.937845    0.017255  0.003408
    8     -1967.163664   -26.069666    0.014997  0.002976
    9     -1967.166694   -27.970753    0.013013  0.002697
   10     -1967.169479   -29.718182    0.011530  0.002474
   11     -1967.172077   -31.348800    0.010293  0.002306
   12     -1967.174459   -32.843560    0.009384  0.002123
   13     -1967.176652   -34.219491    0.008341  0.001943
   14     -1967.178609   -35.447602    0.007524  0.001794
   15     -1967.180284   -36.498332    0.006505  0.001811
   16     -1967.180799   -36.822042    0.006206  0.001874
   17     -1967.181037   -36.970895    0.006081  0.001495
   18     -1967.181400   -37.198822    0.005876  0.001356
   19     -1967.181750   -37.418312    0.005669  0.001312
   20     -1967.182089   -37.631256    0.005467  0.001242
   21     -1967.182416   -37.836382    0.005276  0.001192
   22     -1967.182752   -38.047361    0.005091  0.001133
   23     -1967.183039   -38.227080    0.004909  0.001083
   24     -1967.183346   -38.420263    0.004729  0.001053
   25     -1967.183594   -38.575570    0.004544  0.000989
   26     -1967.183880   -38.755051    0.004352  0.000934
   27     -1967.184122   -38.907028    0.004147  0.000882
   28     -1967.184278   -39.004650    0.005538  0.001872
   29     -1967.184371   -39.063508    0.003907  0.001106
   30     -1967.184429   -39.099643    0.003868  0.001106
   31     -1967.184437   -39.104382    0.003827  0.001095
   32     -1967.184495   -39.141192    0.003788  0.000806
   33     -1967.184532   -39.164363    0.003735  0.000827
   34     -1967.184582   -39.195809    0.003710  0.000779
   35     -1967.184629   -39.225129    0.003657  0.000811
   36     -1967.184679   -39.256314    0.003605  0.000771
   37     -1967.184730   -39.288669    0.003550  0.000749
   38     -1967.184792   -39.327326    0.003497  0.000767
   39     -1967.184820   -39.344886    0.003443  0.000736
   40     -1967.184882   -39.383827    0.003390  0.000791
   41     -1967.184915   -39.404885    0.003338  0.000696
   42     -1967.184964   -39.435277    0.003282  0.000702
   43     -1967.184881   -39.383478    0.003257  0.000682
   44     -1967.185025   -39.473599    0.003205  0.000675
   45     -1967.185078   -39.507012    0.003149  0.000757
   46     -1967.185116   -39.530892    0.003102  0.000636
   47     -1967.185162   -39.559376    0.003055  0.000664
   48     -1967.185193   -39.579049    0.003004  0.000683
   49     -1967.185217   -39.594308    0.002952  0.000614
   50     -1967.185167   -39.562848    0.002896  0.000602
   51     -1967.185294   -39.642716    0.002843  0.000594
   52     -1967.185245   -39.611372    0.002787  0.000572
   53     -1967.185371   -39.690597    0.002733  0.000555
   54     -1967.185407   -39.713298    0.002680  0.000583
   55     -1967.185427   -39.725635    0.002628  0.000550
   56     -1967.185455   -39.743316    0.002605  0.000686
   57     -1967.185485   -39.762253    0.002559  0.000607
   58     -1967.185523   -39.786160    0.002515  0.000571
   59     -1967.185524   -39.786625    0.002463  0.000683
   60     -1967.185589   -39.827267    0.002427  0.000794
   61     -1967.185606   -39.838302    0.002392  0.000664
   62     -1967.185624   -39.849721    0.002353  0.000478
   63     -1967.185637   -39.857889    0.002302  0.000504
   64     -1967.185667   -39.876769    0.002253  0.000504
   65     -1967.185727   -39.914169    0.002210  0.000641
   66     -1967.185718   -39.908741    0.002189  0.000446
   67     -1967.185747   -39.926823    0.002141  0.000523
   68     -1967.185769   -39.940362    0.002100  0.000528
   69     -1967.185789   -39.952710    0.002061  0.000608
   70     -1967.185870   -40.003626    0.002035  0.000817
   71     -1967.185828   -39.977567    0.002012  0.000472
   72     -1967.185827   -39.977023    0.001971  0.000413

                      ***********************HURRAY********************
                      ***            THE IRC HAS CONVERGED          ***
                      *************************************************
```

### Check 2: Make sure that the energies of each geometric optimisation step is less than the transition step from the ``output.out`` file

We want to make sure that the energy of our transition state is in fact lower than all points along the energy profile. This is because:

* The IRC method works by initially pushing the molecule down the saddle of the potential energy surface towards the reactant and product minima, so the energy should have decreased from transition state in the forward and backwards directions. 

To do this, you want to look at the ``IRC PATH SUMMARY`` in your output file and make sure your transition state (``TS``) is the highest energy step in the IRC path. 

The transition state should be the number of the final ``Convergence Iteration`` from the backwards step, plus 2. [In this example](Step_4A_The_IRC_Method.md#check-1-make-sure-the-outputout-file-indicates-the-calculation-finished-successfully), our ``BACKWARD IRC`` process required 72 geometry optimisation steps, so we expect our transition state to be at step 74 in the ``IRC PATH SUMMARY`` table. 

Below show an [example of this from ``Examples/Step4_Validate_TS/Step4A_IRC/output.log``](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/blob/main/Examples/Step4_Validate_TS/Step4A_IRC/output.out#L2103). You can see that the transition step occurs at step 74, as expected. We also see that the energy of the transition state is the largest for all steps. 

```title="Example of IRC PATH SUMMARY text from the ORCA output file"
---------------------------------------------------------------
                       IRC PATH SUMMARY              
---------------------------------------------------------------
All gradients are in Eh/Bohr.

Step        E(Eh)      dE(kcal/mol)  max(|G|)   RMS(G) 
   1     -1967.185827   -39.977023    0.001971  0.000413
   2     -1967.185828   -39.977567    0.002012  0.000472
   3     -1967.185870   -40.003626    0.002035  0.000817
   4     -1967.185789   -39.952710    0.002061  0.000608
   5     -1967.185769   -39.940362    0.002100  0.000528
   6     -1967.185747   -39.926823    0.002141  0.000523
   7     -1967.185718   -39.908741    0.002189  0.000446
   8     -1967.185727   -39.914169    0.002210  0.000641
   9     -1967.185667   -39.876769    0.002253  0.000504
  10     -1967.185637   -39.857889    0.002302  0.000504
  11     -1967.185624   -39.849721    0.002353  0.000478
  12     -1967.185606   -39.838302    0.002392  0.000664
  13     -1967.185589   -39.827267    0.002427  0.000794
  14     -1967.185524   -39.786625    0.002463  0.000683
  15     -1967.185523   -39.786160    0.002515  0.000571
  16     -1967.185485   -39.762253    0.002559  0.000607
  17     -1967.185455   -39.743316    0.002605  0.000686
  18     -1967.185427   -39.725635    0.002628  0.000550
  19     -1967.185407   -39.713298    0.002680  0.000583
  20     -1967.185371   -39.690597    0.002733  0.000555
  21     -1967.185245   -39.611372    0.002787  0.000572
  22     -1967.185294   -39.642716    0.002843  0.000594
  23     -1967.185167   -39.562848    0.002896  0.000602
  24     -1967.185217   -39.594308    0.002952  0.000614
  25     -1967.185193   -39.579049    0.003004  0.000683
  26     -1967.185162   -39.559376    0.003055  0.000664
  27     -1967.185116   -39.530892    0.003102  0.000636
  28     -1967.185078   -39.507012    0.003149  0.000757
  29     -1967.185025   -39.473599    0.003205  0.000675
  30     -1967.184881   -39.383478    0.003257  0.000682
  31     -1967.184964   -39.435277    0.003282  0.000702
  32     -1967.184915   -39.404885    0.003338  0.000696
  33     -1967.184882   -39.383827    0.003390  0.000791
  34     -1967.184820   -39.344886    0.003443  0.000736
  35     -1967.184792   -39.327326    0.003497  0.000767
  36     -1967.184730   -39.288669    0.003550  0.000749
  37     -1967.184679   -39.256314    0.003605  0.000771
  38     -1967.184629   -39.225129    0.003657  0.000811
  39     -1967.184582   -39.195809    0.003710  0.000779
  40     -1967.184532   -39.164363    0.003735  0.000827
  41     -1967.184495   -39.141192    0.003788  0.000806
  42     -1967.184437   -39.104382    0.003827  0.001095
  43     -1967.184429   -39.099643    0.003868  0.001106
  44     -1967.184371   -39.063508    0.003907  0.001106
  45     -1967.184278   -39.004650    0.005538  0.001872
  46     -1967.184122   -38.907028    0.004147  0.000882
  47     -1967.183880   -38.755051    0.004352  0.000934
  48     -1967.183594   -38.575570    0.004544  0.000989
  49     -1967.183346   -38.420263    0.004729  0.001053
  50     -1967.183039   -38.227080    0.004909  0.001083
  51     -1967.182752   -38.047361    0.005091  0.001133
  52     -1967.182416   -37.836382    0.005276  0.001192
  53     -1967.182089   -37.631256    0.005467  0.001242
  54     -1967.181750   -37.418312    0.005669  0.001312
  55     -1967.181400   -37.198822    0.005876  0.001356
  56     -1967.181037   -36.970895    0.006081  0.001495
  57     -1967.180799   -36.822042    0.006206  0.001874
  58     -1967.180284   -36.498332    0.006505  0.001811
  59     -1967.178609   -35.447602    0.007524  0.001794
  60     -1967.176652   -34.219491    0.008341  0.001943
  61     -1967.174459   -32.843560    0.009384  0.002123
  62     -1967.172077   -31.348800    0.010293  0.002306
  63     -1967.169479   -29.718182    0.011530  0.002474
  64     -1967.166694   -27.970753    0.013013  0.002697
  65     -1967.163664   -26.069666    0.014997  0.002976
  66     -1967.160267   -23.937845    0.017255  0.003408
  67     -1967.156345   -21.476904    0.019615  0.004011
  68     -1967.151785   -18.615266    0.021519  0.004885
  69     -1967.146176   -15.095469    0.025081  0.005721
  70     -1967.139815   -11.103897    0.028442  0.006038
  71     -1967.133463   -7.118203    0.025990  0.005520
  72     -1967.128179   -3.802362    0.019874  0.004412
  73     -1967.124432   -1.450797    0.013548  0.003054
  74     -1967.122120    0.000000    0.000008  0.000004 <= TS
  75     -1967.123694   -0.987880    0.009347  0.001949
  76     -1967.125262   -1.971692    0.010633  0.002266
  77     -1967.125852   -2.342362    0.009561  0.002027
  78     -1967.126824   -2.951750    0.009004  0.001925
  79     -1967.127879   -3.613810    0.009124  0.001951
  80     -1967.128956   -4.289687    0.009018  0.001951
  81     -1967.130017   -4.955706    0.008720  0.001916
  82     -1967.131043   -5.599642    0.008250  0.001895
  83     -1967.132027   -6.216796    0.007772  0.001775
  84     -1967.132967   -6.806843    0.007140  0.001741
  85     -1967.133844   -7.356805    0.006597  0.001594
  86     -1967.134673   -7.877617    0.005964  0.001505
  87     -1967.135396   -8.330929    0.005465  0.001403
  88     -1967.136183   -8.824805    0.005304  0.001313
  89     -1967.136867   -9.254130    0.005093  0.001211
  90     -1967.137494   -9.647347    0.004860  0.001251
  91     -1967.138020   -9.977561    0.004589  0.001172
  92     -1967.138244   -10.118093    0.004476  0.001128
  93     -1967.138493   -10.274561    0.004343  0.000969
  94     -1967.138760   -10.441927    0.004194  0.000937
  95     -1967.138998   -10.591222    0.004041  0.000929
  96     -1967.139225   -10.734009    0.003895  0.000876
  97     -1967.139452   -10.875971    0.003749  0.000835
  98     -1967.139718   -11.043042    0.003608  0.000801
  99     -1967.139845   -11.122736    0.003467  0.000761
 100     -1967.140080   -11.270521    0.003330  0.000731
 101     -1967.140277   -11.393680    0.003197  0.000702
 102     -1967.140464   -11.511368    0.003070  0.000674
 103     -1967.140637   -11.619494    0.002943  0.000741
 104     -1967.140715   -11.668661    0.002891  0.000664
 105     -1967.140798   -11.720524    0.002835  0.000631
 106     -1967.140860   -11.759730    0.002776  0.000609
 107     -1967.140961   -11.823302    0.002717  0.000597
 108     -1967.141042   -11.873813    0.002660  0.000598
 109     -1967.141120   -11.922679    0.002603  0.000572
 110     -1967.141197   -11.971354    0.002547  0.000604
 111     -1967.141268   -12.015933    0.002493  0.000551
 112     -1967.141345   -12.064045    0.002437  0.000559
 113     -1967.141415   -12.107775    0.002382  0.000528
 114     -1967.141487   -12.152988    0.002325  0.000535
 115     -1967.141553   -12.194724    0.002273  0.000507
 116     -1967.141623   -12.238554    0.002219  0.000504
 117     -1967.141688   -12.279047    0.002162  0.000485
 118     -1967.141757   -12.322336    0.002107  0.000474
 119     -1967.141804   -12.352192    0.002052  0.000620
 120     -1967.141837   -12.372873    0.002037  0.000479
 121     -1967.141883   -12.401622    0.002011  0.000491
 122     -1967.141897   -12.410438    0.001987  0.000502
 123     -1967.141921   -12.425304    0.001963  0.000447
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
cd ORCA_Mechanism_Procedure/Examples/Step4_Validate_TS/Step4A_IRC

# Run the ``viewORCA irc`` program in the terminal
viewORCA irc
```

!!! note

    ``viewORCA irc`` will also create a xyz file called ``IRC_images.xyz`` that you can copy and view on your own computer. 

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

If you put the cursor over the energy profile, you will see in this example that the maximum peak occurs at ``x=36``. Because ASE starts at ``0`` rather than ``1``, ``x=73`` here means ``step 74``, so we are happy. 

## Troubleshooting Intrinsic Reaction Coordinate (``IRC``) calculations

Here are some troubleshooting tips for performing IRC calculations

No troubleshooting issues have been found yet. 

!!! info

    If you have any issues about this step, [raise a ``New issue`` at the Issues section by clicking here](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure/issues).




