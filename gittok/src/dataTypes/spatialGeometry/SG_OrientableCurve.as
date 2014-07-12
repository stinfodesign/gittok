package dataTypes.spatialGeometry
{
	import flash.utils.Dictionary;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;
	import mx.utils.UIDUtil;

	public class SG_OrientableCurve
	{
		public var id:String;
		public var orientation:Boolean;
		public var original:SG_Curve;		// An original SG_Curve
		
		public function SG_OrientableCurve()
		{
			this.id = UIDUtil.createUID();
			orientation = true;
		}
		
		public function coordinateSequence():ArrayList {
			var cs:ArrayList = original.coordinateSeqence();
			if (orientation) return cs;
			
			var n:int = cs.length;
			var cso:ArrayList = new ArrayList();
			
			for (var i:int = (n - 1); i >= 0; i--) {
				cso.addItem(cs.getItemAt(i));
			}
			return cso;
		}
		
		public function startPoint():SG_Point {
			if (orientation) return original.start;
			return original.end;
		}
		
		public function endPoint():SG_Point {
			if (orientation) return original.end;
			return original.start;
		}
		
		public function getXML():XML {
			var ori:String;
			if (orientation) ori = "true"; else ori = "false";
			var str:String = '<SG_OrientableCurve id="' + this.id + '" ';  
			str += 'orientation="' + ori + '">';
			str += '<original idref="' + this.original.id + '"/>';
			str += '</SG_OrientableCurve>';
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit = null):void {
			var curveList:Dictionary = kit.curveList;
			
			this.id = _xml.@id;
			
			var oriStr:String = _xml.@orientation;
			if (oriStr == "true") this.orientation = true;
			else this.orientation = false;
			var cid:String = _xml.original.@idref.toString();
			this.original = curveList[cid] as SG_Curve;
			
			// set extend
			this.original.extend.addItem(this);
		}
	}
}