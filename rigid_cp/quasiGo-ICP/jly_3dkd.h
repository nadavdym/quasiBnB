/****************************************************************
3D Euclidean Distance Transform Class
Last modified: May 1, 2014 

Functions computing DT are derived from "dt.c" written by 
Alexander Vasilevskiy.

Jiaolong Yang <yangjiaolong@gmail.com>
****************************************************************/

#ifndef JLY_3DKD_H
#define JLY_3DKD_H

#include "matrix.h"
#include "nanoflann.hpp"
using namespace nanoflann;

// A custom data set class to use nanoflann
template <typename T>
struct PointCloudKD
{
	struct Point
	{
		T  x,y,z;
	};

	std::vector<Point>  pts;

	// Must return the number of data points
	inline size_t kdtree_get_point_count() const { return pts.size(); }

	// Returns the distance between the vector "p1[0:size-1]" and the data point with index "idx_p2" stored in the class:
	inline T kdtree_distance(const T *p1, const size_t idx_p2,size_t size) const
	{
		const T d0=p1[0]-pts[idx_p2].x;
		const T d1=p1[1]-pts[idx_p2].y;
		const T d2=p1[2]-pts[idx_p2].z;
		return d0*d0+d1*d1+d2*d2;
	}

	// Returns the dim'th component of the idx'th point in the class:
	// Since this is inlined and the "dim" argument is typically an immediate value, the
	//  "if/else's" are actually solved at compile time.
	inline T kdtree_get_pt(const size_t idx, int dim) const
	{
		if (dim==0) return pts[idx].x;
		else if (dim==1) return pts[idx].y;
		else return pts[idx].z;
	}

	// Optional bounding-box computation: return false to default to a standard bbox computation loop.
	//   Return true if the BBOX was already computed by the class and returned in "bb" so it can be avoided to redo it again.
	//   Look at bb.size() to find out the expected dimensionality (e.g. 2 or 3 for point clouds)
	template <class BBOX>
	bool kdtree_get_bbox(BBOX &bb) const { return false; }

};


class KD3D{
public:
	KD3D();
	void Build(double* x, double* y, double* z, int num);
	float Distance(double x, double y, double z);
    
   	PointCloudKD<float> model_;

    KDTreeSingleIndexAdaptor<
		L2_Simple_Adaptor<float, PointCloudKD<float> > ,
		PointCloudKD<float>,
		3 /* dim */
	> * kdtree;
    
    // for compatibility with DT3D
    int SIZE;
	double scale;
	double expandFactor;
	double xMin, xMax, yMin, yMax, zMin, zMax;
    
};

#endif
