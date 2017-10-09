package coordinateReference
{
	import dataTypes.spatialGeometry.Coordinate2;
	
	import flash.utils.Dictionary;

	public class IdentifiedCoordinateDic
	{
		public var elements:Dictionary;
		
		public function IdentifiedCoordinateDic()
		{
			elements = new Dictionary();
		}
		
		/*
		get and set of XML fragment
		*/
		public function getXML():XML {
			var str:String = '<IdentifiedCoordinateDic element="';
			var str2:String = "";
			var icrd:IdentifiedCoordinate;
			for each (icrd in elements) {
				str2 += icrd.id + ','
				str2 += icrd.x + ',';
				str2 += icrd.y + ',';
			}
			if (str2.length > 0) {
				str2 = str2.substr(0, str.length - 1) + '" ';
				str2 += 'dimension="2"/>';
				str += str2;
				return XML(str);
			}
			return XML('<IdentifiedCordinateDic/>');
		}
		
		public function setXML(_xml:XML):void {
			var str:String = _xml.@element.toString();
			var dim:int = int(_xml.@dimension);
			
			var element:Array = str.split(',');
			var m:int = element.length / (dim + 1);
			for (var i:int = 0; i < m; i++) {
				var icrd:IdentifiedCoordinate = new IdentifiedCoordinate();
				icrd.id = element[i * (dim + 1)];
				icrd.x = Number(element[i * (dim + 1) + 1]);
				icrd.y = Number(element[i * (dim + 1) + 2]);
				elements[icrd.id] = icrd;
			}
			
		}
		
	}
}