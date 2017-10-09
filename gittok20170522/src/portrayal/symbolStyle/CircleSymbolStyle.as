package portrayal.symbolStyle
{
	import flash.utils.Dictionary;

	public class CircleSymbolStyle extends AreaSymbolStyle
	{
		public function CircleSymbolStyle()
		{
			super();
		}
		
		public override function getXML():XML {
			var str:String ='<CircleSymbolStyle>';
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			str += '</CircleSymbolStyle>';
			
			return (XML(str));
		}
		
		public override function setXML(_xml:XML, lStyleDic:Dictionary=null):void {
			var strXMLList:XMLList = _xml.inheritance.children();
			super.setXML(strXMLList[0], lStyleDic);
		}
	}
}