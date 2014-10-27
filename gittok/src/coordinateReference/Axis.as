package coordinateReference
{
	public class Axis
	{
		public var name:String;			// name of axis such as x and latitude.
		public var direction:String;	// direction such as vertical and north.
		public var uom:String;			// unit of measure such as m and degree
		
		public function Axis()
		{
			name = direction = uom = "";
		}
		
		public function getXML():XML {
			var str:String = '<Axis name="' + this.name;
			str += '" direction="' + this.direction; 
			str += '" uom="' + this.uom + '"/>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.name = _xml.@name.toString();
			this.direction = _xml.@direction.toString();
			this.uom = _xml.@uom.toString();
		}
	}
}