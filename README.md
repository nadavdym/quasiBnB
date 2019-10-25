# quasiBnB
 This repository contains code for globally solving the rigid alignment problems 
as described in the paper "Linearly Converging Quasi Branch and Bound Algorithms for Global Rigid Registration" by Nadav Dym and Shahar Kovalsky.
Please cite this paper if you use the code.

The code is divided into two folders containing code for the two applications discussed in the paper
(1) rigid closest point  (2) rigid bijective
each folder contains a demo file you can run to see the algorithm in action. For any questions, reporting bugs etc. please send an email to nadavdym@gmail.com

The code for (1) rigid closest point is based on the c++ implementation
from "Go-ICP: A Globally Optimal Solution to 3D ICP Point-Set Registration" by Yang et al. 
and their original code (with minor changes, essentially printing more data on the results of the algorithm) is provided as well
we use matlab for a demo, preprocessing data and displaying results

The code for (2) uses the auction algorithm based linear assignment solver from "Fast
correspondences for statistical shape models of
brain structures" by Bernard et al. If you use this solver please consider citing this paper as well.

