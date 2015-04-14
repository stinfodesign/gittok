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
			Get and draw a bar-scale
			*/
			
			// Get a size on the ground (gSize) that is equivalent to 200 pixels on the scaled screen. 
			var coor0:Coordinate2 = new Coordinate2();
			coor0.x = 0;
			coor0.y = 0;
			coor0 = math.Affine.conversion(coor0, affineParam.coefficient);
			
			var coor1:Coordinate2 = new Coordinate2();
			coor1.x = 200 / scaleValue;		//This division is important.
			coor1.y = 0;
			coor1 = math.Affine.conversion(coor1, affineParam.coefficient);
			
			var gSize:Number = coor1.y - coor0.y;  // y is horizontal on the plane ground
			
			// Get a round figure of gSize
			var digit:int = int(Math.log(gSize) * Math.LOG10E);
			var hDigit:int = int(gSize / Math.pow(10, digit)); // number of the highest digit

			gSize = hDigit * Math.pow(10, digit);
			
			// Get a size of the bar-scale  (scaleSize)
			coor1.x = 0 + coor0.x;
			coor1.y = gSize + coor0.y;
			coor1 = math.Affine.inverseConversion(coor1, affineParam.coefficient);
			
			var scaleSize:Number = coor1.x * scaleValue;
			
			// Draw the bar-scale
			this.graphics.lineStyle(1.0, 0, 0.7);
			this.graphics.moveTo(50, 460);
			this.graphics.lineTo(50 + scaleSize, 460);
			this.graphics.lineTo(50 + scaleSize, 455);
			var dx:Number = scaleSize / hDigit;
			for (var i:int = 0; i < hDigit * 10; i++) {
				var xDash:Number = i * dx / 10.0;
				this.graphics.moveTo(50 + xDash, 460);
				if (i % 2 == 0) 
					this.graphics.lineTo(50 + xDash, 458);				
				if (i % 10 == 0) 
					this.graphics.lineTo(50 + xDash, 455);
			}

			// Get and draw a label on the scale
			var svalue:int = int(gSize + 0.5);
			var valueText:String;
			valueText = "" + svalue + "m";
			if (svalue >= 1000) {
				svalue /= 1000;
				valueText = "" + svalue + "km";
			}			
			
			var scalePos:Coordinate2 = new Coordinate2();
			scalePos.x = 25;
			scalePos.y = 462;
			
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