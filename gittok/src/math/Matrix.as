package math
{
	public class Matrix
	{
		public function Matrix()
		{
		}

		public static function copy(a:Array):Array {
			var m:int = a.length;
			var n:int = a[0].length;
			var b:Array = new Array();
			for (var i:int = 0; i < m; i++) {
				var c:Array = new Array();
				b[i] = c;
				for (var j:int = 0; j < n; j++) {
					b[i][j] = a[i][j];
				}
			}
			return b;
		}
		
		public static function determinant(a:Array):Number {
			var r:Number;
			var i:int;
			var j:int;
			var k:int;
			var n:int = a.length;
			var akk:Number;
			var aik:Number;
			
			var d:Number = 1.0;
			
			for (k = 0; k < n; k++) {
				akk = a[k][k];
				d *= akk;
				if (akk == 0.0) break;
				for(j = k; j < n; j++) {
					a[k][j] /= akk;
				}
				for(i = k + 1; i < n; i++) {
					aik = a[i][k];
					for (j = k; j < n; j++) {
						a[i][j] -= aik * a[k][j];
					}
				}
			}
			
			return d;
		}
		
		public static function transpose(a:Array):Array {
			var m:int = a.length;
			var n:int = a[0].length;
			var t:Array = new Array();
			
			for (var j:int = 0; j < n; j++) {
				t[j] = new Array();
				for (var i:int = 0; i < m; i++) {
					t[j][i] = a[i][j];
				}
			}
			return t;
		}
		
		public static function multiple(a:Array, b:Array):Array {
			
			var m:int = a.length;		
			var n:int = a[0].length;
			var p:int = b[0].length;
			
			if (n != b.length)  throw new Error("cannot multiple");
			
			var c:Array = new Array();
			
			for (var i:int = 0; i < m; i++) {
				c[i] = new Array();
				for (var k:int = 0; k < p; k++) {
					c[i][k] = 0.;
					for (var j:int = 0; j < n; j++) {
						c[i][k] += a[i][j] * b[j][k];
					}
				}
			}
			return c;
		}
		
		public static function inverse(b:Array):Array {
			var a:Array = copy(b);
			var n:int = a.length;

			for(var i:int = 0; i < n; i++ ){
				for(var j:int = i+1; j < n; j++ ){
					a[j][i] /= a[i][i];
					for(var k:int = i+1; k < n; k++ ){
						a[j][k] -= a[i][k] * a[j][i];
					}
				}
			}
			
			
			var c:Array = new Array();
			for(i = 0; i < n; i++) c[i] = new Array();
			
			for(k = 0; k < n; k++ ) {				
				for(i = 0; i < n; i++ ) {
					if( i == k ) { 
						c[i][k] = 1; 
					}
					else{ 
						c[i][k] = 0; 
					}
				}
				
				for(i = 0; i < n; i++ ) {
					for(j = i+1; j < n; j++ ) {
						c[j][k] -= c[i][k] * a[j][i];
					}
				}
				for(i = n-1; i >= 0; i-- ) {
					for(j = i+1; j<n; j++ ) {
						c[i][k] -= a[i][j] * c[j][k];
					}
					c[i][k] /= a[i][i];
				}
			}
			return c;
		}
		
		public static function add(a:Array, b:Array):Array {
			var m:int = a.length;
			var n:int = a[0].length;
			var c:Array = new Array();
			for (var i:int = 0; i < m; i++) c[i] = new Array();
			
			for (i = 0; i < m; i++) {
				for (var j:int = 0; j < n; j++) {
					c[i][j] = a[i][j] + b[i][j];
				}
			}
			return c;
		}
		
		public static function sub(a:Array, b:Array):Array {
			var m:int = a.length;
			var n:int = a[0].length;
			var c:Array = new Array();
			for (var i:int = 0; i < m; i++) c[i] = new Array();
			
			for (i = 0; i < m; i++) {
				for (var j:int = 0; j < n; j++) {
					c[i][j] = a[i][j] - b[i][j];
				}
			}
			return c;
		}
		
		public static function getAffineParams(X:Array, x:Array):Array {
			/*
			X = x*A
			xT*X = xT*x*A
			inv(xT*x)*xT*X = A
			thus, A = inv(xT*x)*xT*X;			
			*/

			var xt:Array = transpose(x);
			var xtx:Array = multiple(xt, x);
			var inv:Array = inverse(xtx);
			var ixt:Array = Matrix.multiple(inv, xt);
			return multiple(ixt, X);  
		}
		
	}
}