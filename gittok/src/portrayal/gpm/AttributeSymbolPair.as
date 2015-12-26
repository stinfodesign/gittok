package portrayal.gpm
{
	public class AttributeSymbolPair extends AttributeStylePair
	{
		
		public var symName:String;
		public var symType:String;
		
		public function AttributeSymbolPair()
		{
			super();			
		}
		
		public override function getXML():XML {
			var str:String = '<AttributeSymbolPair symName="' + this.symName 
				+ '" symType="' + this.symType + '">';
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			str += '</AttributeSymbolPair>';
			return XML(str);
			trace(str);
		}
		
		public override function setXML(_xml:XML): void {
			this.symName = _xml.@symName.toString();
			this.symType = _xml.@symType.toString();
			
			var strXMLList:XMLList = _xml.inheritance.children();
			var strXML:XML = strXMLList[0];
			super.setXML(strXML);
		}		
	}
}