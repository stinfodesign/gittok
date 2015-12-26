package locationReference
{
	import dataTypes.spatialGeometry.Coordinate2;

	public class LocationInstance
	{
		public var geoName:String;
		public var position:Coordinate2;
		
		public function LocationInstance()
		{
		
		}
		
		public function getXML():XML {
			var str:String = '<LocationInstance ';
			str += 'geoName="' + this.geoName + '">';
			str += '<position>';
			str += position.getXML().toXMLString();
			str += '</position>';
			str += '</LocationInstance>';
			return XML(str);			
		}
		
		public function setXML(_xml:XML):void {
			this.geoName = _xml.@geoName.toString();
			
			var crd:Coordinate2 = new Coordinate2();
			var posXMLList:XMLList = _xml.position.children();
			crd.setXML(posXMLList[0]);
			this.position = crd;
		}
	}
}