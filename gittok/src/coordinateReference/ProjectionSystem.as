package coordinateReference
{
	import dataTypes.spatialGeometry.Coordinate2;

	public class ProjectionSystem
	{
		public var name:String;
		public var scaleFactor:Number;
		public var origin:Coordinate2;		// This is a set of latitude and longitude, their unit is decimal degree
		
		public function ProjectionSystem()
		{
			origin = new Coordinate2();
		}
		
		public function getXML():XML {
			var str:String = '<ProjectionSystem name="' + this.name;
			str += '" scaleFactor="' + this.scaleFactor + '">';
			str += '<origin>';
			str += origin.getXML().toXMLString();
			str += '</origin>';
			str += '</ProjectionSystem>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.name = _xml.@name;
			this.scaleFactor = parseFloat(_xml.@scaleFactor);
			var orXMLList:XMLList = _xml.origin.children();
			this.origin.setXML(orXMLList[0]);
		}
	}
}