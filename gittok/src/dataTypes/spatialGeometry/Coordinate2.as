package dataTypes.spatialGeometry
{
	public class Coordinate2
	{
		public var x:Number;
		public var y:Number;
		public var dimension:int;
		
		public function Coordinate2()
		{
			dimension = 2;
			x = y = 0.0;
		}
		
		public function getXML():XML {
			var str:String = '<Coordinate component="' + this.x + ',' + this.y;
			str += '" dimension="2"/>';
			// Dimension is required for exchange data with standardized format.
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			var str:String = _xml.@component.toString();
			var cpArray:Array = str.split(',');
			this.x = Number(cpArray[0]);
			this.y = Number(cpArray[1]);
			str = _xml.@dimension.toString();
			this.dimension = int(str);
		}
	}
}