package portrayal.map
{
	import dataTypes.spatialGeometry.*;
	
	import flash.display.Sprite;
	
	import math.Affine;
	import math.AffineParam;
	
	import portrayal.label.Label;
	import portrayal.labelStyle.LabelStyle;
	
	public class BarScale extends Sprite
	{
		
		public function BarScale() {
			super();		
		}
		
		public function drawScale(affineParam:AffineParam, scaleValue:Number):void
		{
			/*
			Get and draw the map scale
			*/
			
			// Get a size on the ground (gSize) that is equivalent to 100 pixels on the screen. 
			var coor0:Coordinate2 = new Coordinate2();
			coor0.x = 0;
			coor0.y = 0;
			coor0 = math.Affine.conversion(coor0, affineParam.coefficient);
			
			var coor1:Coordinate2 = new Coordinate2();
			coor1.x = 100;
			coor1.y = 0;
			coor1 = math.Affine.conversion(coor1, affineParam.coefficient);
			
			var gSize:Number = coor1.y - coor0.y;  // y is horizontal on the plane ground
			
			// Get a round figure of gSize
			var digit:int = int(Math.log(gSize) * Math.LOG10E);
			gSize = int(gSize / Math.pow(10, digit) + 0.5); // number of the highest digit
			if (gSize < 4) gSize = 1;
			if (gSize >= 4 && gSize < 7) gSize = 5;
			if (gSize >= 7) gSize = 10;
			
			gSize = gSize * Math.pow(10, digit);
			
			// Get a size of the scale  (scaleSize) on the map
			coor1.x = 0 + coor0.x;
			coor1.y = gSize + coor0.y;
			coor1 = math.Affine.inverseConversion(coor1, affineParam.coefficient);
			
			var scaleSize:Number = coor1.x * scaleValue;
			
			// Draw a scale line
			this.graphics.lineStyle(1.0, 0, 0.7);
			this.graphics.moveTo(150, 455);
			this.graphics.lineTo(150, 460);
			this.graphics.lineTo(150 + scaleSize, 460);
			this.graphics.lineTo(150 + scaleSize, 455);

			// Get and draw a label on the scale
			var valueText:String = "" + int(gSize + 0.5) + "m";
			
			var scalePos:Coordinate2 = new Coordinate2();
			scalePos.x = 150 + scaleSize * 0.5;
			scalePos.y = 455;
			
			var scaleStyle:LabelStyle = new LabelStyle();
			with (scaleStyle) {
				font 		= "Arial";
				fontSize 	= 12;
				bold 		= false;
				color 		= 0;
				alpla 		= 1;
				reference 	= 7;
			}
			var scaleLabel:Label = new Label();
			var labelObj:Object  = new Object();
			
			labelObj.text   = valueText;
			labelObj.refPos = scalePos;
			labelObj.style  = scaleStyle;
			
			scaleLabel.decode(labelObj); 
			this.addChild(scaleLabel);
		}
	}
}