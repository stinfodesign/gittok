package coordinateReference
{
	import dataTypes.spatialGeometry.Coordinate2;

	public class GaussKrugerProjection
	{
		public var scaleFactor:Number;
		public var origin:Coordinate2;		// This is a set of latitude and longitude, their unit is decimal degree
		public var falseEasting:Number;
		public var falseNorthing:Number;
		
		public function GaussKrugerProjection()
		{
			origin = new Coordinate2();
		}
		
		public function getXML():XML {
			var str:String = '<GaussKrugerProjection';
			str += ' scaleFactor="' + this.scaleFactor;
			str += '" falseEasting="' + this.falseEasting;
			str += '" falseNorthing="' + this.falseNorthing + '">';
			str += '<origin>';
			str += origin.getXML().toXMLString();
			str += '</origin>';
			str += '</GaussKrugerProjection>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.scaleFactor   = parseFloat(_xml.@scaleFactor);
			this.falseEasting  = parseFloat(_xml.@falseEasting);
			this.falseNorthing = parseFloat(_xml.@falseNorthing);
			var orXMLList:XMLList = _xml.origin.children();
			this.origin.setXML(orXMLList[0]);
		}
	}
}