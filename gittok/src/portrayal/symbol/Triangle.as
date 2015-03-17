package portrayal.symbol
{
	import dataTypes.spatialGeometry.Coordinate2;
	import dataTypes.spatialGeometry.CoordinateArray;
	
	import flash.display.Sprite;
	
	public class Triangle extends Sprite
	{
		/*
		Triangle is used at Analyst page as from and to marks representing an association
		between different features.
		*/
		
		public function Triangle(_name:String, vertices:CoordinateArray, fillColor:uint)
		{
			super();
			
			graphics.lineStyle(3, fillColor, 0.8, false, "normal", "round", "round", 1);
			
			graphics.beginFill(fillColor);
			
			var crd0:Coordinate2 = vertices.getItemAt(0) as Coordinate2;
			graphics.moveTo(crd0.x, crd0.y);
			for (var i:int = 1; i < 3; i++) {
				var crd:Coordinate2 = vertices.getItemAt(i) as Coordinate2;
				graphics.lineTo(crd.x, crd.y);
			}
			graphics.lineTo(crd0.x, crd0.y);
			
			graphics.endFill();
			
			this.name = _name;
		}
	}
}