package portrayal.gpm
{
	public class AttributeStylePair
	{	
		public var attName:String;
		public var attType:String;
		public var symLabName:String;
		public var symLabType:String;
		
		public function AttributeStylePair()
		{
		}
		
		public function getXML():XML {
			var str:String = '<AttributeStylePair attName="' + this.attName 
									+ '" attType="' + this.attType 
									+ '" symLabName="' + this.symLabName
									+ '" symLabType="' + this.symLabType
									+ '"/>';
			return XML(str);
		}
		
		public function setXML(_xml:XML): void {
			this.attName = _xml.@attName.toString();
			this.attType = _xml.@attType.toString();
			this.symLabName = _xml.@symLabName.toString();
			this.symLabType = _xml.@symLablType.toString();
		}
		
		
	}
}