package portrayal.gpm
{
	public class AttributeLabelPair extends AttributeStylePair
	{
		
		public var labelName:String;
		public var labelType:String;
		public var refGeomAttName:String;
		
		public function AttributeLabelPair()
		{
			super();
		}
		
		public override function getXML():XML {
			var str:String = '<AttributeLabelPair labelName="' + this.labelName 
				+ '" labelType="' + this.labelType 
				+ '" refGeomAttName="' + this.refGeomAttName
				+ '">';
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			str += '</AttributeLabelPair>';
			return XML(str);
		}
		
		public override function setXML(_xml:XML): void {
			this.labelName 		= _xml.@labelName.toString();
			this.labelType 		= _xml.@labelType.toString();
			this.refGeomAttName	= _xml.@refGeomAttName.toString();
			
			var strXMLList:XMLList = _xml.inheritance.children();
			var strXML:XML = strXMLList[0];
			super.setXML(strXML);
		}			
	}
}