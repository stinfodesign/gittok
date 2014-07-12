package math
{
	import dataTypes.spatialGeometry.Coordinate2;
	import dataTypes.spatialGeometry.CoordinateArray;
	
	public class Area
	{
		public function Area()
		{
		}
		
		public static function getSimpleArea(cArray:CoordinateArray):Number {
			var b:Number = 0;
			var n:int = cArray.length;
			var ci:Coordinate2 = cArray.getItemAt(0) as Coordinate2;	
			for (var i:int = 1; i < n; i++) {
				var ci1:Coordinate2 = cArray.getItemAt(i) as Coordinate2;
				b += (ci1.x * ci.y - ci.x * ci1.y);
				ci = ci1;
			}
			// if b < 0, then rotation is anti-clockwise!
			return Math.abs(b * 0.5);
		}
	}
}