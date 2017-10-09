package portrayal.symbolStyle
{
	import dataTypes.place.ImageURL;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.controls.Image;
	
	public class AreaSymbolStyle extends SymbolStyle
	{
		public var color:uint;
		public var alpha:Number;
		public var fillStyle:Boolean;
		public var url:String;
		public var borderStyle:LineSymbolStyle;
		
		public function AreaSymbolStyle()
		{
			super();
		}
		
		public override function getXML():XML {
			var str:String 	= '<AreaSymbolStyle '
							+ 'fillStyle="' + this.fillStyle
							+ '" color="' + this.color + '" alpha="' + this.alpha 
							+ '" url="' + this.url + '">';
			
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			if (borderStyle != null) {
				str += '<borderStyle name="' + borderStyle.name.toString() + '"/>';
			}
			else {
				str += '<borderStyle name="" />';
			}
			
			str += '</AreaSymbolStyle>';
			
			return XML(str);
			
		}
		
		public override function setXML(_xml:XML, lStyleDic:Dictionary = null):void {
			if (_xml == null) return;
			
			var strXMLList:XMLList = _xml.inheritance.children();			
			super.setXML(strXMLList[0]);
			var borderName:String = _xml.borderStyle.@name.toString();
			this.borderStyle = lStyleDic[borderName] as LineSymbolStyle;

			var tf:String = _xml.@fillStyle.toString();
			if(tf == "true") {
				this.fillStyle = true;
				this.color = _xml.@color.toString();
				this.alpha = _xml.@alpha.toString();
			}
			else {
				this.fillStyle = false;
				this.url = _xml.@url.toString();		
			}
		}
	}
}