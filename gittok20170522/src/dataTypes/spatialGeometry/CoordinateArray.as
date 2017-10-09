package dataTypes.spatialGeometry
{
	
	import mx.collections.ArrayList;

	public class CoordinateArray extends ArrayList
	{
		/* 
		conctructor
		*/
		public function CoordinateArray()
		{
			super();
		}
		
		/*
		get and set of XML fragment
		*/
		public function getXML():XML {
			var m:int = this.length;
			if (m > 0) {
				var str:String = '<CoordinateArray element="';
				var crd:Coordinate2;
				for (var i:int = 0; i < m; i++) {
					crd = this.getItemAt(i) as Coordinate2;
					str += crd.x + ',' + crd.y + ',';
					
				}
				str = str.substr(0, str.length - 1) + '" ';
				str += 'dimension="2"/>';
				
				return XML(str);
			}
			return XML('<CordinateArray/>');
		}
		
		public function setXML(_xml:XML):void {
			this.removeAll();
			
			var str:String = _xml.@element.toString();
			
			var element:Array = str.split(',');
			var m:int = element.length / 2;
			for (var i:int = 0; i < m; i++) {
				var crd:Coordinate2 = new Coordinate2();
				crd.x = Number(element[i * 2]);
				crd.y = Number(element[i * 2 + 1]);
				this.addItem(crd);
			}
			
		}
	}
}