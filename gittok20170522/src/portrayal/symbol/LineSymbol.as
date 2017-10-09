package portrayal.symbol
{
	import dataTypes.spatialGeometry.Coordinate2;
	import dataTypes.spatialGeometry.CoordinateArray;
	import dataTypes.spatialGeometry.SG_Curve;
	import dataTypes.spatialGeometry.SG_Point;
	
	import flash.display.Sprite;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;
	
	import portrayal.symbolStyle.LineSymbolStyle;
	
	public class LineSymbol extends Sprite
	{
		public var curve:SG_Curve = new SG_Curve();
		public var style:LineSymbolStyle = new LineSymbolStyle();
		
		public function LineSymbol() {
			super();
			
		}
		
		public function encode():Object {
			var lineObj:Object = new Object();
			lineObj.curve = curve;
			lineObj.style = style;
			return lineObj;
		}

		public function decode(lineObj:Object):void
		{
			curve = lineObj.curve;
			style = lineObj.style;
			
			var dash:Number = style.dash;
			var gap:Number = style.gap;
			
			//style definition
			graphics.lineStyle(style.thickness, 
				style.color, style.alpha, false, "normal", 
				style.caps, style.joints, 3);
			
			//draw polyline
			var ls:CoordinateArray = curve.coordinateSeqence();			
			var coord:Coordinate2;
			coord = ls.getItemAt(0) as Coordinate2;
			graphics.moveTo(coord.x, coord.y);
			for (var j:int = 1; j < ls.length; j++) {
				var coord2:Coordinate2 = ls.getItemAt(j) as Coordinate2;
				if (dash > 0 && gap > 0) 
					this.drawDashLine(coord, coord2, dash, gap);
				else {
					graphics.lineTo(coord2.x, coord2.y);
				}
				coord = coord2;
			}
			
			//name = curve.id.toString();	
		}
		
		private function drawDashLine(crd0:Coordinate2, crd1:Coordinate2, dashlen:Number, gaplen:Number):void {
			if (crd0.x == crd1.x && crd0.y == crd1.y) return;
			
			var incrlen:Number = dashlen + gaplen;
			var dx:Number = crd1.x - crd0.x;
			var dy:Number = crd1.y - crd0.y;
			var d:Number = Math.sqrt(dx*dx + dy*dy);
			
			if(incrlen > d) {
				graphics.moveTo(crd0.x, crd0.y);
				graphics.lineTo(crd1.x, crd1.y);
				return;
			}
			
			// A charm that the line start and end with dash!
			var m:Number = Math.floor(d/incrlen);
			var dd:Number = dashlen * (m + 1) + gaplen * m;
			var ddd:Number = (d - dd)/(2 * m + 1);
			dashlen += ddd;
			gaplen += ddd;
			incrlen = dashlen + gaplen;
			
			var steps:uint = d/incrlen;
			
			var dt:Number = dashlen/d;
			var it:Number = incrlen/d;
			
			var x:Number = crd0.x;
			var y:Number = crd0.y;
			graphics.moveTo(x, y);
			graphics.lineTo(x + dt * dx, y + dt * dy);
			for (var i:int = 0; i < steps; i++) {
				x = it * dx + x;
				y = it * dy + y;
				graphics.moveTo(x, y);
				graphics.lineTo(x + dt * dx, y + dt * dy);
			}
		}
		
		public function getXML():XML {
			var str:String = "<LineSymbol>";
			
			str += "<curve>";
			str += curve.getXML().toXMLString();
			str += "</curve>";
			
			str += "<style>";
			str += style.getXML().toXMLString();
			str += "</style>";
			
			str += "</LineSymbol>";
			
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit):void {
			var strXMLList:XMLList = _xml.curve.children();
			curve.setXML(strXMLList[0], kit);
			
			strXMLList = _xml.style.children();
			style.setXML(strXMLList[0]);
		}
		
		
	}
	

}