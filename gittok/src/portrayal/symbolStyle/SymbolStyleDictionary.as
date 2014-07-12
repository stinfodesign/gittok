package portrayal.symbolStyle
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;


	public class SymbolStyleDictionary
	{
		public var name:String;
		
		public var pointSymStyles:Dictionary;
		public var lineSymStyles:Dictionary;
		public var areaSymStyles:Dictionary;
		
		public function SymbolStyleDictionary()
		{
			pointSymStyles	= new Dictionary();
			lineSymStyles	= new Dictionary();
			areaSymStyles	= new Dictionary();
		}
		
		public function getXML():XML {
			var str:String = '<SymbolStyleSchema>';
			
			str += '<pointSymStyles>';
			for each(var pStyle:PointSymbolStyle in pointSymStyles) {
				str += pStyle.getXML().toXMLString();
			}
			str += '</pointSymStyles>';
			
			str += '<lineSymStyles>';
			for each(var lStyle:LineSymbolStyle in lineSymStyles){
				str += lStyle.getXML().toXMLString();
			}
			str += '</lineSymStyles>';
			
			str += '<areaSymStyles>';
			for each(var aStyle:AreaSymbolStyle in areaSymStyles){
				str += aStyle.getXML().toXMLString();
			}
			str += '</areaSymStyles>';
			
			str += '</SymbolStyleSchema>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			lineSymStyles = new Dictionary();
			areaSymStyles = new Dictionary();
			pointSymStyles = new Dictionary();
			
			var strXMLList:XMLList = _xml.lineSymStyles.children();
			for each(var strXML:XML in strXMLList) {
				var lSymStyle:LineSymbolStyle = new LineSymbolStyle();
				lSymStyle.setXML(strXML);
				lineSymStyles[lSymStyle.name] = lSymStyle;
			}
			
			strXMLList = _xml.areaSymStyles.children();
			for each(strXML in strXMLList) {
				var aSymStyle:AreaSymbolStyle = new AreaSymbolStyle();
				aSymStyle.setXML(strXML, lineSymStyles);
				areaSymStyles[aSymStyle.name] = aSymStyle;
			}
			
			strXMLList = _xml.pointSymStyles.children();
			for each(strXML in strXMLList) {
				var pSymStyle:PointSymbolStyle = new PointSymbolStyle();
				pSymStyle.setXML(strXML, lineSymStyles);
				pointSymStyles[pSymStyle.name] = pSymStyle;
			}

		}
	}
}