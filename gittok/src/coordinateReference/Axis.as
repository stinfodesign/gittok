package coordinateReference
{
	public class Axis
	{
		public var name:String;			// name of axis such as x and latitude.
		public var direction:String;	// direction such as vertical and north.
		public var uom:String;			// unit of measure such as m and degree
		public var offset:Number;		// false easting or northing, if required
		
		public function Axis()
		{
			name = direction = uom = "";
			offset = 0.0;
		}
		
		public function getXML():XML {
			var str:String = '<Axis name="' + this.name;
			str += '" direction="' + this.direction; 
			str += '" uom="' + this.uom;
			str += '" offset="' + this.offset + '"/>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.name = _xml.@name.toString();
			this.direction = _xml.@direction.toString();
			this.uom = _xml.@uom.toString();
			this.offset = _xml.@offset.toString();
		}
	}
}