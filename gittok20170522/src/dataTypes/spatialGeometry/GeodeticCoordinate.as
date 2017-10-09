package dataTypes.spatialGeometry
{
	public class GeodeticCoordinate
	{
		public var lat:Number;		// latitude
		public var lon:Number;		// longitude
		public var num:int;			// number of the plane coordinate system
		public var gamma:Number;	// meridian convergence angle (= - true north bearing)
		public var m:Number;		// scaling factor
		
		public function GeodeticCoordinate()
		{
		}
	}
}