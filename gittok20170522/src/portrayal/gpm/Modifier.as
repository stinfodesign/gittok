package portrayal.gpm
{
	/*
	Abstract class as a parent of boolean, qualitative and quantitative modifiers
	*/
	
	public class Modifier
	{
		public var symName:String;
		public var symType:String;
		public var hasValue:Boolean;
		
		public function Modifier()
		{
		}
		
		public function getXML():XML {
			var str:String = '<Modifier symName="' + symName 
				+ '" symType="' + symType 
				+ '" hasValue="' + hasValue.toString() 
				+ '"/>'; 
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			symName = _xml.@symName.toString();
			symType = _xml.@symType.toString();
			hasValue = (_xml.@hasValue.toString() == "true") ? true : false;
		}
	}
}