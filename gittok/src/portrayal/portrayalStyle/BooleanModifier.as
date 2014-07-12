package portrayal.portrayalStyle
{
	public class BooleanModifier extends Modifier
	{
		public var boolValue:Boolean;
		
		public function BooleanModifier()
		{
			super();
		}
		
		public override function getXML():XML {
			var str:String = '<BooleanModifier boolValue="' + boolValue.toString() + '">';
			str += '<inheritance>';
			str += super.getXML().toString();
			str += '</inheritance>';
			str += '</BooleanModifier>';
			
			return XML(str);
		}
		
		public override function setXML(_xml:XML):void {
			var bv:String = _xml.@boolValue.toString();
			boolValue = (bv == "true") ? true : false;
			var md:XML = _xml.inheritance;
			super.setXML(md);
		}
	}
}