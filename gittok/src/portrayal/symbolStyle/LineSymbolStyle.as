package portrayal.symbolStyle
{
	import flash.utils.Dictionary;
	
	public class LineSymbolStyle extends SymbolStyle
	{
		public var color:uint;				//For example, 0xffffff means white
		public var thickness:Number;		//Default unit is pixel
		public var alpha:Number;			//0 to 1
		public var caps:String;				//none	round	square	default is round
		public var joints:String;			//bevel miter round default is round
		public var dash:Number;				//dash length
		public var gap:Number;				//gap length
		
		public function LineSymbolStyle() {
			super();
			color = 0x000000;
			thickness = 1;
			alpha = 1;
			caps = "round";
			joints = "round";
			dash = -1;						// real line
			gap = -1;
		}
		
		public override function getXML():XML {
			var str:String 	= '<LineSymbolStyle '
							+ 'color="' + this.color + '" '
							+ 'thickness="' + this.thickness + '" '
							+ 'alpha="' + this.alpha + '" '
							+ 'caps="' + this.caps + '" '
							+ 'joints="' + this.joints + '" '
							+ 'dash="' + this.dash + '" '
							+ 'gap="' + this.gap + '">';
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			str += '</LineSymbolStyle>';
			
			return XML(str);
		}
		
		public override function setXML(_xml:XML, lStyleDic:Dictionary = null):void {
			
			this.color = uint(_xml.@color);
			this.thickness = Number(_xml.@thickness);
			this.alpha = Number(_xml.@alpha);
			this.caps = _xml.@caps;
			this.joints = _xml.@joints;
			
			this.dash = Number(_xml.@dash);
			this.gap = Number(_xml.@gap);
			var strXMLList:XMLList = _xml.inheritance.children();
			var strXML:XML = strXMLList[0];
			this.name = strXML.@name;
			this.id = strXML.@id;
		}
	}
}