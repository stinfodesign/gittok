package portrayal.gpm
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
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			str += '</BooleanModifier>';
			
			return XML(str);
		}
		
		public override function setXML(_xml:XML):void {
			var bv:String = _xml.@boolValue.toString();
			boolValue = (bv == "true") ? true : false;
			var mdList:XMLList = _xml.inheritance.children();
			super.setXML(mdList[0]);
		}
	}
}