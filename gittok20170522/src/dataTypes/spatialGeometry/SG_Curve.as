package dataTypes.spatialGeometry
{
	
	import flash.utils.Dictionary;
	
	import instanceModel.Kit;
	
	import math.Distance;
	
	import mx.collections.ArrayList;
	
	public class SG_Curve extends SG_Primitive
	{
		public var start:SG_Point;
		public var end:SG_Point;
		
		public var shape:CoordinateArray;		// sequence of coordinates
		
		public var left:SG_Surface;
		public var right:SG_Surface;
		
		public var extend:ArrayList;
		
		public function SG_Curve()
		{
			super();
			shape = new CoordinateArray();
			extend = new ArrayList();
		}
		
		public function coordinateSeqence():CoordinateArray {
			var cSeq:CoordinateArray = new CoordinateArray();
			cSeq.addItem(start.position);
			cSeq.addAll(shape);
			cSeq.addItem(end.position);
			return cSeq;
		}
		
		public override function getXML():XML {
			var str:String = '<SG_Curve>';
			
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			
			str += '<start idref="' + this.start.id + '"/>';
			str += '<end idref="' +this.end.id + '"/>';
						
			// Shape
			str += '<shape>';
			str += this.shape.getXML().toXMLString();
			str += '</shape>';
			
			// Left and right surfaces
			if (this.left != null) {
				str += '<left idref="' + this.left.id + '"/>';
			}
			if (this.right != null) {
				str += '<right idref="' + this.right.id + '"/>';
			}
			
			// Extends to SG_OrientableCurve
			str += '<extend';
			var m:int = this.extend.length;
			if (m > 0) {
				str += ' idref="';
				for (var i:int = 0; i < m;i++) {
					var oc:SG_OrientableCurve = this.extend.getItemAt(i) as SG_OrientableCurve;
					str += oc.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"';
			}
			str += '/>';

			// End tag
			str += '</SG_Curve>';
			
			return XML(str);
		}
		
		public override function setXML(_xml:XML, kit:Kit = null):void {
			var pList:Dictionary = kit.pointList;
			
			var parentXMLList:XMLList = _xml.inheritance.children();
			super.setXML(parentXMLList[0]);
			
			this.start = pList[_xml.start.@idref.toString()] as SG_Point;
			this.end   = pList[_xml.end.@idref.toString()] as SG_Point;
			
			var sList:Dictionary = kit.surfaceList;
			
			this.left  = sList[_xml.left.@idref.toString()]  as SG_Surface;
			this.right = sList[_xml.right.@idref.toString()] as SG_Surface;
			
			this.start.goOut.addItem(this);
			this.end.getIn.addItem(this);
			
			// shape
			var crdXMLList:XMLList = _xml.shape.children();
			this.shape.setXML(crdXMLList[0]);
			
			// SetXML of the orientable curve will add "extend".

		}
	}
}