package math
{
	import dataTypes.spatialGeometry.Coordinate2;
	import dataTypes.spatialGeometry.CoordinateArray;

	public class EastWest
	{
		public function EastWest()
		{
		}
		
		public static function isLEastOfP(p:Coordinate2, p1:Coordinate2, p2:Coordinate2):Number {
			// if return value is minus then line is in west side.
			if (p1.y == p2.y) {
				if (p.y == p1.y) {
					var d:Number = Math.min(p1.x, p2.x) - p.x;
					if (d >= 0) return d;
				}
				return -1;
			}
			
			var t:Number = (p.y - p1.y) / (p2.y - p1.y);
			if (t < 0 || t > 1) return -1;
			
			var x:Number = (p2.x - p1.x) * t + p1.x;
			if (p.x <= x) return x - p.x;
			
			return -1;
		}
		
		public static function isLSEastOfP(p:Coordinate2, ls:CoordinateArray):Number {
			var p1:Coordinate2;
			var p2:Coordinate2;
			var eastNearest:Number = Number.MAX_VALUE;

			p1 = ls.getItemAt(0) as Coordinate2;
			
			for (var i:int = 1; i < ls.length; i++) {
				p2 = ls.getItemAt(i) as Coordinate2;
				var d:Number = isLEastOfP(p, p1, p2);
				if(d > 0)
					eastNearest = Math.min(d, eastNearest); 
				p1 = p2;
			}
			
			if (eastNearest == Number.MAX_VALUE) return -1;
			
			return eastNearest;
		}
	}
}