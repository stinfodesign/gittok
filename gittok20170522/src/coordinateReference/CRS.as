package coordinateReference
{
	public class CRS
	{
		public var id:String;			// id for the reference such as "JGD2000 / (B, L)"
		public var datum:GeodeticDatum;
		public var cs:CoordinateSystem;	
		public var vDatum:VerticalDatum;
		
		public function CRS()
		{
			datum = new GeodeticDatum();
			cs = new CoordinateSystem();
			vDatum = new VerticalDatum();
		}
		
		public function getXML():XML {
			var str:String = '<?xml version=“1.1” encoding="UTF-8"?>';

			str += '<CRS id="' + this.id + '">';
			str += '<datum>'
			str += datum.getXML().toXMLString();
			str += '</datum>';
			str += '<vDatum>';
			str += vDatum.getXML().toXMLString();
			str += '</vDatum>';
			str += '<cs>';
			str += cs.getXML().toXMLString();
			str += '</cs>';
			str += '</CRS>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.id = _xml.@id;
			var daXMLList:XMLList = _xml.datum.GeodeticDatum;
			this.datum.setXML(daXMLList[0]);
			var csXMLList:XMLList = _xml.cs.CoordinateSystem;
			this.cs.setXML(csXMLList[0]);
			var vdXMLList:XMLList = _xml.vDatum.VerticalDatum;
			this.vDatum.setXML(vdXMLList[0]);
		}
	}
}