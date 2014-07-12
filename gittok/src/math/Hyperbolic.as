package math
{
	public class Hyperbolic
	{
		public function Hyperbolic()
		{
		}
		
		public static function sinh(x:Number):Number { 
			return 0.5*(Math.exp(x)-Math.exp(-x)) 
		}
		
		public static function cosh(x:Number):Number { 
			return 0.5*(Math.exp(x)+Math.exp(-x)) 
		}
		
		public static function tanh(x:Number):Number {
			return sinh(x) / cosh(x);
		}
		
		public static function arctanh(x:Number):Number { 
			return 0.5*Math.log((1+x)/(1-x)) 
		}
	}
}