package portrayal.symbol
{
	import dataTypes.spatialGeometry.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import portrayal.symbolStyle.CircleSymbolStyle;
	import portrayal.symbolStyle.LineSymbolStyle;
	
	public class Circle extends Sprite
	{
		public var center:Coordinate2;
		public var radius:Number;
		public var style:CircleSymbolStyle;
		
		public function Circle(_crd:Coordinate2, _radius:Number, 
							   _style:CircleSymbolStyle = null)
		{
			super();
			
			center = _crd;
			radius = _radius;
			style = _style;
			
			// dashed line is not allowed.
			if (style == null) {
				graphics.lineStyle(5.0, 0xFF0000, 100, false, "normal", 
					"round", "round", 3);
				style = new CircleSymbolStyle();
				style.color = 0xffffff;
				style.alpha = 0;
				style.borderStyle = new LineSymbolStyle();
				style.borderStyle.color = 0xff0000;
				style.borderStyle.alpha = 100;
				style.borderStyle.thickness = 5;
			}
			else {
				var lStyle:LineSymbolStyle = style.borderStyle;
				graphics.lineStyle(lStyle.thickness, 
					lStyle.color, lStyle.alpha, false, "normal", 
					lStyle.caps, lStyle.joints, 3);
				
			}
			graphics.beginFill(style.color, style.alpha);
			graphics.drawCircle(center.x, center.y, radius);
			graphics.endFill();
			
			this.name = "circle";

		}
	}
}