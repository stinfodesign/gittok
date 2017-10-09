package portrayal.symbolStyle
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class AreaSymbolStyle extends SymbolStyle
	{
		public var color:uint;
		public var alpha:Number;
		public var borderStyle:LineSymbolStyle;
		
		public function AreaSymbolStyle()
		{
			super();
		}
		
		public override function getXML():XML {
			var str:String 	= '<AreaSymbolStyle '
							+ 'color="' + this.color + '" alpha="' + this.alpha + '">';
			
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			
			str += '<borderStyle name="' + borderStyle.name.toString() + '"/>';
			
			str += '</AreaSymbolStyle>';
			
			return XML(str);
			
		}
		
		public override function setXML(_xml:XML, lStyleDic:Dictionary = null):void {
			this.color = _xml.@color.toString();
			this.alpha = _xml.@alpha.toString();
			
			var strXMLList:XMLList = _xml.inheritance.children();	
			super.setXML(strXMLList[0]);
						
			var borderName:String = _xml.borderStyle.@name.toString();
			this.borderStyle = lStyleDic[borderName] as LineSymbolStyle;			
		}

	}
}