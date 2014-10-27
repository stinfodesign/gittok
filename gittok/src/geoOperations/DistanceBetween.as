package geoOperations
{
	import dataTypes.simpleDataTypes.Real;
	import dataTypes.spatialGeometry.*;
	
	import math.Affine;
	import math.AffineParam;
	import math.Distance;
	
	import mx.collections.ArrayList;

	public class DistanceBetween
	{
	
		public function DistanceBetween()
		{
		}
		
		/*
		You can get distance on the ground by using plane coordinates. 
		They are convereted from screen.
		*/
		
		public static function distancePtoP(argObj:Object):ArrayList {
			var ap:AffineParam = argObj["affineParam"] as AffineParam;
			
			var fromAttValues:ArrayList = argObj["fromPoint"] as ArrayList;
			var toAttValues:ArrayList   = argObj["toPoint"] as ArrayList;
			
			var dists:ArrayList = new ArrayList();
			
			for (var i:int = 0; i < fromAttValues.length; i++) {
				var nearest:Number = Number.MAX_VALUE;
				var attValue:ArrayList = fromAttValues.getItemAt(i) as ArrayList;
				var fromPoint:SG_Point = attValue.getItemAt(0) as SG_Point;
			
				var fcr:Coordinate2 = math.Affine.conversion(fromPoint.position, ap.coefficient);
			
				for (var j:int = 0; j < toAttValues.length; j++) {
					attValue = toAttValues.getItemAt(j) as ArrayList;
					var toPoint:SG_Point = attValue.getItemAt(0) as SG_Point;
			
					var tcr:Coordinate2 = math.Affine.conversion(toPoint.position, ap.coefficient);
			
					var d:Number = math.Distance.p2p(fcr, tcr);
					nearest = (nearest > d) ? d: nearest;
				}
				
				var distance:Real = new Real();
				distance.value = nearest;
				dists.addItem(distance);
			}
			return dists;
		}
		
		public static function distancePtoC(argObj:Object):ArrayList {
			var ap:AffineParam = argObj["affineParam"] as AffineParam;
			
			var fromAttValues:ArrayList = argObj["fromPoint"] as ArrayList;
			var toAttValues:ArrayList   = argObj["toCurve"] as ArrayList;
			
			var dists:ArrayList = new ArrayList();
			
			for (var i:int = 0; i < fromAttValues.length; i++) {
				var nearest:Number = Number.MAX_VALUE;
				var attValue:ArrayList = fromAttValues.getItemAt(i) as ArrayList;
				var fromPoint:SG_Point = attValue.getItemAt(0) as SG_Point;
			
				// You shall not change the given value, in this case fromPoint.
				var fcr:Coordinate2 = math.Affine.conversion(fromPoint.position, ap.coefficient);
			
				for (var j:int = 0; j < toAttValues.length; j++) {
					attValue = toAttValues.getItemAt(j) as ArrayList;
					var toCurve:SG_Curve = attValue.getItemAt(0) as SG_Curve;
			
					var coords:CoordinateArray = toCurve.coordinateSeqence() as CoordinateArray;
					for (var k:int = 0; k < coords.length; k++) {
						var coor:Coordinate2 = coords.getItemAt(k) as Coordinate2;
						coor = math.Affine.conversion(coor, ap.coefficient);
						coords.setItemAt(coor, k);
					}
			
					var d:Number = math.Distance.p2ls(fcr, coords);
					nearest = (nearest > d) ? d: nearest;
				}
				var distance:Real = new Real();
				distance.value = nearest;
				dists.addItem(distance);
			}
			return dists;
		}
		
		public static function distancePtoS(argObj:Object):ArrayList {
			var ap:AffineParam = argObj["affineParam"] as AffineParam;
			
			var fromAttValues:ArrayList = argObj["fromPoint"] as ArrayList;
			var toAttValues:ArrayList   = argObj["toSurface"] as ArrayList;
			
			var dists:ArrayList = new ArrayList();
			
			for (var i:int = 0; i < fromAttValues.length; i++) {
				var nearest:Number = Number.MAX_VALUE;
				var attValue:ArrayList = fromAttValues.getItemAt(i) as ArrayList;
				var fromPoint:SG_Point = attValue.getItemAt(0) as SG_Point;
				
				// You shall not change the given value, in this case fromPoint.
				var fcr:Coordinate2 = math.Affine.conversion(fromPoint.position, ap.coefficient);
			
				for (var j:int = 0; j < toAttValues.length; j++) {
					attValue = toAttValues.getItemAt(j) as ArrayList;
					var toSurface:SG_Surface = attValue.getItemAt(0) as SG_Surface;
			

					var ring:SG_Ring = toSurface.exterior;
					var coords:CoordinateArray = ring.coordinateSequence();
			
					for (var k:int = 0; k < coords.length; k++) {
						var coor:Coordinate2 = coords.getItemAt(k) as Coordinate2;
						coor = math.Affine.conversion(coor, ap.coefficient);
						coords.setItemAt(coor, k);
					}
					
					var d:Number = math.Distance.p2ls(fcr, coords);
					nearest = (nearest > d) ? d: nearest;
				}
				var distance:Real = new Real();
				distance.value = nearest;
				dists.addItem(distance);
			}
			return dists;			
		}
		
		public static function distanceCtoC(argObj:Object):ArrayList {
			var ap:AffineParam = argObj["affineParam"] as AffineParam;
			
			var fromAttValues:ArrayList = argObj["fromCurve"] as ArrayList;
			var toAttValues:ArrayList   = argObj["toCurve"] as ArrayList;
			
			var dists:ArrayList = new ArrayList();
			
			var wargObj:Object     = new Object();
			wargObj["affineParam"] = ap;
			wargObj["toCurve"]     = toAttValues;
			
			for (var i:int = 0; i < fromAttValues.length; i++) {
				var nearest:Number = Number.MAX_VALUE;
				var attValue:ArrayList = fromAttValues.getItemAt(i) as ArrayList;
				var fromCurve:SG_Curve = attValue.getItemAt(0) as SG_Curve;
				
				var fromPointArray:ArrayList = new ArrayList();
				
				var crds:CoordinateArray = fromCurve.coordinateSeqence() as CoordinateArray;
				for (var j:int = 0; j < crds.length; j++) {
					var crd:Coordinate2 = crds.getItemAt(j) as Coordinate2;
					var p:SG_Point = new SG_Point;
					p.position = crd;
					fromPointArray.addItem(p);
				}
				
				wargObj["fromPoint"] = fromPointArray;
				
				var ds:ArrayList = distancePtoC(wargObj);
				
				for (var k:int = 0; k < dists.length; k++) {
					var d:Number = ds.getItemAt(k) as Number;
					nearest = (nearest > d) ? d: nearest;
				}

				var distance:Real = new Real();
				distance.value = nearest;
				dists.addItem(distance);
			}
			
			
			return dists;			
		}
		
		public static function distanceCtoS(argObj:Object):ArrayList {
			var ap:AffineParam = argObj["affineParam"] as AffineParam;
			
			var fromAttValues:ArrayList = argObj["fromCurve"] as ArrayList;
			var toAttValues:ArrayList   = argObj["toSurface"] as ArrayList;
			
			var dists:ArrayList = new ArrayList();
			
			var wargObj:Object     = new Object();
			wargObj["affineParam"] = ap;
			wargObj["toSurface"]     = toAttValues;
			
			for (var i:int = 0; i < fromAttValues.length; i++) {
				var nearest:Number = Number.MAX_VALUE;
				var attValue:ArrayList = fromAttValues.getItemAt(i) as ArrayList;
				var fromCurve:SG_Curve = attValue.getItemAt(0) as SG_Curve;
				
				var fromPointArray:ArrayList = new ArrayList();
				
				var crds:CoordinateArray = fromCurve.coordinateSeqence() as CoordinateArray;
				for (var j:int = 0; j < crds.length; j++) {
					var crd:Coordinate2 = crds.getItemAt(j) as Coordinate2;
					var p:SG_Point = new SG_Point;
					p.position = crd;
					var pArray:ArrayList = new ArrayList();
					pArray.addItem(p);
					fromPointArray.addItem(pArray);
				}
				
				wargObj["fromPoint"] = fromPointArray;
				
				var ds:ArrayList = distancePtoS(wargObj);
				
				nearest = Number.MAX_VALUE;
				for (var k:int = 0; k < ds.length; k++) {
					var d:Real = ds.getItemAt(k) as Real;
					nearest = (nearest > d.value) ? d.value: nearest;
				}
				
				var distance:Real = new Real();
				distance.value = nearest;
				dists.addItem(distance);
			}
			return dists;			
		}
		

		
	}
}