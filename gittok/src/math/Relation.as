package math
{
	import dataTypes.spatialGeometry.*;
	
	import mx.collections.ArrayList;
	import mx.events.CalendarLayoutChangeEvent;

	public class Relation
	{
		public function Relation()
		{
		}
		
		public static function nearestPonL(p:Coordinate2, p0:Coordinate2, p1:Coordinate2):Coordinate2 {
			var p0d:Coordinate2 = new Coordinate2();
			p0d.x = p0.x - p.x;
			p0d.y = p0.y - p.y;
			
			var p1d:Coordinate2 = new Coordinate2();
			p1d.x = p1.x - p.x;
			p1d.y = p1.y - p.y;
			
			var dx:Number = p1d.x - p0d.x;
			var dy:Number = p1d.y - p0d.y;
			
			var dd:Number = dx * dx + dy * dy;
			
			if (dd == 0) return null;
			
			var t:Number  = - (dx * p0d.x + dy * p0d.y) / dd;
			
			if (t < 0) {
				return p0;
			}
			
			if (t > 1) {
				return p1;
			}
			
			var crd:Coordinate2 = new Coordinate2();
			crd.x = t * dx + p0.x;
			crd.y = t * dy + p0.y;
			return crd;
			
		}
		
		public static function nearestPonLS(p:Coordinate2, ls:ArrayList):Coordinate2 {
			var n:int = ls.length;
			if (n < 2) return null;
			
			var d:Number = Number.MAX_VALUE;
			var dw:Number;
			var nearest:Coordinate2;
			
			var p0:Coordinate2 = ls.getItemAt(0) as Coordinate2;
			for (var i:int = 1; i < n; i++) {
				var p1:Coordinate2 = ls.getItemAt(i) as Coordinate2;
				dw = Distance.p2l(p, p0, p1);
				if (dw < d) {
					d = dw;
					nearest = nearestPonL(p, p0, p1);
				}
				p0 = p1;
			}
			
			if (d == Number.MAX_VALUE) return null;
			
			return nearest;
		}
		
		public static function nearestVertexIndex(p:Coordinate2, ls:CoordinateArray):int {
			// get nearest vertex of intermediate line string to the given point
			// line string must have more than  or equal to 1 vertex.
			var n:int = ls.length;
			if (n < 1) return -1;
			
			var d:Number = Number.MAX_VALUE;
			var dw:Number;
			var nearest:Coordinate2;
			var index:int = -1;
			for (var i:int = 0; i < n; i++) {
				var p0:Coordinate2 = ls.getItemAt(i) as Coordinate2;
				dw = Distance.p2p(p, p0);
				if (dw < d) {
					d = dw;
					index = i;
				}
			}
			
			return index;
		}
		
		public static function intersectToLineString(c0:Coordinate2, c1:Coordinate2, 
													 ls:CoordinateArray):CoordinateArray {
			
			var intersects:CoordinateArray = new CoordinateArray();
			var n:int = ls.length;
			if (n < 2) return null;
			
			var c2:Coordinate2 = ls.getItemAt(0) as Coordinate2;
			var c3:Coordinate2;
			for (var i:int = 1; i < n; i++) {
				c3 = ls.getItemAt(i) as Coordinate2;
				var c4:Coordinate2 = intersection(c0, c1, c2, c3);
				if (c4 != null) intersects.addItem(c4);
				c2 = c3;
			}
			if (intersects.length == 0) return null;
			
			return intersects;
		}

		public static function intersection(c0:Coordinate2, c1:Coordinate2, 
											c2:Coordinate2, c3:Coordinate2):Coordinate2 {

			var a:Number = c1.x - c0.x;
			var b:Number = c3.x - c2.x;
			var c:Number = c2.x - c0.x;
			var e:Number = c1.y - c0.y;
			var f:Number = c3.y - c2.y;
			var g:Number = c2.y - c0.y;
			
			var d:Number = a * f - b * e;
			if (d != 0) {
				var t:Number = (f * c - b * g) / d;
				var s:Number = (e * c - a * g) / d;
				if (0.1e-10 < t && t < (1 - 0.1e-10) && 0.1e-10 < s && s < (1 - 0.1e-10)) {
					var ac:Coordinate2 = new Coordinate2();
					ac.x = t * a + c0.x;
					ac.y = t * e + c0.y;
					return ac;
				}
			}
			return null;
		}
		
		public static function pointInRing(c:Coordinate2, ring:SG_Ring):Boolean {
			
			var i:int;
			var j:int;
			var n:int;
			var count:int = 0;
			var x:Number;
			var dx:Number;
			var dy:Number;
			var t:Number;
			var c0:Coordinate2;
			var c1:Coordinate2;
			var c2:Coordinate2;
			
			var cArray:ArrayList = ring.coordinateSequence();
			
			n = cArray.length;
			// check if a point located on the border
			for (i = 0; i < (n - 1); i++) {
				c0 = cArray.getItemAt(i) as Coordinate2;				
				c1 = cArray.getItemAt(i + 1) as Coordinate2;
				if ((c.x == c0.x) && (c.y == c0.y)) {
					return false;
				}
				dx = c1.x - c0.x;
				dy = c1.y - c0.y;
				if ((dy * (c.x - c0.x)) == (dx * (c.y - c0.y))) {
					return false;
				}
			}
			
			// check intersection with the border line
			c0 = cArray.getItemAt(0) as Coordinate2;
			for (i = 1; i < n; i++) {
				c1 = cArray.getItemAt(i) as Coordinate2;
				dx = c1.x - c0.x;
				dy = c1.y - c0.y;
				if (dy != 0.0) {
					t = (c.y - c0.y) / dy;
					x = dx * t + c0.x;
					if ((t > 0.0) && (t < 1.0) && (x > c.x)) {
						count++;
					}	  
				}
				c0 = c1;					
			}
			
						
			// check intersection with the border point
			i = 0;
			while (i < (n - 1)) {
				c1 = cArray.getItemAt(i) as Coordinate2;
				if ((c.y == c1.y) && (c.x < c1.x)) {
					j = i - 1;
					if (j < 0) j = n - 2;
					c0 = cArray.getItemAt(j) as Coordinate2;
					while (c.y == c0.y) {
						j--;
						if (j < 0) j = n - 2;
						c0 = cArray.getItemAt(j) as Coordinate2;
					}
					j = i + 1;
					c2 = cArray.getItemAt(j) as Coordinate2;
					while (c.y == c2.y) {
						j++;
						if (j == (n - 2)) j = 0;
						c2 = cArray.getItemAt(j) as Coordinate2;
					}
					dy = c2.y - c0.y;
					if (dy != 0.0) {
						t = (c.y - c0.y) / dy;
						if ((t > 0) && (t < 1.0)) {
							count++;
							break;
						}
					}
					if (i < j) i = j;
					else i = n - 1;
				}
				else i++;
			}
			
			if ((count % 2) == 1) return true;
			else return false;

		}
	}
}