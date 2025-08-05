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
