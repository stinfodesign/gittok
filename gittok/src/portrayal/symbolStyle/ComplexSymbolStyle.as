package portrayal.symbolStyle
{
	import flash.utils.Dictionary;
	
	import portrayal.symbolStyle.*;

	public class ComplexSymbolStyle extends SymbolStyle
	{
		public var pointSymbolStyle:PointSymbolStyle;
		public var lineSymbolStyle:LineSymbolStyle;		
		public var areaSymbolStyle:AreaSymbolStyle;
		
		public function ComplexSymbolStyle()
		{
			super();
			pointSymbolStyle = new PointSymbolStyle();
			lineSymbolStyle  = new LineSymbolStyle();
			areaSymbolStyle  = new AreaSymbolStyle();
		}
		
		public override function getXML():XML {
			var str:String 	= '<ComplexSymbolStyle>';			
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			
			str += pointSymbolStyle.getXML();
			str += lineSymbolStyle.getXML();
			if (areaSymbolStyle != null && areaSymbolStyle.name != "")
				str += areaSymbolStyle.getXML();
			
			str += '</ComplexSymbolStyle>';
			
			return XML(str);			
		}
		
		public override function setXML(_xml:XML, lStyleDic:Dictionary = null):void {
			var strXMLList:XMLList = _xml.inheritance.children();	
			super.setXML(strXMLList[0]);
			
			lineSymbolStyle.setXML(_xml.LineSymbolStyle[0], lStyleDic);
			pointSymbolStyle.setXML(_xml.PointSymbolStyle[0], lStyleDic);
			areaSymbolStyle.setXML(_xml.AreaSymbolStyle[0], lStyleDic);
		}		
	}
}