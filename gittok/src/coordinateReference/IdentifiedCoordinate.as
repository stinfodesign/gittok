package coordinateReference
{
	import dataTypes.spatialGeometry.Coordinate2;
	
	public class IdentifiedCoordinate extends Coordinate2
	{
		public var id:String;
		
		public function IdentifiedCoordinate()
		{
			super();
			id = "";
		}
		
		public override function getXML():XML {
			var str:String = '<IdentifiedCoordinate id="' + this.id + '">';
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			str += '</IdentifiedCoordinate>';
			
			return XML(str);
		}
		
		public override function setXML(_xml:XML):void {
			this.id = _xml.@id;
			var crdXMLList:XMLList = _xml.inheritance.children();
			super.setXML(crdXMLList[0]);
		}
	}
}