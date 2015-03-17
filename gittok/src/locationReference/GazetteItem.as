package locationReference
{
	import dataTypes.spatialGeometry.Coordinate2;

	public class GazetteItem
	{
		public var geoName:String;
		public var position:Coordinate2;
		
		public function GazetteItem()
		{
		
		}
		
		public function getXML():XML {
			var str:String = '<GazetteerItem ';
			str += 'geoName="' + this.geoName + '">';
			str += '<position>';
			str += position.getXML().toXMLString();
			str += '</position>';
			str += '</GazetteerItem>';
			return XML(str);			
		}
		
		public function setXML(_xml:XML):void {
			this.geoName = _xml.@geoName.toString();
			
			var crd:Coordinate2 = new Coordinate2();
			crd.setXML(_xml.@position);
			this.position = crd;
		}
	}
}