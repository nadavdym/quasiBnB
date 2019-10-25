/****************************************************************
3D Euclidean Distance Transform Class
Last modified: Feb 13, 2013

Functions computing DT are derived from "dt.c" written by 
Alexander Vasilevskiy.

Jiaolong Yang <yangjiaolong@gmail.com>
****************************************************************/

#include <math.h>
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
#include <memory.h>

#include <iostream>
#include <fstream>
using namespace std;

#include "jly_3dkd.h"

#define FALSE 0
#define TRUE 1

KD3D::KD3D()
{
    kdtree = NULL;
}

void KD3D::Build(double* _x, double* _y, double* _z, int num)
{
    if(kdtree != NULL)
		delete(kdtree);

    model_.pts.resize(num);

    size_t i, idx;
	for(i = 0; i < num; i++)
	{
		model_.pts[i].x = _x[i];
		model_.pts[i].y = _y[i];
		model_.pts[i].z = _z[i];
	}

    kdtree = new KDTreeSingleIndexAdaptor<
		L2_Simple_Adaptor<float, PointCloudKD<float> > ,
		PointCloudKD<float>,
		3 /* dim */
	>(3 /*dim*/, model_, KDTreeSingleIndexAdaptorParams(10 /* max leaf */) );

    kdtree->buildIndex();	
}

float KD3D::Distance(double _x, double _y, double _z)
{
    float query[3];
    std::vector<size_t> ret_index(1);
	std::vector<float> out_dist_sqr(1);
    
    //transform point according to R and T
    query[0] = _x;
    query[1] = _y;
    query[2] = _z;
       
    //search nearest neighbor
    kdtree->knnSearch(&query[0], 1, &ret_index[0], &out_dist_sqr[0]);
    
    // return distance
	return sqrt(out_dist_sqr[0]);
}
