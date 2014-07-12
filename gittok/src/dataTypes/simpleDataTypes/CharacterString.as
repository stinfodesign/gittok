package dataTypes.simpleDataTypes
{
	public class CharacterString extends SimpleDataType
	{
		
		//Constructor
		
		public function CharacterString()
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