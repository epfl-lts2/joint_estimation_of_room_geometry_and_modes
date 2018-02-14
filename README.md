# JOINT ESTIMATION OF ROOM GEOMETRY AND MODES

Here you can find framework for retrieving room shape and modes from microphone measurements.
We use a combination of the following techniques:
1. curve fitting based on rational fraction polynomial method
2. sampling on the sphere close to oniform
3. matching pursuit
4. group sparsity
5. compressed sensing

The solution is limited to rectangular room that is lightly damped.

<br />
The measurements and the room details are available here: https://zenodo.org/record/1169161#.WoFicOjwY-W
 <br />
 
 We have used the **Rational Fraction Polynomial Method** by Cristian Gutierrez Acuna https://ch.mathworks.com/matlabcentral/fileexchange/3805-rational-fraction-polynomial-method?focused=5049537&tab=function for curve fitting of our room transfer functions:
 ![RoomTransferFunctions](https://github.com/epfl-lts2/joint_estimation_of_room_geometry_and_modes/blob/master/readme_images/room_transfer_function.png)
 <br />
 and **Suite of functions to perform uniform sampling of a sphere** by Anton Semechko https://ch.mathworks.com/matlabcentral/fileexchange/37004-suite-of-functions-to-perform-uniform-sampling-of-a-sphere?s_tid=prof_contriblnk
 in oder to discover the type of the room modes that corresponds to our resonant frequencies:
 ![SphereSampling](https://github.com/epfl-lts2/joint_estimation_of_room_geometry_and_modes/blob/master/readme_images/mode_types.PNG)
 <br />
 
 Here we provide the matlab version of the code and python version is available upon request: helena.peictukuljac@epfl.ch.
