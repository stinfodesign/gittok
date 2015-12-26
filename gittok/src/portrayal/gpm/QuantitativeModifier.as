package portrayal.gpm
{
	public class QuantitativeModifier extends Modifier
	{
		public var lowerValue:Number;
		public var upperValue:Number;
		
		public function QuantitativeModifier()
		{
			super();
		}
		
		public override function getXML():XML {
			var str:String = '<QuantitativeModifier lowerValue="' + lowerValue + '" upperValue="' + upperValue + '">';
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			str += '</QuantitativeModifier>';
			
			return XML(str);
		}
		
		public override function setXML(_xml:XML):void {
			lowerValue = _xml.@lowerValue.toString();
			upperValue = _xml.@upperValue.toString();
			var md:XML = _xml.inheritance;
			super.setXML(md);
		}		
	}
}