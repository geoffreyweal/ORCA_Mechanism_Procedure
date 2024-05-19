# Programs to Install

There are several programs that you should install on your computer for running this procedure. These are:


## Sublime or Notepad++

It is a good idea to have a notepad program for reading and editing files easily on your computer. Here are two recommendations for notepads:

* Sublime: https://www.sublimetext.com
* Notepad++: https://notepad.plus


## Python 3 and ``pip3``

This program is designed to work with **Python 3**. This program can only be used with Python 3.7. This is because the CSD Python API can only run using Python 3.7. 

To find out if you have Python 3 on your computer and what version you have, type into the terminal

```bash
python --version
```

If you have Python 3 on your computer, you will get the version of python you have on your computer. E.g.

```bash
user@computer_name path % python --version
Python 3.7.9
```

If you have Python 3, you may have ``pip`` installed on your computer as well. ``pip`` is a python package installation tool that is recommended by Python for installing Python packages. To see if you have ``pip`` installed, type into the terminal

```bash
pip list
```
If you get back a list of python packages install on your computer, you have ``pip`` installed. E.g.

```bash
user@computer_name Documentation % pip3 list
Package                       Version
----------------------------- ---------
alabaster                     0.7.12
asap3                         3.11.10
ase                           3.20.1
Babel                         2.8.0
certifi                       2020.6.20
chardet                       3.0.4
click                         7.1.2
cycler                        0.10.0
docutils                      0.16
Flask                         1.1.2
idna                          2.10
imagesize                     1.2.0
itsdangerous                  1.1.0
Jinja2                        2.11.2
kiwisolver                    1.2.0
MarkupSafe                    1.1.1
matplotlib                    3.3.1
numpy                         1.19.1
packaging                     20.4
Pillow                        7.2.0
pip                           20.2.4
Pygments                      2.7.1
pyparsing                     2.4.7
python-dateutil               2.8.1
pytz                          2020.1
requests                      2.24.0
scipy                         1.5.2
setuptools                    41.2.0
six                           1.15.0
snowballstemmer               2.0.0
Sphinx                        3.2.1
sphinx-pyreverse              0.0.13
sphinx-rtd-theme              0.5.0
sphinx-tabs                   1.3.0
sphinxcontrib-applehelp       1.0.2
sphinxcontrib-devhelp         1.0.2
sphinxcontrib-htmlhelp        1.0.3
sphinxcontrib-jsmath          1.0.1
sphinxcontrib-plantuml        0.18.1
sphinxcontrib-qthelp          1.0.3
sphinxcontrib-serializinghtml 1.1.4
sphinxcontrib-websupport      1.2.4
urllib3                       1.25.10
Werkzeug                      1.0.1
wheel                         0.33.1
xlrd                          1.2.0
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

The ACSD program uses the Atomic Simulation Environment (ASE) to read in the crystal data from various file format, to process the crystals, and to save the the crystals to disk. Read more about [ASE here](https://wiki.fysik.dtu.dk/ase). 

The installation of ASE can be found on the [ASE installation page](https://wiki.fysik.dtu.dk/ase/install.html), however from experience if you are using ASE for the first time, it is best to install ASE using ``pip``, the package manager that is an extension of python to keep all your program easily managed and easy to import into your python. 

To install ASE using ``pip``, perform the following in your terminal.

```bash
pip3 install --user -upgrade numpy scipy matplotlib
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
Version: 3.20.1
Summary: Atomic Simulation Environment
Home-page: https://wiki.fysik.dtu.dk/ase
Author: None
Author-email: None
License: LGPLv2.1+
Location: /Users/geoffreyweal/Library/Python/3.7/lib/python/site-packages
Requires: matplotlib, scipy, numpy
Required-by: 
```

Copy the ``Location`` line. If we remove the ``lib/python/site-packages`` bit and replace it with ``bin``, this gives us the location of useful ASE programs. The example below is for Python 3.7. 

```bash
/Users/geoffreyweal/Library/Python/3.7/bin
```

Next, add this to your ``~/.bashrc`` file as below:

```bash
############################################################
# For ASE
export PATH=/Users/geoffreyweal/Library/Python/3.7/bin:$PATH
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

