package geoOperations
{
	import dataTypes.simpleDataTypes.*;
	import dataTypes.spatialGeometry.*;
	
	import math.*;
	
	import mx.collections.ArrayList;

	public class Buffer
	{
		public function Buffer()
		{
		}

	
		public static function getOnBufferPoints(argObj:Object):ArrayList {
			// affine parameters
			var ap:AffineParam = argObj["affineParam"] as AffineParam;
			
			// maximum distance from a curve
			attValues = argObj["maxDistance"] as ArrayList;
			attValue = attValues.getItemAt(0) as ArrayList;
			var dist:Real = attValue.getItemAt(0) as Real;
			var distValue:Number = dist.value;
			
			// lineStrings
			var attValues:ArrayList = argObj["baseCurve"] as ArrayList;
			
			// target geometry
			var pntValues:ArrayList = argObj["points"] as ArrayList;
			
			// initialize onBuffer
			var onBuffer:ArrayList = new ArrayList();
			for (var i:int = 0; i < pntValues.length; i++) {
				onBuffer.addItem(new Bool());	// initial value is false
			}
			
			for (i = 0; i < attValues.length; i++) {
				var attValue:ArrayList = attValues.getItemAt(i) as ArrayList;
				var cur:SG_Curve = attValue.getItemAt(0) as SG_Curve;
				var lineString:CoordinateArray = cur.coordinateSeqence();
				
				// line string (base line) conversion
				for (var j:int = 0; j < lineString.length; j++) {
					var coor:Coordinate2 = lineString.getItemAt(j) as Coordinate2;
					coor = math.Affine.conversion(coor, ap.coefficient);
					lineString.setItemAt(coor, j);
				}		
				
				var points:ArrayList = new ArrayList();
				for (j = 0; j < pntValues.length; j++) {
					attValue = pntValues.getItemAt(j) as ArrayList;
					points.addItem(attValue.getItemAt(0) as SG_Point);
				}
				
				var pnt:SG_Point;
				var d:Number;
				
				for (j = 0; j < pntValues.length; j++) {
					pnt = points.getItemAt(j) as SG_Point;
					var crd:Coordinate2 = pnt.position;
					var wcrd:Coordinate2 = math.Affine.conversion(crd, ap.coefficient);
					
					d = math.Distance.p2ls(wcrd, lineString);
					
					var inOut:Bool = new Bool();
					inOut.featureID = pnt.featureID;
					
					if (d < distValue) {
						inOut.value = true;
					}
					else {
						inOut.value = false;
					}
					
					var ib:Bool = onBuffer.getItemAt(j) as Bool;
					if (!ib.value) 
						onBuffer.setItemAt(inOut, j);
				}
			}
			
			return onBuffer;
		}

	
		public static function getOnBufferCurves(argObj:Object):ArrayList {
			// affine parameters
			var ap:AffineParam = argObj["affineParam"] as AffineParam;
			
			// maximum distance from a curve
			attValues = argObj["maxDistance"] as ArrayList;
			attValue = attValues.getItemAt(0) as ArrayList;
			var dist:Real = attValue.getItemAt(0) as Real;
			var distValue:Number = dist.value;
			
			// lineStrings
			var attValues:ArrayList = argObj["baseCurve"] as ArrayList;
			
			// target geometry
			var curValues:ArrayList = argObj["curves"] as ArrayList;
			
			// initialize onBuffer
			var onBuffer:ArrayList = new ArrayList();
			for (var i:int = 0; i < curValues.length; i++) {
				onBuffer.addItem(new Bool());	// initial value is false
			}
			
			for (i = 0; i < attValues.length; i++) {
				var attValue:ArrayList = attValues.getItemAt(i) as ArrayList;
				var curve:SG_Curve = attValue.getItemAt(0) as SG_Curve;
				var lineString:CoordinateArray = curve.coordinateSeqence();
				
				// line string (base line) conversion
				for (var j:int = 0; j < lineString.length; j++) {
					var coor:Coordinate2 = lineString.getItemAt(j) as Coordinate2;
					coor = math.Affine.conversion(coor, ap.coefficient);
					lineString.setItemAt(coor, j);
				}		
				
				var curves:ArrayList = new ArrayList();
				for (j = 0; j < curValues.length; j++) {
					attValue = curValues.getItemAt(j) as ArrayList;
					curves.addItem(attValue.getItemAt(0) as SG_Curve);
				}
				
				var cur:SG_Curve;
				var d:Number;
				
				for (j = 0; j < curValues.length; j++) {
					cur = curves.getItemAt(j) as SG_Curve;
					var ls:CoordinateArray = cur.coordinateSeqence();
					
					for (var k:int = 0; k < ls.length; k++) {
						var wcrd:Coordinate2 = ls.getItemAt(k) as Coordinate2;
						// coordinate conversion
						wcrd = math.Affine.conversion(wcrd, ap.coefficient);
						ls.setItemAt(wcrd, k);
					}
					d = math.Distance.lsAndls(ls, lineString);
					
					var inOut:Bool = new Bool();
					inOut.featureID = cur.featureID;
					
					if (d < distValue) {
						inOut.value = true;
					}
					else {
						inOut.value = false;
					}
					
					var ib:Bool = onBuffer.getItemAt(j) as Bool;
					if (!ib.value) 
						onBuffer.setItemAt(inOut, j);
				}
			}
			
			return onBuffer;
		}
	
		public static function getOnBufferSurfaces(argObj:Object):ArrayList {
			// affine parameters
			var ap:AffineParam = argObj["affineParam"] as AffineParam;
				
			// maximum distance from a curve
			attValues = argObj["maxDistance"] as ArrayList;
			attValue = attValues.getItemAt(0) as ArrayList;
			var dist:Real = attValue.getItemAt(0) as Real;
			var distValue:Number = dist.value;
		
			// lineStrings
			var attValues:ArrayList = argObj["baseCurve"] as ArrayList;
			
			// target geometry
			var surValues:ArrayList = argObj["surfaces"] as ArrayList;
			
			// initialize onBuffer
			var onBuffer:ArrayList = new ArrayList();
			for (var i:int = 0; i < surValues.length; i++) {
				onBuffer.addItem(new Bool());	// initial value is false
			}
			
			for (i = 0; i < attValues.length; i++) {
				var attValue:ArrayList = attValues.getItemAt(i) as ArrayList;
				var curve:SG_Curve = attValue.getItemAt(0) as SG_Curve;
				var lineString:CoordinateArray = curve.coordinateSeqence();
		
				// line string (base line) conversion
				for (var j:int = 0; j < lineString.length; j++) {
					var coor:Coordinate2 = lineString.getItemAt(j) as Coordinate2;
					coor = math.Affine.conversion(coor, ap.coefficient);
					lineString.setItemAt(coor, j);
				}		
						
				var surfaces:ArrayList = new ArrayList();
				for (j = 0; j < surValues.length; j++) {
					attValue = surValues.getItemAt(j) as ArrayList;
					surfaces.addItem(attValue.getItemAt(0) as SG_Surface);
				}
		
				var srf:SG_Surface;
				var d:Number;
				
				for (j = 0; j < surValues.length; j++) {
					srf = surfaces.getItemAt(j) as SG_Surface;
					var rng:SG_Ring = srf.exterior;
					var ls:CoordinateArray = rng.coordinateSequence();
				
					for (var k:int = 0; k < ls.length; k++) {
						var wcrd:Coordinate2 = ls.getItemAt(k) as Coordinate2;
						// coordinate conversion
						wcrd = math.Affine.conversion(wcrd, ap.coefficient);
						ls.setItemAt(wcrd, k);
					}
					d = math.Distance.lsAndls(ls, lineString);
				
					var inOut:Bool = new Bool();
					inOut.featureID = srf.featureID;
				
					if (d < distValue) {
						inOut.value = true;
					}
					else {
						inOut.value = false;
					}
					
					var ib:Bool = onBuffer.getItemAt(j) as Bool;
					if (!ib.value) 
						onBuffer.setItemAt(inOut, j);
				}
			}
		
			return onBuffer;
		}
	}
}