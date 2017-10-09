package portrayal.gpm
{
	public class AttributeStylePair
	{	
		public var attName:String;
		public var attType:String;
		
		public function AttributeStylePair()
		{
		}
		
		public function getXML():XML {
			var str:String = '<AttributeStylePair attName="' + this.attName 
									+ '" attType="' + this.attType 
									+ '"/>';
			return XML(str);
		}
		
		public function setXML(_xml:XML): void {
			this.attName = _xml.@attName.toString();
			this.attType = _xml.@attType.toString();
		}
		
		
	}
}