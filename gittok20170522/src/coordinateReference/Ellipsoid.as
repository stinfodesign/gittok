package coordinateReference
{
	public class Ellipsoid
	{
		public var name:String;					// name of the reference ellipsoid such as GRS80 and WGS84 
		public var semiMajorAxis:Number;		// the length of semi major axis such as 6378137.
		public var inverseFlattening:Number; 	// invers flattening sych as 298.257222101
		
		public function Ellipsoid()
		{
		}
		
		public function getXML():XML {
			var str:String = '<Ellipsoid name="' + this.name;
			str += '" semiMajorAxis="' + this.semiMajorAxis;
			str += '" inverseFlattening="' + this.inverseFlattening + '"/>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.name = _xml.@name.toString();
			this.semiMajorAxis = parseFloat(_xml.@semiMajorAxis);
			this.inverseFlattening = parseFloat(_xml.@inverseFlattening);
		}
	}
}