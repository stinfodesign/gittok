package dataTypes.simpleDataTypes
{
	public class Real extends SimpleDataType
	{
		
		//Constructor
		
		public function Real()
		{
			super();
		}
		
		// set and get "value" 
		
		public function get value():Number  {
			return v as Number;
		}
		
		public function set value(_v:Number):void {
			v = _v;
		}
		
	}
}