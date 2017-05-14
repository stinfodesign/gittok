package math
{
	import dataTypes.spatialGeometry.Coordinate2;
	import dataTypes.spatialGeometry.CoordinateArray;
	
	import mx.collections.ArrayList;
	
	import portrayal.symbol.Circle;

	public class Distance
	{
		public function Distance()
		{
		}
		
		public static function p2p(c0:Coordinate2, c1:Coordinate2):Number {
			var dx:Number = c0.x - c1.x;
			var dy:Number = c0.y - c1.y;
			return Math.sqrt(dx * dx + dy * dy); 
		}
		
		public static function nearestPfromPs(c0:Coordinate2, cs:ArrayList):int {
			var n:Number = cs.length;
			var index:int = -1;
			var nd:Number = Number.MAX_VALUE;
			var c:Coordinate2;
			for (var i:int = 0; i <n; i++) {
				c = cs.getItemAt(i) as Coordinate2;
				var d:Number = p2p(c0, c);
				if (d < nd) {
					nd = d;
					index = i;
				}
			}
			return index;
		}
		
		
		public static function p2l(p:Coordinate2, q0:Coordinate2, q1:Coordinate2):Number {
			var w:Number  = q1.x - q0.x;
			var v:Number  = q1.y - q0.y;
			var ux:Number = p.x  - q0.x;
			var uy:Number = p.y  - q0.y;
			var D:Number  = w * w + v * v;
			if (D == 0.0) {
				// q0 = q1
				return p2p(p, q0);
			}
			
			var t:Number = (ux * w + uy * v) / D;
			
			if (t < 0.0) return p2p(p, q0);
			if (t > 1.0) return p2p(p, q1);
			
			var dx:Number = ux - w * t;
			var dy:Number = uy - v * t;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public static function p2ls(p:Coordinate2, ls:CoordinateArray):Number {
			var n:int = ls.length;
			if (n < 2) return -1;
			
			var d:Number = Number.MAX_VALUE;
			var dw:Number;
			
			var p0:Coordinate2 = ls.getItemAt(0) as Coordinate2;
			for (var i:int = 1; i < n; i++) {
				var p1:Coordinate2 = ls.getItemAt(i) as Coordinate2;
				dw = p2l(p, p0, p1);
				if (dw < 0) return -1;
				p0 = p1;
				if (dw < d) d = dw;
			}
			
			if (d == Number.MAX_VALUE) return -1;
			return d;
		}
		
		public static function p2clb(p:Coordinate2, crl:Circle):Number {
			// distance between point and circle boundary
			var r:Number = p2p(p, crl.center);
			return Math.abs(r - crl.radius);
		}
		
		public static function l2l(p0:Coordinate2, p1:Coordinate2,
								   q0:Coordinate2, q1:Coordinate2):Number {
			var dist:Number = Number.MAX_VALUE;
			var d:Number;
			d = p2l(p0, q0, q1);
			if (dist > d) dist = d;
			d = p2l(p1, q0, q1);
			if (dist > d) dist = d;
			d = p2l(q0, p0, p1);
			if (dist > d) dist = d;
			d = p2l(q1, p0, p1);
			if (dist > d) dist = d;
			
			return dist;
		}
		
		public static function lsAndls(ls0:CoordinateArray, ls1:CoordinateArray):Number {
			var dist:Number = Number.MAX_VALUE;
			var d:Number;
			for (var i:int = 0; i < ls0.length - 1; i++) {
				var p0:Coordinate2 = ls0.getItemAt(i) as Coordinate2;
				var p1:Coordinate2 = ls0.getItemAt(i + 1) as Coordinate2;
				
				for (var j:int = 0; j < ls1.length - 1;j++) {
					var q0:Coordinate2 = ls1.getItemAt(j) as Coordinate2;
					var q1:Coordinate2 = ls1.getItemAt(j + 1) as Coordinate2;
					
					d = l2l(p0, p1, q0, q1);
					if (dist > d) dist = d;
				}
			}
			
			return dist;
		}
		
		private static function makePointSequence(ls:CoordinateArray, dens:int):CoordinateArray {
			var pseq:CoordinateArray = new CoordinateArray();
			
			var n:int  = ls.length;
			var nn:int = dens * n;
			var totalLength:Number = math.LengthLS.lengthLS(ls);
			var interval:Number = totalLength / nn;
			
			var reach:Number = interval;
			var length:Number = 0.;
			var lng:Number = 0.;
			var j:int = 0;
			var crd0:Coordinate2 = ls.getItemAt(0) as Coordinate2;
			pseq.addItem(crd0);
			
			for (var i:int = 1; i < n; i++) {
				var crd1:Coordinate2 = ls.getItemAt(i) as Coordinate2;
				var a:Number = math.Distance.p2p(crd0, crd1);
				lng += a;
				var dv:Number = interval;
				while(reach < lng) {
					var d:Number = dv / a;
					var crd:Coordinate2 = new Coordinate2();
					crd.x = (crd1.x - crd0.x) * d + crd0.x;
					crd.y = (crd1.y - crd0.y) * d + crd0.y;
					pseq.addItem(crd);
					reach += interval;
					dv += interval;
				}
				var lastCrd:Coordinate2 = pseq.getItemAt(pseq.length - 1) as Coordinate2;
				if (math.Distance.p2p(lastCrd, crd1) != 0.) {
					pseq.addItem(crd1);
				}
				crd0 = crd1;
			}
			return pseq;
		}
		
	}
}