package portrayal.map
{
	import dataTypes.spatialGeometry.Coordinate2;
	
	import mx.collections.ArrayList;

	public class Map
	{
		// drawing space
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var scale:Number;
		
		// symbol space
		public var symbolArray:ArrayList;
		
		// label space
		public var labelArray:ArrayList;
		
		// marginal space
		public var title:Title;
		public var subtitle:Title;
		public var northArrow:NorthArrow;
		public var legendParam:MapLegendParam;
		public var barScale:Object;		
		// The term "barScale" is attached by quotation from "Elements of Carography Sixth Edition" p.92
		
		public function Map()
		{
			barScale    = new Object();
		}
	}
}