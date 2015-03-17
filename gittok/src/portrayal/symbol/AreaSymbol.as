package portrayal.symbol
{
	import dataTypes.spatialGeometry.*;
	
	import flash.display.Sprite;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;
	
	import portrayal.symbolStyle.AreaSymbolStyle;
	import portrayal.symbolStyle.LineSymbolStyle;

	public class AreaSymbol extends Sprite
	{
		public var surface:SG_Surface = new SG_Surface();
		private var style:AreaSymbolStyle = new AreaSymbolStyle();
		
		public function AreaSymbol() {
			super();
		}
		
		public function decode(areaObj:Object):void
		{
			surface = areaObj.surface;
			style = areaObj.style;
			
			graphics.beginFill(style.color, style.alpha);
						
			var coords:CoordinateArray = surface.exterior.coordinateSequence();
			this.decodeSurface(coords);
			
			for (var i:int = 0; i < surface.interior.length; i++) {
				var ring:SG_Ring = surface.interior.getItemAt(i) as SG_Ring;
				coords = ring.coordinateSequence();
				this.decodeSurface(coords);
			}
			graphics.endFill();
			
			if (style.borderStyle != null) {
				this.decodeRing(surface.exterior);
			
				for (i = 0; i < surface.interior.length; i++) {
					this.decodeRing(surface.interior.getItemAt(i) as SG_Ring);
				}
			}
		}
		
		protected function decodeSurface(coords:CoordinateArray):void {
			var coord:Coordinate2 = coords.getItemAt(0) as Coordinate2;
			graphics.moveTo(coord.x, coord.y);
			for (var j:int = 1; j < coords.length; j++) {
				coord = coords.getItemAt(j) as Coordinate2;
				graphics.lineTo(coord.x, coord.y);
			}			
		}
		
		protected function decodeRing(r:SG_Ring):void {
			var coords:CoordinateArray = r.coordinateSequence();
			
			var c:SG_Curve = new SG_Curve();
			var start:SG_Point = new SG_Point();
			var end:SG_Point   = new SG_Point();
			
			start.position = coords.getItemAt(0) as Coordinate2;
			var n:int      = coords.length - 1;
			end.position   = coords.getItemAt(n) as Coordinate2;
			c.start = start;
			c.end   = end;
			c.shape = coords as CoordinateArray;
			
			var lSym:LineSymbol = new LineSymbol();
			var lineObj:Object = new Object();
			lineObj.curve = c;
			lineObj.style = style.borderStyle;
			lSym.decode(lineObj);
			addChild(lSym);			
		}
		
		public function getXML():XML {
			var str:String = "<AreaSymbol>";
			str += "<surface>";
			str += surface.getXML().toXMLString();
			str += "</surface>";
			
			str += "<style>";
			str += style.getXML().toXMLString();
			str += "</style>";
			
			str += "</AreaSymbol>";
			
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit):void {
			var strXMLList:XMLList = _xml.surface.children();
			surface.setXML(strXMLList[0], kit);
			
			strXMLList = _xml.style.children();
			style.setXML(strXMLList[0]);
		}
		
		public function encode():Object {
			var areaObj:Object = new Object();
			areaObj.surface = surface;
			areaObj.style   = style;
			return areaObj;
		}
		
	} 
}