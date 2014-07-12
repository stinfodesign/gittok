package portrayal.symbol
{
	import dataTypes.simpleDataTypes.*;
	import dataTypes.spatialGeometry.*;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import instanceModel.Kit;
	
	import math.Distance;
	
	import mx.collections.ArrayList;
	
	import portrayal.symbolStyle.*;
	
	
	public class PointSymbol extends Sprite
	{
		public var point:SG_Point = new SG_Point();
		private var style:PointSymbolStyle = new PointSymbolStyle();
		
		public function PointSymbol() {
			super();
			
		}
		
		public function encode():Object {
			var pointObj:Object = new Object();
			pointObj.point = point;
			pointObj.style = style;
			return pointObj;
		}

		public function decode(pointObj:Object):void
		{
			point = pointObj.point;
			style = pointObj.style;
			
			var styles:ArrayList   = style.styles;
			var elements:ArrayList = style.elements;
			var n:int = styles.length;
			var _x:Number = point.position.x;
			var _y:Number = point.position.y;
			
			for (var i:int = 0; i < n; i++) {
				var style:* = styles.getItemAt(i);

				if (style is LineSymbolStyle) {
					var lStyle:LineSymbolStyle = styles.getItemAt(i) as LineSymbolStyle; 
					graphics.lineStyle(lStyle.thickness, 
						lStyle.color, lStyle.alpha, false, "normal", 
						lStyle.caps, lStyle.joints, 3);
					graphics.endFill(); 
					
					var cString:CoordinateArray = elements.getItemAt(i) as CoordinateArray;
					
					var coord:Coordinate2;
					var m:int = cString.length;
					coord = cString.getItemAt(0) as Coordinate2;
					graphics.moveTo(coord.x, coord.y);
					for (var j:int = 1; j < m; j++) {
						coord = cString.getItemAt(j) as Coordinate2;
						graphics.lineTo(coord.x, coord.y);
					}

				}
				else {
					var aStyle:AreaSymbolStyle = styles.getItemAt(i) as AreaSymbolStyle;
					lStyle = aStyle.borderStyle;
					graphics.lineStyle(lStyle.thickness, 
						lStyle.color, lStyle.alpha, false, "normal", 
						lStyle.caps, lStyle.joints, 3);
										
					var element:* = elements.getItemAt(i);
					if (aStyle.isCircle) {
						var crds:CoordinateArray = element as CoordinateArray;
						var center:Coordinate2 = crds.getItemAt(0) as Coordinate2;
						var bcrd:Coordinate2 = crds.getItemAt(1) as Coordinate2;
						var radius:Number = math.Distance.p2p(center, bcrd);
						
						var bStyle:LineSymbolStyle = aStyle.borderStyle;
						graphics.lineStyle(bStyle.thickness, 
						bStyle.color, bStyle.alpha, false, "normal", 
						bStyle.caps, bStyle.joints, 3);
						graphics.beginFill(aStyle.color, aStyle.alpha);
						graphics.drawCircle(center.x, center.y, radius);
						graphics.endFill();
					}
					else {
						cString = element as CoordinateArray;
						
						m = cString.length;
						coord = cString.getItemAt(0) as Coordinate2;
						graphics.beginFill(aStyle.color, aStyle.alpha);
						graphics.moveTo(coord.x, coord.y);
						for (j = 1; j < m; j++) {
							coord = cString.getItemAt(j) as Coordinate2;
							graphics.lineTo(coord.x, coord.y);
						}
						graphics.endFill();
					}
				}
			} 
			var size:Number = style.size;
			
			this.scaleX = size / 200;
			this.scaleY = this.scaleX;
			this.x = _x - size * 0.5;
			this.y = _y - size * 0.5;
			
			this.name = point.id.toString();
		}
		
		public function getXML():XML {
			var str:String = "<PointSymbol>";
			
			str += "<point>";
			str += point.getXML().toXMLString();
			str += "</point>";
			
			str += "<style>";
			str += style.getXML().toXMLString();
			str += "</style>";
			
			str+= "</PointSymbol>";
			
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit):void {
			var strXMLList:XMLList = _xml.point.children();
			point.setXML(strXMLList[0], kit);
			
			strXMLList = _xml.style.children();
			style.setXML(strXMLList[0]);
		}
						
	}
}