package metadata
{
	import dataTypes.spatialGeometry.Coordinate2;

	public class GeographicExtent
	{
		
		public var lowerLeft:Coordinate2;
		public var upperRight:Coordinate2;
		
		public function GeographicExtent()
		{
			lowerLeft = new Coordinate2();
			upperRight = new Coordinate2();
		}
		
		public function getXML():XML {
			var str:String = '<GeographicExtent>'
			str += '<lowerLeft>'
			    + lowerLeft.getXML().toXMLString()
			    + '</lowerLeft>'
			    + '<upperRight>'
				+ upperRight.getXML().toXMLString()
				+ '</upperRight>'
				+ '</GeographicExtent>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			var llXMLList:XMLList = _xml.lowerLeft.children();
			this.lowerLeft.setXML(llXMLList[0]);
			var urXMLList:XMLList = _xml.upperRight.children();
			this.upperRight.setXML(urXMLList[0]);
		}
	}
}