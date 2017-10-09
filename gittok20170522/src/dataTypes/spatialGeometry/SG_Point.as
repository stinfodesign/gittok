package dataTypes.spatialGeometry
{
	
	import flash.utils.Dictionary;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;
	
	public class SG_Point extends SG_Primitive
	{
		public var position:Coordinate2;
		
		public var getIn:ArrayList;		// array of get-in curves
		public var goOut:ArrayList;		// array of go-out curves
		
		public function SG_Point()
		{
			super();
			position = new Coordinate2();
			getIn = new ArrayList();
			goOut = new ArrayList();
		}	
		
		public override function getXML():XML {
			// Header
			var str:String = '<SG_Point>';
			
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			
			// Position
			str += '<position>'
			str += position.getXML().toXMLString();
			str += '</position>';
			
			// getIn
			str += '<getIn';
			var m:int = getIn.length;
			var cv:SG_Curve;
			if (m > 0) {
				str += ' idref="';
				for (var i:int = 0; i < m; i++) {
					cv = getIn.getItemAt(i) as SG_Curve;
					str += cv.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"';
			}
			str += '/>';
			
			//goOut
			str += '<goOut';
			m = goOut.length;
			if (m > 0) {
				str += ' idref="';
				for (i = 0; i < m; i++) {
					cv = goOut.getItemAt(i) as SG_Curve;
					str += cv.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"';
			}
			str += '/>';
			
			// End tag
			str += "</SG_Point>";
			
			return XML(str);			
		}
		
		public override function setXML(_xml:XML, kit:Kit = null):void {
			
			var strXMLList:XMLList = _xml.inheritance.children();
			var strXML:XML = strXMLList[0];
			
			super.setXML(strXML);
			
			var pos:XMLList = _xml.position.children();
			this.position.setXML(pos[0]);
			
			
		}

	}
}