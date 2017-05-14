package dataTypes.spatialGeometry
{
	
	
	import flash.utils.Dictionary;
	
	import instanceModel.Kit;
	
	import math.Angle;
	
	import mx.collections.ArrayList;
	import mx.utils.UIDUtil;

	public class SG_Ring
	{
		public var id:String;
		public var elements:ArrayList;   // A sequence of orientable curves 
		
		public function SG_Ring()
		{
			this.id = UIDUtil.createUID();
			elements = new ArrayList();
		}
		
		public function coordinateSequence():CoordinateArray {
			var coords:CoordinateArray = new CoordinateArray();
			var n:int;
			var cr:Coordinate2;
			var oc:SG_OrientableCurve;
			for (var i:int = 0; i < elements.length; i++) {
				oc = elements.getItemAt(i) as SG_OrientableCurve;
				var cs:ArrayList = oc.coordinateSequence();
				n = cs.length;
				cr = cs.getItemAt(n - 1) as Coordinate2;
				cs.removeItemAt(n - 1);
				coords.addAll(cs);
			}
			coords.addItem(cr);		//close the ring
			
			return coords;
		}
		
		public function sumOfExternalAngles():Number {
			var crds:ArrayList = coordinateSequence();
			var crd:Coordinate2 = crds.getItemAt(1) as Coordinate2;
			crds.addItem(crd);
			var n:int = crds.length;
			var sum:Number = 0;
			for (var i:int = 0; i < (n - 2); i++) {
				var c0:Coordinate2 = crds.getItemAt(i)     as Coordinate2;
				var c1:Coordinate2 = crds.getItemAt(i + 1) as Coordinate2;
				var c2:Coordinate2 = crds.getItemAt(i + 2) as Coordinate2;
				var bearing:Number = math.Angle.bearing(c0, c1, c2);
				sum += bearing;
			}
			return sum;
		}
		
		public function rotation():Boolean {
			var crds:ArrayList = coordinateSequence();
			var n:int = crds.length - 1;
			var sum:Number = (n + 2) * Math.PI;
			if (Math.abs(sum - sumOfExternalAngles()) < 0.001) return true;		// anti-clockwise
			return false;		// clockwise
		}
		
		public function getXML():XML {
			var str:String = '<SG_Ring id="' + this.id + '">';

			var m:int = this.elements.length;
			var oc:SG_OrientableCurve;
			str += '<elements idref="';
			for (var i:int = 0; i < m; i++) {
				oc = this.elements.getItemAt(i) as SG_OrientableCurve;
				str += oc.id + ',';
			}
			str = str.substr(0, str.length - 1) + '"/>';
			
			str += '</SG_Ring>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit = null):void {
			var orientableCurveList:Dictionary = kit.orientableCurveList;
						
			this.id = _xml.@id;
			
			var str:String = _xml.elements.@idref.toString();
			var ocArray:Array = str.split(',');
			var m:int = ocArray.length;
			for (var i:int = 0; i < m; i++) {
				var oc:SG_OrientableCurve = orientableCurveList[ocArray[i]] as SG_OrientableCurve;
				this.elements.addItem(oc);
			}
		}
	}
}