package math
{
	import dataTypes.spatialGeometry.Coordinate2;
	
	import mx.collections.ArrayList;

	public class LengthLS
	{
		
		public static function lengthLS(coords:ArrayList):Number {
			var n:int = coords.length;
			var c0:Coordinate2 = coords.getItemAt(0) as Coordinate2;
			var len:Number = 0;
			for (var i:int = 1; i < n; i++) {
				var c1:Coordinate2 = coords.getItemAt(i) as Coordinate2;
				var dx:Number = c1.x - c0.x;
				var dy:Number = c1.y - c0.y;
				len += Math.sqrt(dx * dx + dy * dy);
				c0 = c1;
			}
			return len;
		}
		
		public function LengthLS()
		{
		}
	}
}