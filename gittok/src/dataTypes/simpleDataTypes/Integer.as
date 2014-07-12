package dataTypes.simpleDataTypes
{
	public class Integer extends SimpleDataType
	{

		//Constructor
		
		public function Integer()
		{
			super();
		}
		
		// set and get "value" 
		
		public function get value():int {
			return v as int;
		}
		
		public function set value(_v:int):void {
			v = _v;
		}
		
	}
}