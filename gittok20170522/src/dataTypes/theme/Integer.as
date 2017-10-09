package dataTypes.theme
{
	public class Integer extends ThematicDataType
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