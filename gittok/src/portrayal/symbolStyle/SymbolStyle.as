package portrayal.symbolStyle
{
	import flash.utils.Dictionary;
	
	import mx.utils.UIDUtil;
	
	public class SymbolStyle
	{
		public var id:String
		public var name:String;
		
		public function SymbolStyle()
		{
			name = "";
			id = UIDUtil.createUID();
		}
		
		public function getXML():XML {
			var str:String 	= '<SymbolStyle name="' + this.name + '" '
							+ 'id="' + this.id + '"/>';
			return XML(str);
		}
		
		public function setXML(_xml:XML, lStyleDic:Dictionary = null):void {
			this.name = _xml.@name;
			this.id = _xml.@id;
		}
		
	}
}