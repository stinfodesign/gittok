package portrayal.label
{
	import dataTypes.spatialGeometry.Coordinate2;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import portrayal.labelStyle.LabelStyle;
	
	public class Label extends Sprite
	{
		public var text:String;
		public var refPos:Coordinate2;
		public var style:LabelStyle;
		
		public function Label():void {
			super();
			
		}
		
		public function encode():Object {
			var outLabel:Object = new Object();
			outLabel.text   = text;
			outLabel.refPos = refPos;
			outLabel.style  = style;
			return outLabel;
		}
		
		public function decode(labelObj:Object):void {
			
			var lbl:TextField = new TextField();
			
			text     = labelObj.text;
			refPos   = labelObj.refPos;
			style    = labelObj.style;
			
			lbl.text = labelObj.text;
			
			var format:TextFormat = new TextFormat();
			with (format) {
				font = style.font;
				size = style.fontSize;
				color = style.color;
				bold = style.bold;
			}
			lbl.setTextFormat(format);
			
			lbl.alpha = style.alpla;
			
			var shiftx:Number = lbl.textWidth * (style.reference % 3) * 0.5;
			var shifty:Number = lbl.textHeight * (style.reference / 3) * 0.5;
			
			with (lbl) {
				x = refPos.x - shiftx;
				y = refPos.y - shifty;
				autoSize = TextFieldAutoSize.LEFT;
			}
			
			if (this.numChildren > 0) this.removeChildAt(0);
			this.addChild(lbl);
		}
	}
}