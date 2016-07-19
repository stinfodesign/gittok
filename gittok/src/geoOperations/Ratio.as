package geoOperations
{
	import dataTypes.theme.*;
	import dataTypes.spatialGeometry.SG_Surface;
	
	import mx.collections.ArrayList;

	public class Ratio
	{
		import math.*;
		
		import dataTypes.spatialGeometry.CoordinateArray;
		
		public function Ratio()
		{
		}
		
		public static function getPlotRatio(argObj:Object):ArrayList {
			var landShapeArrayArray:ArrayList = argObj["landShape"] as ArrayList;
			var landShapeArray:ArrayList = landShapeArrayArray.getItemAt(0) as ArrayList;
			var landShape:SG_Surface = landShapeArray.getItemAt(0) as SG_Surface;
			
			var cString:CoordinateArray = landShape.exterior.coordinateSequence();
			var landArea:Number = math.Area.getSimpleArea(cString);
			
			if (landArea == 0.) return null;
			
			var buildingShapeArrayArray:ArrayList = argObj["buildingShape"] as ArrayList;
			var n:int = buildingShapeArrayArray.length;
			var buildingShapeArray:ArrayList = new ArrayList();
			for (var i:int = 0; i < n; i++) {
				var wArray:ArrayList = buildingShapeArrayArray.getItemAt(i) as ArrayList;
				buildingShapeArray.addItem(wArray.getItemAt(0) as SG_Surface); 	
			}
			
			var storiesArrayArray:ArrayList = argObj["stories"] as ArrayList;
			n = storiesArrayArray.length;
			var storiesArray:ArrayList = new ArrayList(); 
			for (i = 0; i < n; i++) {
				wArray = storiesArrayArray.getItemAt(i) as ArrayList;
				storiesArray.addItem(wArray.getItemAt(0) as Integer);
			}
			
			var bArea:Number = 0;
			
			for (i = 0; i < buildingShapeArray.length; i++) {
				var buildingShape:SG_Surface = buildingShapeArray.getItemAt(i) as SG_Surface;
				var stories:Integer = storiesArray.getItemAt(i) as Integer;
				
				cString = buildingShape.exterior.coordinateSequence();
				var buildingArea:Number = math.Area.getSimpleArea(cString);
				
				bArea += buildingArea * stories.value;  // plot ratio
				
				//bArea += buildingArea;	// building-to-land ratio
			}
			
			var plotRatio:Real = new Real();
			
			plotRatio.value = bArea / landArea;	
			
			var ratioArray:ArrayList = new ArrayList();
			ratioArray.addItem(plotRatio);
			
			return ratioArray;
		}
	}
}