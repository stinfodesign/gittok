package portrayal.gpm
{
	public class AttributeLabelPair extends AttributeStylePair
	{
		
		public var labelName:String;
		public var labelType:String;
		public var refGeomAttName:String;
		public var roundDecimal:int;
		public var unit:String;
		public var locale:String;
		
		public function AttributeLabelPair()
		{
			super();
		}
		
		public override function getXML():XML {
			var str:String = '<AttributeLabelPair labelName="' + this.labelName 
				+ '" labelType="' + this.labelType 
				+ '" refGeomAttName="' + this.refGeomAttName
				+ '" roundDecimal="' + this.roundDecimal
				+ '" unit="' + this.unit
				+ '" locale="' + this.locale
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
			var rdString:String	= _xml.@roundDecimal.toString();
			this.roundDecimal	= parseInt(rdString);
			this.unit			= _xml.@unit;
			this.locale			= _xml.@locale;
			
			var strXMLList:XMLList = _xml.inheritance.children();
			var strXML:XML = strXMLList[0];
			super.setXML(strXML);
		}			
	}
}