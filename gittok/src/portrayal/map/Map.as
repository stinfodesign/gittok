package portrayal.map
{
	import dataTypes.spatialGeometry.Coordinate2;
	
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayList;
	
	import portrayal.portrayalStyle.PortrayalSchema;
	
	public class Map
	{
		// original data reference
		public var kitFileName:String;
		public var portrayalSchema:PortrayalSchema;
		
		// drawing space
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var scale:Number;
		
		public var backgroundColor:uint;
		public var backgroundColorAlpha:Number;
		
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