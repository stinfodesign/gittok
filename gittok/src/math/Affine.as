package math
{
	import dataTypes.spatialGeometry.Coordinate2;
	
	import math.Matrix;
	
	public class Affine
	{

		public function Affine()
		{
		}
		
		public static function getParameters(X:Array, x:Array):AffineParam {
			var ap:AffineParam = new AffineParam();
			
			/*
			X = x*A
			xT*X = xT*x*A
			inv(xT*x)*xT*X = A
			thus, A = inv(xT*x)*xT*X;			
			*/
			
			ap.coefficient = Matrix.getAffineParams(X, x);
			
			// accuracy evaluation
			/*
			XD = x*A
			dX = XD - X
			mean = dX / m		--- mean value
			dX = dX - mean;
			SD = dXT*dX / m		--- variance, co-variance matrix
			*/
			
			var XD:Array = new Array();
			XD = math.Matrix.multiple(x, ap.coefficient);
			ap.error = new Array();
			ap.error = math.Matrix.sub(XD, X);

			
			//variance and co-variance
			var m:int = ap.error.length;
			ap.variance = math.Matrix.multiple(math.Matrix.transpose(ap.error), ap.error);
			for (var i:int = 0; i < 2; i++) {
				for (var j:int = 0; j < 2;j++) {
					ap.variance[i][j] = ap.variance[i][j] / m;
				}
			}
			
			return ap;   
		}
		
		public static function conversion(crd:Coordinate2, coef:Array):Coordinate2 {
			var x:Array = new Array();
			x[0] = new Array();
			x[0][0] = crd.x;
			x[0][1] = crd.y;
			x[0][2] = 1;
						
			var X:Array = Matrix.multiple(x, coef);
			var plane:Coordinate2 = new Coordinate2();
			plane.x = X[0][0];
			plane.y = X[0][1];
			
			return plane;		
		}
		
		public static function inverseConversion(crd:Coordinate2, coef:Array):Coordinate2 {
			var X:Array = new Array();
			X[0] = new Array();
			X[0][0] = crd.x;
			X[0][1] = crd.y;
			X[0][2] = 1;
			
			var c4i:Array = coef;
			c4i[0][2] = c4i[1][2] = 0;
			c4i[2][2] = 1;
			
			var inv:Array = Matrix.inverse(c4i);
			//var check:Array = Matrix.multiple(coef, inv);
			var x:Array = Matrix.multiple(X, inv);
			var map:Coordinate2 = new Coordinate2();
			map.x = x[0][0];
			map.y = x[0][1];
			
			return map;
		}
	}
}