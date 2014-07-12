package portrayal.symbol
{
	import dataTypes.spatialGeometry.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import portrayal.symbolStyle.AreaSymbolStyle;
	import portrayal.symbolStyle.LineSymbolStyle;
	
	public class Circle extends Sprite
	{
		public var center:Coordinate2;
		public var radius:Number;
		public var aStyle:AreaSymbolStyle;
		
		public function Circle(_crd:Coordinate2, _radius:Number, 
							   _aStyle:AreaSymbolStyle = null)
		{
			super();
			
			center = _crd;
			radius = _radius;
			aStyle = _aStyle;
			
			// dashed line is not allowed.
			if (aStyle == null) {
				graphics.lineStyle(3.0, 0xFF0000, 100, false, "normal", 
					"round", "round", 3);
				aStyle = new AreaSymbolStyle();
				aStyle.color = 0xffffff;
				aStyle.alpha = 0;
			}
			else {
				var lStyle:LineSymbolStyle = aStyle.borderStyle;
				graphics.lineStyle(lStyle.thickness, 
					lStyle.color, lStyle.alpha, false, "normal", 
					lStyle.caps, lStyle.joints, 3);
				
			}
			graphics.beginFill(aStyle.color, aStyle.alpha);
			graphics.drawCircle(center.x, center.y, radius);
			graphics.endFill();
			
			this.name = "circle";

		}
	}
}