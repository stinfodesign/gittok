package dataTypes.place
{
	public class URL extends Place
	{
		
		protected var v:*;
		
		//Constructor		
		public function URL()
		{
			super();
			v = "";
		}
		
		// set and get "value" 
		
		public function get value():String {
			return v as String;
		}
		
		public function set value(_v:String):void {
			v = _v;
		}
	}
}