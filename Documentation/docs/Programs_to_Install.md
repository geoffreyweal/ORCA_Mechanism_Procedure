# Programs to Install

There are several programs that you should install on your computer for running this procedure. These are:


## Sublime or Notepad++

It is a good idea to have a notepad program for reading and editing files easily on your computer. Here are two recommendations for notepads:

* Sublime: https://www.sublimetext.com
* Notepad++: https://notepad-plus-plus.org/


## Python 3 and ``pip3``

This tutorial is designed to work with **Python 3**. To find out if you have Python 3 on your computer and what version you have, type into the terminal:

```bash
python --version
```

If you have Python 3 on your computer, you will get the version of python you have on your computer. E.g:

```bash
user@computer_name path % python --version
Python 3.11.6
```

If you have Python 3, you may have ``pip`` installed on your computer as well. ``pip`` is a python package installation tool that is recommended by Python for installing Python packages. To see if you have ``pip`` installed, type into the terminal:

```bash
pip list
```
If you get back a list of python packages install on your computer, you have ``pip`` installed. E.g.

```bash
user@computer_name Documentation % pip3 list
Package         Version
--------------- -----------
ase             3.26.0
contourpy       1.3.3
cycler          0.12.1
et_xmlfile      2.0.0
fcswrite        0.6.2
fonttools       4.60.1
kiwisolver      1.4.9
matplotlib      3.10.6
narwhals        2.7.0
numpy           2.3.3
openpyxl        3.1.5
packaging       25.0
pandas          2.3.3
patsy           1.0.1
pillow          11.3.0
pip             25.2
plotly          6.3.1
pyparsing       3.2.5
python-dateutil 2.9.0.post0
pytz            2025.2
scipy           1.16.2
setuptools      80.9.0
six             1.17.0
statsmodels     0.14.5
tqdm            4.67.1
tzdata          2025.2
viewORCA        0.2.2
xlsxwriter      3.2.9
```

If you do not see this, you probably do not have ``pip`` installed on your computer. If this is the case, check out [PIP Installation](https://pip.pypa.io/en/stable/installing). 

!!! note

    In most cases, ``pip`` and ``pip3`` are synonymous for the Python Installation Package for Python 3. **However in some cases,** ``pip`` **will be directed to the Python Installation Package for Python 2 rather than Python 3.** To check this, run in the terminal:

    ```bash
    pip --version
    ```

    If the output indicates you this Python Installation Package is for Python 2 and not Python 3, only install packages using the ``pip3`` name. 

    For the rest of this documentation, ``pip`` will be used, however if your computer's ``pip``  refers to Python 2 and not Python 3, use ``pip3``  instead of ``pip``. 


## Packaging

The ``packaging`` program is also used in this program to check the versions of ASE that you are using for compatibility issues. The easiest way to install ``packaging`` is though ``pip``. Type the following into the terminal:

```bash
pip3 install --upgrade --user packaging
```


## Numpy

The ``numpy`` program is used in this program to perform matrix calculations, as well as used by ``ase``. The easiest way to install ``numpy`` is though ``pip``. Type the following into the terminal:

```bash
pip3 install --upgrade --user numpy
```


## Scipy

The ``scipy`` program is used by the ``ase`` program. The easiest way to install ``scipy`` is though ``pip``. Type the following into the terminal:

```bash
pip3 install --upgrade --user scipy
```


## Matplotlib

The ``matplotlib`` program is used in this program to create the energy profile plots made by the ``viewORCA neb_snap`` module. The easiest way to install ``matplotlib`` is though ``pip``. Type the following into the terminal:

```bash
pip3 install --upgrade --user matplotlib
```


## Atomic Simulation Environment (ASE)

The Atomic Simulation Environment (ASE) is used to read and write molecule data, as well as to view molecules in a GUI. Read more about [ASE here](https://ase-lib.org/). 

The installation of ASE can be found on the [ASE installation page](https://ase-lib.org/install.html), however from experience if you are using ASE for the first time, it is best to install ASE using ``pip``, the package manager that is an extension of python to keep all your program easily managed and easy to import into your python. 

To install ASE using ``pip``, perform the following in your terminal.

```bash
pip3 install --user --upgrade numpy scipy matplotlib
pip3 install --user --upgrade ase
```

Installing using ``pip`` ensures that ASE is being installed to be used by Python 3, and not Python 2. Installing ASE like this will also install all the requisite program needed for ASE. This installation includes the use of features such as viewing the xyz files of structure and looking at ase databases through a website. These should be already assessible, which you can test by entering into the terminal:

```bash
ase gui
```

This should show a GUI with nothing in it, as shown below:

<figure markdown="span">
    <img alt="ase_gui_blank.png" src="Shared_Images/ase_gui_blank.png?raw=true" width="500" />
  <!-- ![ase_gui_blank.png](Images/ase_gui_blank.png){ width="500" } -->
  <figcaption>This is a blank ase gui screen that you would see if enter ase gui into the terminal.</figcaption>
</figure>

However, **in the case that this does not work**, we need to manually add a path to your ``~/.bashrc`` so you can use the ASE features externally outside python. Do the following; first enter the following into the terminal:

```bash
pip show ase
```

This will give a bunch of information, including the location of ase on your computer. For example, when I do this I get:

```bash
user@computer_name docs % pip show ase
Name: ase
Version: 3.26.0
Summary: Atomic Simulation Environment
Home-page: https://ase-lib.org/
Author: 
Author-email: 
License-Expression: LGPL-2.1-or-later
Location: /Users/geoffreyweal/Library/Python/3.11/lib/python/site-packages
Requires: matplotlib, scipy, numpy
Required-by: 
```

Copy the ``Location`` line. If we remove the ``lib/python/site-packages`` bit and replace it with ``bin``, this gives us the location of useful ASE programs. The example below is for Python 3.11. 

```bash
/Users/geoffreyweal/Library/Python/3.11/bin
```

Next, add this to your ``~/.bashrc`` file as below:

```bash
############################################################
# For ASE
export PATH=/Users/geoffreyweal/Library/Python/3.11/bin:$PATH
############################################################
```

Write ``source ~/.bashrc`` in the terminal and press enter. Once you have done this, try to run ``ase gui`` in the terminal. This will hopefully show the ase gui and allow you to access the useful ASE programs through the terminal. 


## viewORCA

The [``viewORCA`` program](https://geoffreyweal.github.io/viewORCA) is used throughout this procedure to allow the user to view various ORCA calculations. The easiest way to install ``viewORCA`` is though ``pip``. Type the following into the terminal:

```bash
pip3 install --upgrade --user viewORCA
```

???+ note

    If you want to install ``viewORCA`` *via* an alternative method, see the [``viewORCA`` Installation Instructions](https://geoffreyweal.github.io/viewORCA/Installation.html). 

