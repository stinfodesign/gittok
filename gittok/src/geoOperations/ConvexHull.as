package geoOperations
{
	import dataTypes.spatialGeometry.*;
	
	import math.Angle;
	import math.Distance;
	import math.Sort;
	
	import mx.collections.ArrayList;

	public class ConvexHull
	{
		public function ConvexHull()
		{
		}
		
		/*
		get Convex hull as array of points from point set.
		*/
		public static function get(argObj:Object):SG_Surface {
			/*
			1. Check the number of points
			2. 	Get lexicographic min coordinate
			3. 	Get azimuth of each coodinate (origin is the lexicographic minimum) measured anti-clockwise 
				from south, and make record of which items are coordinate and azimuth
			4. 	Sort records by azimuth
			5. 	If more than one same azimuth appear, then only the farthest coordinate is choosed and rest are 
				removed from records
			6.	If a number of coordinates is less than two, then return null
			(Hull is already constructed but it may not be convex.)
			7.	Get bearing angle of each coordinate and if it is less than 180 degree, it is removed from records
			8. Get point array from records as the return value.
			*/
			
			var attValues:ArrayList = argObj["points"] as ArrayList;
			var m:int = attValues.length;
			var points:ArrayList = new ArrayList();
			for (var i:int = 0; i < m; i++) {
				var attValue:ArrayList = attValues.getItemAt(i) as ArrayList;
				points.addAll(attValue);
			}
			
			var crdArray:ArrayList = new ArrayList();
			m = points.length;
			var p:SG_Point;
			var origin:Coordinate2;
			var z:Coordinate2;
			var records:ArrayList = new ArrayList();
			var rec:Array;
			var azimuth:Number;
			
			// 1. Check the number of points
			if (points.length < 3) return null;
			
			
			// 2. Get lexicographic min coordinate
			for (i = 0; i < m; i++) {
				p = points.getItemAt(i) as SG_Point;
				crdArray.addItem(p.position);
			}
			
			origin = math.Sort.lexicoMin(crdArray);
			
			// 3. Get azimuth of each coodinate (origin is the lexicographic minimum) 
			//    measured anti-clockwise from south, and make record of which items 
			//	  are coordinate and azimuth
			
			for (i = 0; i < m; i++) {
				z = crdArray.getItemAt(i) as Coordinate2;
				azimuth = math.Angle.azimuth(origin, z);
				if (azimuth != Number.MIN_VALUE) {
					azimuth += Math.PI * 0.5;				// from south 
					if (azimuth > Math.PI * 2.0) azimuth -= Math.PI * 2.0;		
					rec =new Array();
					rec[0] = azimuth;
					rec[1] = z;
					records.addItem(rec);
				}
			}
			
			// 4. Sort records assending by azimuth
			records = math.Sort.sortRecords(records, 0);
			
			// 5. If more than one same azimuth appear, then only the farthest coordinate from origin 
			//	  is remained and rest are removed from records
			var rec0:Array = records.getItemAt(0) as Array;
			var azi0:Number = rec0[0] as Number;
			var d0:Number;
			var d1:Number;
			var rec1:Array;
			m = records.length;
			for (i = 1; i < m; i++) {
				rec1 = records.getItemAt(i) as Array;
				var azi1:Number = rec1[0] as Number;
				if (azi0 == azi1) {
					d0 = math.Distance.p2p(origin, rec0[1]);
					d1 = math.Distance.p2p(origin, rec1[1]);
					if (d0 < d1) { 
						records.removeItemAt(i - 1);
						rec0 = rec1;
					}
					else
						records.removeItemAt(i);
					i--;
				}
			}
			
			// 6. If a number of coordinates is less than two, then return null
			if (records.length < 2) return null;
			
			// 7. Get bearing angle of each coordinate and if it is less than 180 degree, 
			//    it will be removed from records
			
			// prepare poylgon for the work
			crdArray = new ArrayList();
			crdArray.addItem(origin);
			m = records.length;
			for (i = 0; i < m; i++) {
				rec = records.getItemAt(i) as Array;
				crdArray.addItem(rec[1]);
			}
			crdArray.addItem(origin);
			rec = records.getItemAt(0) as Array;
			crdArray.addItem(rec[1]);
			
			// run the operation
			var crd0:Coordinate2 = crdArray.getItemAt(0) as Coordinate2;
			var crd1:Coordinate2 = crdArray.getItemAt(1) as Coordinate2;
			var bearing:Number;
			for (i = 1; i <= m; i++) {
				var crd2:Coordinate2 = crdArray.getItemAt(i + 1) as Coordinate2;
				bearing = math.Angle.bearing(crd0, crd1, crd2);
				if (bearing < Math.PI) {
					crd0 = crdArray.getItemAt(i - 2) as Coordinate2;
					crd1 = crdArray.getItemAt(i - 1) as Coordinate2;
					crdArray.removeItemAt(i);
					i -= 2;	// Because of i++
					m--;
				}
				else {
					crd0 = crd1;
					crd1 = crd2;
				}
			}
			
			// 8. Get point array from records as the return value.

			var wps:ArrayList = new ArrayList();
			m = points.length;
			var n:int = crdArray.length - 1;	// The last coordinate is un-necessary, because it was added for search
			for (i = 0; i < n; i++) {
				z = crdArray.getItemAt(i) as Coordinate2;
				for (var j:int = 0; j < m; j++) {
					p = points.getItemAt(j) as SG_Point;
					if (z == p.position) {
						wps.addItem(p);
						break;
					}
				}
			}
			/*
			// create the curve array
			var wcs:ArrayList = new ArrayList();
			var p0:SG_Point = wps.getItemAt(0) as SG_Point;
			var p1:SG_Point;
			for (i = 1; i < n; i++) {
				p1 = wps.getItemAt(i) as SG_Point;	
				var cv:SG_Curve = new SG_Curve();
				cv.start = p0;
				cv.end = p1;
				p0.goOut.addItem(cv);
				p1.getIn.addItem(cv);
				wcs.addItem(cv);
				p0 = p1;
			}
			
			// create the exterior ring
			var wocs:ArrayList = new ArrayList();
			var rng:SG_Ring = new SG_Ring();
			var ocv:SG_OrientableCurve;
			for (i = 0; i < (n - 1); i++) {
				ocv = new SG_OrientableCurve();
				ocv.orientation = true;
				ocv.original = wcs.getItemAt(i) as SG_Curve;
				wocs.addItem(ocv);
				rng.element.addItem(ocv);
			}
			var wrngs:ArrayList = new ArrayList();
			wrngs.addItem(rng);
			
			// create convex hull
			var wsf:SG_Surface = new SG_Surface();
			wsf.exterior = rng;
			var wss:ArrayList = new ArrayList();
			wss.addItem(wsf);
			
			var convexHull:SG_Complex = new SG_Complex();
			convexHull.pointSet = wps;
			convexHull.curveSet = wcs;
			convexHull.surfaceSet = wss;
			
			convexHull.orientableCurveSet = wocs;
			convexHull.ringSet = wrngs;
			
			return convexHull;
			*/
			
			var coords:CoordinateArray = new CoordinateArray();
			for (i = 1; i < n - 1; i++) {
				p = wps.getItemAt(i) as SG_Point;
				var crd:Coordinate2 = new Coordinate2();
				crd.x = p.position.x;
				crd.y = p.position.y;
				coords.addItem(crd);
			}
			
			// create surface
			var crv:SG_Curve = new SG_Curve();
			p = wps.getItemAt(0) as SG_Point;
			p.goOut.addItem(crv);
			p.getIn.addItem(crv);
			
			crv.start = p;
			crv.end = p;
			crv.shape = coords;
			
			var ocrv:SG_OrientableCurve = new SG_OrientableCurve();
			ocrv.original = crv;
			ocrv.orientation = true;
			
			var rng:SG_Ring = new SG_Ring();
			rng.elements.addItem(ocrv);
			
			var srf:SG_Surface = new SG_Surface();
			srf.exterior = rng;
			
			return srf;
		}
	}
}