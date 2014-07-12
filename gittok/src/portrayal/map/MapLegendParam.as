package portrayal.map
{
	public class MapLegendParam
	{
		import dataTypes.spatialGeometry.Coordinate2;
		
		import mx.collections.ArrayList;
		
		public var title:String;
		public var elements:ArrayList;
		public var offset:Coordinate2;
		
		public function MapLegendParam()
		{
			elements = new ArrayList();
			offset = new Coordinate2();
		}
	}
}