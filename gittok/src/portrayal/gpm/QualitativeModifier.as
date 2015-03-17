package portrayal.gpm
{
	public class QualitativeModifier extends Modifier
	{
		public var stringValue:String;
		
		public function QualitativeModifier()
		{
			super();
		}
		
		public override function getXML():XML {
			var str:String = '<QualitativeModifier stringValue="' + stringValue + '">';
			str += '<inheritance>';
			str += super.getXML().toString();
			str += '</inheritance>';
			str += '</QualitativeModifier>';
			
			return XML(str);
		}
		
		public override function setXML(_xml:XML):void {
			stringValue = _xml.@stringValue;
			var md:XML = _xml.inheritance;
			super.setXML(md);
		}
	}
}