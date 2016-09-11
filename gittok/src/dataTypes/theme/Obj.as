package dataTypes.theme
{
	public class Obj extends ThematicDataType
	{
		public function Obj()
		{
			super();
			v = false;
		}
		
		// set and get "value" 
		
		public function get value():Object {
			return v as Object;
		}
		
		public function set value(_v:Object):void {
			v = _v;
		}		
		
	}
}