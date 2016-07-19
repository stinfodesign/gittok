package dataTypes.theme
{
	public class Bool extends ThematicDataType
	{
		
		
		//Constructor
		
		public function Bool()
		{
			super();
			v = false;
		}
		
		// set and get "value" 
		
		public function get value():Boolean {
			return v as Boolean;
		}
		
		public function set value(_v:Boolean):void {
			v = _v;
		}
				
	}
}