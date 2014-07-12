package portrayal.symbol
{
	import dataTypes.spatialGeometry.Coordinate2;
	
	import flash.display.Sprite;
	
	public class Cross extends Sprite
	{
		public var center:Coordinate2;
		public var size:Number;
		public var color:uint;
		
		public function Cross(_crd:Coordinate2, _size:Number, _color:uint = 0x000000)
		{
			super();
			center = _crd;
			size = _size;
			color = _color;
			
			var p0:Coordinate2 = new Coordinate2();
			var p1:Coordinate2 = new Coordinate2();
			
			p0.x = center.x - size * 0.5;
			p0.y = center.y - size * 0.5;
			p1.x = center.x + size * 0.5;
			p1.y = center.y + size * 0.5;
			
			this.graphics.lineStyle(1,color);
			this.graphics.moveTo(p0.x, center.y);
			this.graphics.lineTo(p1.x, center.y);
			this.graphics.moveTo(center.x, p0.y);
			this.graphics.lineTo(center.x, p1.y);
			
			this.name = "cross";
		}
		
		
		
		
	}
}