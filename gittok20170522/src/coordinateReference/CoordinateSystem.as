package coordinateReference
{
	import mx.collections.ArrayList;
	
	public class CoordinateSystem
	{
		public var id:String;		// abreviation if exist, such as "(B, L)"
		public var name:String;		// name of the system such as "Geodetic Coordinate System"
		public var dimension:int;	// number of dimension such as 2
		public var axis:ArrayList;		// definition of axes. the type must be "Axis".
		public var ps:GaussKrugerProjection;
		
		public function CoordinateSystem()
		{
			axis = new ArrayList();
			ps = new GaussKrugerProjection();
		}
		
		public function getXML():XML {
			var str:String = '<CoordinateSystem id="' + this.id;
			str += '" name="' + this.name;
			str += '" dimension="' + this.dimension + '">';
			
			str += '<axis>';
			var m:int = this.axis.length;
			for (var i:int = 0; i < m; i++) {
				var ax:Axis = this.axis.getItemAt(i) as Axis;
				str += ax.getXML().toXMLString();
			}
			str += '</axis>';
			str += '<ps>';
			str += ps.getXML().toXMLString();
			str += '</ps>';
			str += '</CoordinateSystem>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.id = _xml.@id;
			this.name = _xml.@name;
			this.dimension = parseInt(_xml.@dimension);
			this.axis = new ArrayList();
			var axs:XMLList = _xml.axis.children();
			for each(var axXML:XML in axs) {
				var ax:Axis = new Axis();
				ax.setXML(axXML);
				this.axis.addItem(ax);
			}
			var psXMLList:XMLList = _xml.ps.GaussKrugerProjection;
			this.ps.setXML(psXMLList[0]);

		}
	}
}