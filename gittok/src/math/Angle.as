package math
{
	import dataTypes.spatialGeometry.Coordinate2;
	
	import mx.collections.ArrayList;

	public class Angle
	{
		public function Angle()
		{
		}
		
		public static function decimalToRad(decimal:Number):Number {
			return Math.PI * decimal / 180.0; 	
		}
		
		public static function radToDecimal(rad:Number):Number {
			return rad * 180.0 / Math.PI;
		}
		
		public static function degToRad(degsec:Number):Number {
			// degsec: angle taking the style of dddmmss.sssss
			var s2r:Number 	= Math.PI/648000.; 
			var sgn:int = 1;
			if (degsec < 0.) {
				degsec = -degsec;
				sgn = -1;
			}			
			var deg:Number = Math.floor(degsec/10000.);
			var min:Number = Math.floor((degsec-deg*10000.)/100.);
			var angle:Number = sgn * (deg*3600.+ min*60.+ (degsec - deg*10000. - min*100.))*s2r;
			return angle;
		}
		
		public static function radToDeg(rad:Number):Number {
			// return the value taking the style of dddmmss.sssss
			var s2r:Number 	= Math.PI/648000.; 
			var sgn:int = 1;
			if (rad < 0.) {
				rad = -rad;
				sgn = -1;
			}
			var sec:Number = rad / s2r;
			var min:int = int(sec / 60);
			var deg:int = min / 60;
			min = min - deg * 60;
			sec = sec - deg * 3600 - min * 60;
			
			var angle:Number = sgn * (deg*10000 + min*100 + sec);
			return angle;
		}
		
		public static function azimuth(c0:Coordinate2, c1:Coordinate2):Number {
			if (Distance.p2p(c0, c1) == 0) return Number.MIN_VALUE;
			
			var dx:Number = c1.x - c0.x;
			var dy:Number = c1.y - c0.y;
			var az:Number = Math.atan2(dy, dx);
			if (az < 0.0) az += Math.PI * 2.0;
			return az;
		}
		
		public static function bearing(c0:Coordinate2, c1:Coordinate2, c2:Coordinate2):Number {
			var az0:Number = azimuth(c0, c1);
			var az1:Number = azimuth(c1, c2);
			var bear:Number = az1 + (Math.PI - az0);
			if (bear > 2.0 * Math.PI) return bear - 2.0 * Math.PI;
			if (bear < 0.0) return bear + 2.0 * Math.PI;
			return bear;
		}
	}
}