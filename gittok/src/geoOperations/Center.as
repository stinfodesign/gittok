package geoOperations
{
	import dataTypes.spatialGeometry.*;
	import dataTypes.theme.*;
	
	import math.*;
	
	import mx.collections.ArrayList;
	
	public class Center
	{
		
		public function Center()
		{
		}
		
		// center of gravity (centroid)
		
		public static function centerOfPoints(argObj:Object):SG_Point {
			var points:ArrayList = new ArrayList();
			
			var pointValues:ArrayList = argObj["points"] as ArrayList;
			for (var i:int = 0; i < pointValues.length; i++) {
				var elementValues:ArrayList = pointValues.getItemAt(i) as ArrayList;
				points.addAll(elementValues);	
			}
			
			var wp:SG_Point = points.getItemAt(0) as SG_Point;
			
			var m:int = points.length;
			if (m == 0) return null;
			
			var x:Number = 0;
			var y:Number = 0;
			var coord:Coordinate2;
			for (i = 0; i < m; i++) {
				wp = points.getItemAt(i) as SG_Point;
				coord = wp.position;
				x += coord.x;
				y += coord.y;
			}
			
			var p:SG_Point = new SG_Point;
			p.featureID = wp.featureID;
			p.attributeName = wp.attributeName;
			
			p.position.x = x/m;
			p.position.y = y/m;
			
			return p;
		}
		
		public static function centerOfCurve(argObj:Object):SG_Point {
			var attValues:ArrayList = argObj["curve"] as ArrayList;
			var attList:ArrayList = attValues.getItemAt(0) as ArrayList;
			var curve:SG_Curve = attList.getItemAt(0) as SG_Curve;
			
			var coords:CoordinateArray = curve.coordinateSeqence();
			var n:int = coords.length;
			if (n == 0) return null;
			
			// L is a curve length
			var L:Number = math.LengthLS.lengthLS(coords);
			var center:Coordinate2 = new Coordinate2();
			
			var p0:Coordinate2 = coords.getItemAt(0) as Coordinate2;
			var p1:Coordinate2;
			var avx:Number;
			var avy:Number;
			var dx:Number;
			var dy:Number;
			var len:Number;
			for (var i:int = 1; i < n; i++) {
				p1  = coords.getItemAt(i) as Coordinate2;
				avx = (p0.x + p1.x) * 0.5;
				avy = (p0.y + p1.y) * 0.5;
				dx  = p1.x - p0.x;
				dy  = p1.y - p0.y;
				len = Math.sqrt(dx * dx + dy * dy);
				center.x += len * avx;
				center.y += len * avy;
				p0 = p1;
			}
			center.x = center.x / L;
			center.y = center.y / L;
			
			var p:SG_Point = new SG_Point();
			p.featureID = curve.featureID;
			p.attributeName = curve.attributeName;			
			
			p.position = center;
			return p;
		}
		
		public static function centerOfSurface(argObj:Object):SG_Point {
			var attValues:ArrayList = argObj["surface"] as ArrayList;
			var attList:ArrayList = attValues.getItemAt(0) as ArrayList;
			var surface:SG_Surface = attList.getItemAt(0) as SG_Surface;
			
			var coords:CoordinateArray = surface.exterior.coordinateSequence();
			var n:int = coords.length - 1; // meaning of - 1 is that the last point is same as the first point.
			var x:Number = 0;
			var y:Number = 0;
			var coord:Coordinate2;
			for (var i:int = 0; i < n; i++) {		
				coord = coords.getItemAt(i) as Coordinate2;
				x += coord.x;
				y += coord.y;
			}
			
			var p:SG_Point = new SG_Point();
			p.featureID = surface.featureID;
			p.attributeName = surface.attributeName;			

			p.position.x = x / n;
			p.position.y = y / n;
			
			return p;
		}
		
		public static function centerOfComplex(argObj:Object):SG_Point {
			// It is represented by the center of points in the complex.
			var attValues:ArrayList = argObj["complex"] as ArrayList;
			var attList:ArrayList = attValues.getItemAt(0) as ArrayList;
			var complex:SG_Complex = attList.getItemAt(0) as SG_Complex;
			
			var aob:Object = new Object;
			var argArray:ArrayList = new ArrayList;
			argArray.addItem(complex.pointSet);
			aob["points"] = argArray;
			
			return Center.centerOfPoints(aob);
			
		}
		
		// center laying on the curve
		public static function centerLayingOnCurve(argObj:Object):SG_Point {
			var attValues:ArrayList = argObj["curve"] as ArrayList;
			var attList:ArrayList = attValues.getItemAt(0) as ArrayList;
			var curve:SG_Curve = attList.getItemAt(0) as SG_Curve;
			
			var coors:CoordinateArray = curve.coordinateSeqence();

			var length:Number = 0;
			var n:int = coors.length;
			var c0:Coordinate2 = coors.getItemAt(0) as Coordinate2;
			for (var i:int = 1;i < n; i++) {
				var c1:Coordinate2 = coors.getItemAt(i) as Coordinate2;
				length += math.Distance.p2p(c0, c1);
				c0 = c1;
			}
			
			// get the center position
			var lengthToCenter:Number = length * 0.5;
			var d:Number;
			c0 = coors.getItemAt(0) as Coordinate2;
			length = 0;
			i = 0;
			do {
				i++;				
				c1 = coors.getItemAt(i) as Coordinate2;
				d = math.Distance.p2p(c0, c1);
				length += d;
				c0 = c1;
			} while (length < lengthToCenter); 
			
			length = lengthToCenter - (length - d);
			
			c0 = coors.getItemAt(i - 1) as Coordinate2;
			c1 = coors.getItemAt(i) as Coordinate2;
			var dist:Number = math.Distance.p2p(c0, c1);
			var coor:Coordinate2 = new Coordinate2();
			coor.x = length * (c1.x - c0.x) / dist + c0.x;
			coor.y = length * (c1.y - c0.y) / dist + c0.y;
			
			var p:SG_Point = new SG_Point();
			p.featureID = curve.featureID;
			p.attributeName = curve.attributeName;			

			p.position = coor;
			
			return p;			
		}
		
		// center of Maximal Inscribed Circle in any polygon
		public static function centerOfMIC(argObj:Object, gridSize:int = 10):SG_Point {
			/*
			This algorithm can be used for the surface without interior boundaries
			*/
			var attValues:ArrayList = argObj["surface"] as ArrayList;
			var attList:ArrayList = attValues.getItemAt(0) as ArrayList;
			var surface:SG_Surface = attList.getItemAt(0) as SG_Surface;
						
			var coors:CoordinateArray = surface.exterior.coordinateSequence();

			// define grid
			var m:int = gridSize;
			
			var minx:Number = Number.MAX_VALUE;
			var miny:Number = Number.MAX_VALUE;
			var maxx:Number = Number.MIN_VALUE;
			var maxy:Number = Number.MIN_VALUE;
			
			var pn:int = coors.length;
			
			for (var i:int = 0; i < pn; i++) {
				var c:Coordinate2 = coors.getItemAt(i) as Coordinate2;
				if (c.x != Number.MAX_VALUE) {
					if (minx > c.x) minx = c.x;
					if (miny > c.y) miny = c.y;
					if (maxx < c.x) maxx = c.x;
					if (maxy < c.y) maxy = c.y;
				}
			}
			
			var dx:Number = (maxx - minx) / m;
			var dy:Number = (maxy - miny) / m;
			var minDist:Number;
			var maxDist:Number = Number.MIN_VALUE;
			var bc:Coordinate2;
			var ec:Coordinate2;
			var dist:Number;
			var target:Coordinate2;
			var cc:Coordinate2 = new Coordinate2();
			var interval:Number;
			var dt:Number;
			var t:Number;
			
			for (var x:Number = minx; x <= maxx; x += dx) {
				for (var y:Number = miny; y <= maxy; y += dy) {
					var wc:Coordinate2 = new Coordinate2();
					wc.x = x;
					wc.y = y;
					
					var r:SG_Ring;
					var ioe:Boolean = math.Relation.pointInRing(wc, surface.exterior);
					if (ioe) {
						minDist = getMinDist(wc, surface.exterior);
						
						var ioi:Boolean = false;
						for (i = 0; i < surface.interior.length; i++) {
							r   = surface.interior.getItemAt(i) as SG_Ring;
							ioi = math.Relation.pointInRing(wc, r);
							if (ioi) break;
						}
						
						if (!ioi) {
							for (i = 0; i < surface.interior.length; i++) {
								r   = surface.interior.getItemAt(i) as SG_Ring;

								dist = getMinDist(wc, r);
								if (minDist > dist) {
									minDist = dist;
								}		
							}
						
							if (minDist > maxDist) {
								maxDist = minDist;
								target = wc;
							}
						}
					}
				}
			}
			
			/*
			Retry centering if target position was null.
			*/
			if (target == null) centerOfMIC(argObj, gridSize * 2);
			
			var p:SG_Point = new SG_Point();
			p.featureID = surface.featureID;
			p.attributeName = surface.attributeName;			

			p.position = target;
			
			return p;
		}
		
		protected static function getMinDist(wc:Coordinate2, r:SG_Ring):Number {
			var minDist:Number = Number.MAX_VALUE;
			var coors:CoordinateArray = r.coordinateSequence();
			var bc:Coordinate2 = coors.getItemAt(0) as Coordinate2;
			for (var j:int = 1; j < coors.length; j++) {
				var ec:Coordinate2 = coors.getItemAt(j) as Coordinate2;
				var interval:Number = math.Distance.p2p(bc, ec);
				var dt:Number = 0.25;
				var t:Number = 0;
				var cc:Coordinate2 = new Coordinate2();
				do {
					cc.x = t * (ec.x - bc.x) + bc.x;
					cc.y = t * (ec.y - bc.y) + bc.y;
					
					// Check if cc is visible from wc.
					var intersects:CoordinateArray = 
						math.Relation.intersectToLineString(wc, cc, coors);
					if (intersects == null) {
						var dist:Number = math.Distance.p2p(wc, cc);
						if (dist < minDist) minDist = dist;
					}
					t += dt;
					
				} while (t < 1.0);	
				
				bc = ec;
			}
			return minDist;
		}
		
		public static function locateFacility(argObj:Object): SG_Point {
			// facility locating by applying weighted mean
			var attValues:ArrayList = argObj["surfaces"] as ArrayList;
			var surfaces:ArrayList = new ArrayList();
			var m:int = attValues.length;
			for (var i:int = 0; i < m; i++) {
				var attList:ArrayList = attValues.getItemAt(i) as ArrayList;
				surfaces.addAll(attList);
			}

			attValues   = argObj["stories"]  as ArrayList;
			var stories:ArrayList = new ArrayList();
			m = attValues.length;
			for (i = 0; i < m; i++) {
				attList = attValues.getItemAt(i) as ArrayList;
				stories.addAll(attList);
			}
			
			attValues = argObj["dayNightPopulationRatio"] as ArrayList;
			var dnpRatios:ArrayList = new ArrayList();
			m = attValues.length;
			for (i = 0; i < m; i++) {
				attList = attValues.getItemAt(i) as ArrayList;
				dnpRatios.addAll(attList);
			}
			
			m = surfaces.length;
			var sumNumeratorX:Number  = 0;
			var sumNumeratorY:Number  = 0;
			var sumDenominator:Number = 0;

			for (i = 0; i < m; i++) {
				var s:SG_Surface = surfaces.getItemAt(i) as SG_Surface;
				var exterior:SG_Ring = s.exterior;
				var polygon:CoordinateArray = exterior.coordinateSequence();
				// storey (story in Am) is defined as a level of building.
				
				var storey:Integer = stories.getItemAt(i) as Integer;
				var dnpRatio:Real = dnpRatios.getItemAt(i) as Real;
				var area:Number   = math.Area.getSimpleArea(polygon) * storey.value * dnpRatio.value;
				
				var weight:Number = area;
				var weight2:Number = weight * weight;
				
				attList = new ArrayList();
				attList.addItem(surfaces.getItemAt(i));
				attValues = new ArrayList();
				attValues.addItem(attList);
				argObj = new Object();
				argObj["surface"] = attValues;
				var sPos:SG_Point = centerOfSurface(argObj);
				
				sumNumeratorX += weight2 * sPos.position.x;
				sumNumeratorY += weight2 * sPos.position.y;
				sumDenominator += weight2;
				
			}
			
			var cPos:SG_Point = new SG_Point();
			cPos.position.x = sumNumeratorX / sumDenominator;
			cPos.position.y = sumNumeratorY / sumDenominator;
			
			return cPos;
			
		}
	}
}