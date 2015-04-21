package geoOperations
{
	import dataTypes.simpleDataTypes.Real;
	import dataTypes.spatialGeometry.Coordinate2;
	import dataTypes.spatialGeometry.CoordinateArray;
	import dataTypes.spatialGeometry.SG_Ring;
	import dataTypes.spatialGeometry.SG_Surface;
	
	import math.Affine;
	import math.AffineParam;
	import math.Area;
	
	import mx.collections.ArrayList;

	public class SurfaceArea
	{
		public function SurfaceArea()
		{
		}
		
		public static function getArea(argObj:Object):Real {
			var ap:AffineParam = argObj["affineParam"] as AffineParam;
			
			var attValues:ArrayList = argObj["surface"] as ArrayList;
			var attValue:ArrayList = attValues.getItemAt(0) as ArrayList;
			var srf:SG_Surface = attValue.getItemAt(0) as SG_Surface;
			
			var area:Number;
			var ring:SG_Ring = srf.exterior;
			var closedLS:CoordinateArray = ring.coordinateSequence();
			
			// coordinate conversion from screen to ground
			var n:int = closedLS.length;
			for (var i:int = 0; i < n; i++) {
				var coor:Coordinate2 = closedLS.getItemAt(i) as Coordinate2;
				coor = math.Affine.conversion(coor, ap.coefficient);
				closedLS.setItemAt(coor, i);
			}

			area = math.Area.getSimpleArea(closedLS);
			n = srf.interior.length;
			for (i = 0; i < n; i++) {
				ring = srf.interior.getItemAt(i) as SG_Ring;
				closedLS = ring.coordinateSequence();
				area += math.Area.getSimpleArea(closedLS);
			}
			if (area < 0) area = -area;
			
			var ans:Real = new Real();
			ans.featureID = srf.featureID;
			ans.value = area;
			return ans;
		}
		
	}
}