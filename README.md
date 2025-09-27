# Simulation Management Scripts

These are 5 scripts I use to manage my simulations over time.

## tar_outputs.sh
Will tar output folders of a specified simulation for specified (sequential) outputs. 
e.g. ```./tar_outputs.sh -d SIMULATION_NAME -s 0 -e 10```
Will tar the outputs of SIMULATION_NAME from output-0000 to output-0010 into files output-0000.tar.gz in the simulation directory.

## untar_outputs.sh
The opposite of the above. In the case where you need to get data that has been archived in, e.g., Ranch.

## tar_analysis.sh
This tars a selection of files intended for analysis on local machines. Typically a good idea to keep these files small.
*TODO*: make the files wanted a variable selection, right now they are hard coded.

## tar_longterm.sh
When a simulation is finished and analysis is done, you want to keep a minimum viable product (MVP) for re-analysis later on, and possibly, restarting the simulation. This tar intends to keep the 2D files of a simulation for long term storage.

## tar_3d_longterm.sh
Same as above, but for 3D files. Keeps 3D outputs in every 10th output.

## TODO: tar_checkpoints.sh
Automatically tar a checkpoint if one hasn't been tarred in >10 outputs. Needs to be done!

## scan_arrangements.sh
In order to determine exactly which versions of which thorns are being used in a given Cactus configuration, this script can be placed into the 'arrangements' folder and run. It will recursively search for repositories in the arrangements folder (following symbolic links of course), and when found print the path to the thorn and the branch of the repository it is using.
(The script has a hard-coded depth limit of 4: GetComponents never places the repository links more than one level down, so if 4 levels is not enough it is likely you are not setting up you Cactus conifiguration in a protable way, and you should consider the advice in the next section.)

# Managing Cactus Configurations with GetComponents & Thornlists

The high degree of modularity of Cactus codes, along with the necessary hetrogeny inherent to high-performance computing environments, makes setting up working configurations of Cactus a major technical time sink for our work.
It is therefore vital to make such configurations as sharable and reproducable as possible.

Part of this is achieved by SimFactory. It provides an elaborate mechanism wrapping the Cactus build system to enable compiler settings, environment setup, and simulation setup, queue submission, and run scripts, to be easily shared via .ini, .cfg, .sub, and .run files that entirely capture the setup for Cactus on a given HPC machine, and are easy to share.

However there is still a major missing element: these SimFactory files standardize how Cactus simulations are compiled, set up, and run, but they do not specify *what* is being compiled, set up, and run. Indeed, depending on the languages and libraries needed, a given .ini or .cfg on some machine may not even work with every set of Cactus thorns that could be compiled. Quite simply, there is no singular Cactus code, there are endless combinations of thorns, and it is vital to have a succinct, portable method to specify exactly which of the miriad combinations is being used.

The solution to this issue pre-dates SimFactory, and takes the form of Thornlist files, along with the GetComponents script.
GetComponents is familiar to any Cactus user as the installation script, but it is much more--it is esentially a parser for the "Component Retrieval Language" (CRL) of the thornlist files. This enables a powerful system for setting up Cactus configurations with thorns from around the internet.

Thornlists specify both the repositories where code can be found, and the structure of Cactus's arrangements folder, where the thorns Cactus will use are collected. Using GetComponents, the checking out of code from repositories as well as the setup of the arrangements folder can be automated. If changes are made to the thornlist, one can simply run GetComponents from one level above the Cactus folder with the modified thornlist as its only argument, and GetComponents will make the necessary updates.

In this way, the thornlists act a simple database (much like the .ini, .cfg, .sub, and .run files), which uniquely determine the set of code repositories that are checked out, down to the branch version, and the arrangments structure. As a bonus, thornlists are also used by the build system to specify which thorns are to be built into a given Cactus configuration.

In ```example_azrelativity_thornlist.th``` I show what to _append_ to a standard Einstein Toolkit thornlist in order to check out and install the thorns in our GitHub organization. If appending ```example_azrelativity_thornlist.th``` to ```einsteintoolkit.th``` (for example) and removing andy redundant thonrs, results in ```updated_thornlist.th```, then the associated configuration would either be installed fresh or updated by going to the directory above Cactus and running:
```
$ ./GetComponents updated_thornlist.th
```
And following the prompts.

For more about the CRL language of thornlists that is parsed by GetComponents, see:
https://github.com/gridaphobe/CRL/wiki/Component-Retrieval-Language
