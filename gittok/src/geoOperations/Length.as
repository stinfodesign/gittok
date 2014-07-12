package geoOperations
{
	import dataTypes.simpleDataTypes.Real;
	import dataTypes.spatialGeometry.*;
	
	import math.Affine;
	import math.AffineParam;
	import math.LengthLS;
	
	import mx.collections.ArrayList;

	public class Length
	{
		/*
		You can get length on the ground by using plane coordinates. 
		They are convereted from screen.
		*/

		
		public static function lengthOfCurve(argObj:Object):Real {
			var ap:AffineParam = argObj["affineParam"] as AffineParam;

			var attValues:ArrayList = argObj["curve"] as ArrayList;
			var attValue:ArrayList = attValues.getItemAt(0) as ArrayList;
			var curve:SG_Curve = attValue.getItemAt(0) as SG_Curve;

			var coords:ArrayList = curve.coordinateSeqence();
			
			var n:int = coords.length;
			for (var i:int = 0; i < n; i++) {
				var coor:Coordinate2 = coords.getItemAt(i) as Coordinate2;
				coor = math.Affine.conversion(coor, ap.coefficient);
				coords.setItemAt(coor, i);
			}
			
			var rLeng:Real = new Real();
			rLeng.value = math.LengthLS.lengthLS(coords);
			return rLeng;
		}
		
		public function Length()
		{
		}
	}
}