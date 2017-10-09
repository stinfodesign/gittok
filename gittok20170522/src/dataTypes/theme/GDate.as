package dataTypes.theme
{
	public class GDate extends ThematicDataType
	{
		public function GDate()
		{
			super();
		}
		
		// set and get "value" 
		
		public function get value():Date  {
			return v as Date;
		}
		
		public function set value(_v:Date):void {
			v = _v;
		}
	}
}