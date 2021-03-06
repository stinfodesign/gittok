package portrayal.labelStyle
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;

	public class LabelStyleDictionary
	{
		public var name:String;
		public var labelStyles:Dictionary;
		
		public function LabelStyleDictionary()
		{
			labelStyles = new Dictionary();
		}
		
		public function getXML():XML {
			var str:String = '<?xml version=“1.1” encoding="UTF-8"?>';
			
			str += '<LabelStyleDictionary name="';
			str += this.name + '">';
			str += '<labelStyles>';
			
			for each(var lblStyle:LabelStyle in labelStyles) {
				str += lblStyle.getXML().toXMLString();
			}
			str += '</labelStyles>';
			str += '</LabelStyleDictionary>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			labelStyles = new Dictionary();
			
			this.name = _xml.@name;
			
			var strXMLList:XMLList = _xml.labelStyles.children();
			for each(var strXML:XML in strXMLList) {
				var lblStyle:LabelStyle = new LabelStyle();
				lblStyle.setXML(strXML);
				labelStyles[lblStyle.name] = lblStyle;
			}

		}
	}
}