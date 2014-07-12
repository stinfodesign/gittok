package portrayal.map
{
	import dataTypes.spatialGeometry.Coordinate2;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.collections.ArrayList;
	
	import spark.primitives.Rect;
	
	public class MapLegend extends Sprite
	{
		private var lineHeight:int = 20;
		private var lines:int = 0;
		private var tFormat:TextFormat = new TextFormat();
		
		public var param:MapLegendParam;
		
		public function MapLegend():void
		{
			super();
			param = new MapLegendParam();
		}
		
		public function setTitle(_title:String):void {
			param.title = _title;
			
			tFormat.font = "Arial";
			tFormat.size = 11;
			
			if (param.title != null) {
				var titleField:TextField = new TextField();
				titleField.text = param.title;
				titleField.setTextFormat(tFormat);
				titleField.autoSize = TextFieldAutoSize.LEFT;
				this.addChild(titleField);
				lines++;
			}			
		}
				
		public function setLegend():void {
			this.setTitle(param.title);
			
			var els:ArrayList = param.elements;
			for (var i:int = 0; i < els.length; i++) {
				var element:Object = els.getItemAt(i) as Object;
				this.addLine(element.color, element.alpha, element.text);
			}
		}
		
		public function addLine(color:uint, alpha:Number, text:String):Object {
			var element:Object = new Object();
			element.color = color;
			element.alpha = alpha;
			element.text  = text;
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawRect(0, lines * lineHeight, 15, 15);
			shape.graphics.endFill();
			this.addChild(shape);
			
			var lineField:TextField = new TextField();
			lineField.text = text;
			lineField.setTextFormat(tFormat);
			lineField.x = 18;
			lineField.y = lines * lineHeight;
			lineField.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(lineField);
			lines++;
			
			return element;
		}
	}
}