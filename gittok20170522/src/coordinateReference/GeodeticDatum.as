package coordinateReference
{
	public class GeodeticDatum
	{
		public var id:String;		// abreviation if exist, such as "JGD2000"
		public var name:String;		// name of the geodetic datum such as "Japanese Geodetic Datum 2000"
		public var ellips:Ellipsoid;
		public var pm:PrimeMeridian;
		
		public function GeodeticDatum()
		{
			ellips = new Ellipsoid();
			pm = new PrimeMeridian();
		}
		
		public function getXML():XML {
			var str:String = '<GeodeticDatum id="' + this.id;
			str += '" name="' + this.name +'">';
			str += '<ellips>';
			str += ellips.getXML().toXMLString();
			str += '</ellips>';
			str += '<pm>';
			str += pm.getXML().toXMLString();
			str += '</pm>';
			str += '</GeodeticDatum>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.id = _xml.@id;
			this.name = _xml.@name;
			var ellXMLList:XMLList = _xml.ellips.Ellipsoid;
			this.ellips.setXML(ellXMLList[0]);
			var prmXMLList:XMLList = _xml.pm.PrimeMeridian;
			this.pm.setXML(prmXMLList[0]);
		}
	}
}