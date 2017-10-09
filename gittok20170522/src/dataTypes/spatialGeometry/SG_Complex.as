package dataTypes.spatialGeometry
{
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;
	import mx.utils.UIDUtil;
	
	public class SG_Complex extends SG_Object
	{
		
		public var pointSet:ArrayList;
		public var curveSet:ArrayList;
		public var surfaceSet:ArrayList;
		
		public var orientableCurveSet:ArrayList;
		public var ringSet:ArrayList;
		
		public function SG_Complex()
		{
			super();
			
			pointSet   = new ArrayList();
			curveSet   = new ArrayList();
			surfaceSet = new ArrayList();
			
			orientableCurveSet = new ArrayList();
			ringSet = new ArrayList();
		}
		
		public override function getXML():XML {
			var str:String = '<SG_Complex>'
				+ '<inheritance>'
				+ super.getXML().toXMLString()
				+ '</inheritance>' 

			var m:int = this.pointSet.length;
			if (m > 0) {
				str += '<pointSet idref="';
				for (var i:int = 0; i < m; i++) {
					var p:SG_Point = this.pointSet.getItemAt(i) as SG_Point;
					str += p.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"/>';
			}

			m = this.curveSet.length;
			if (m > 0) {
				str += '<curveSet idref="';
				for (i = 0; i < m; i++) {
					var c:SG_Curve = this.curveSet.getItemAt(i) as SG_Curve;
					str += c.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"/>';
			}
			
			m = this.surfaceSet.length;
			if (m > 0) {
				str += '<surfaceSet idref="';
				for (i = 0; i < m; i++) {
					var s:SG_Surface = this.surfaceSet.getItemAt(i) as SG_Surface;
					if (s == null) trace("s is null");
					str += s.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"/>';
			}
			
			m = this.orientableCurveSet.length;
			if (m > 0) {
				str += '<orientableCurveSet idref="';
				for (i = 0; i < m; i++) {
					var oc:SG_OrientableCurve = this.orientableCurveSet.getItemAt(i) as SG_OrientableCurve;
					str += oc.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"/>';
			}
			
			m = this.ringSet.length;
			if (m > 0) {
				str += '<ringSet idref="';
				for (i = 0; i < m; i++) {
					var r:SG_Ring = this.ringSet.getItemAt(i) as SG_Ring;
					str += r.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"/>';
			}
			
			str += '</SG_Complex>';
			
			return XML(str);
		}
		
		public override function setXML(_xml:XML, kit:Kit = null):void {
			var strXMLList:XMLList = _xml.inheritance.children();
			var strXML:XML = strXMLList[0];
			
			super.setXML(strXML);
						
			var str:String = _xml.pointSet.@idref.toString();
			var pArray:Array = str.split(',');			
			var m:int = pArray.length;
			for (var i:int = 0; i < m; i++) {
				var p:SG_Point = kit.pointList[pArray[i]] as SG_Point;
				this.pointSet.addItem(p);
			}
			
			str = _xml.curveSet.@idref.toString();
			var cArray:Array = str.split(',');
			m = cArray.length;
			for (i = 0; i < m; i++) {
				var c:SG_Curve = kit.curveList[cArray[i]] as SG_Curve;
				this.curveSet.addItem(c);
			}
			
			str = _xml.surfaceSet.@idref.toString();
			if (str != "") {
				var sArray:Array = str.split(',');
				m = sArray.length;
				for (i = 0; i < m; i++) {
					var s:SG_Surface = kit.surfaceList[sArray[i]] as SG_Surface;
					this.surfaceSet.addItem(s);
				}
			}
			
			str = _xml.orientableCurveSet.@idref.toString();
			if (str != "") {
				var ocArray:Array = str.split(',');
				m = ocArray.length;
				for (i = 0; i < m; i++) {
					var oc:SG_OrientableCurve = kit.orientableCurveList[ocArray[i]] as SG_OrientableCurve;
					this.orientableCurveSet.addItem(oc);
				}
			}
			
			str = _xml.ringSet.@idref.toString();
			if (str != "") {
				var rArray:Array = str.split(',');
				m = rArray.length;
				for (i = 0; i < m; i++) {
					var r:SG_Ring = kit.ringList[rArray[i]] as SG_Ring;
					this.ringSet.addItem(r);
				}
			}
		}
		
	}
}