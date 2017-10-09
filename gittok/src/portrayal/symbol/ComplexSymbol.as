package portrayal.symbol
{
	import dataTypes.spatialGeometry.SG_Complex;
	import dataTypes.spatialGeometry.SG_Curve;
	import dataTypes.spatialGeometry.SG_Point;
	import dataTypes.spatialGeometry.SG_Surface;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;
	
	import portrayal.symbolStyle.AreaSymbolStyle;
	import portrayal.symbolStyle.ComplexSymbolStyle;
	
	public class ComplexSymbol extends Sprite
	{
		public var complex:SG_Complex = new SG_Complex();
		public var style:ComplexSymbolStyle = new ComplexSymbolStyle();
		
		public function ComplexSymbol()
		{
			super();
		}
		
		public function encode():Object {
			var complexObj:Object = new Object();
			complexObj.complex = complex;
			complexObj.style = style;
			return complexObj;
		}
		
		public function decode(complexObj:Object, btmaps:Dictionary):void
		{
			complex = complexObj.complex;
			style = complexObj.style;
			
			for (var i:int = 0; i < complex.surfaceSet.length; i++) {
				var areaSymbol:AreaSymbol = new AreaSymbol();
				areaSymbol.surface = complex.surfaceSet.getItemAt(i) as SG_Surface;
				areaSymbol.style = style.areaSymbolStyle;
				areaSymbol.decode(areaSymbol.encode());
			}
			
			for (i = 0; i < complex.curveSet.length; i++) {
				var lineSymbol:LineSymbol = new LineSymbol();
				lineSymbol.curve = complex.curveSet.getItemAt(i) as SG_Curve;
				lineSymbol.style = style.lineSymbolStyle;
				lineSymbol.decode(lineSymbol.encode());
			}
			
			for (i = 0; i < complex.pointSet.length; i++) {
				var pointSymbol:PointSymbol = new PointSymbol();
				pointSymbol.point = complex.pointSet.getItemAt(i) as SG_Point;
				pointSymbol.style = style.pointSymbolStyle;
				pointSymbol.decode(pointSymbol.encode(), btmaps);
			}
			
		}
		
		public function getXML():XML {
			var str:String = "<ComplexSymbol>";
			
			str += "<style>";
			str += style.getXML().toXMLString();
			str += "</style>";

			str += "<surfaces>";			
			for (var i:int = 0; i < complex.surfaceSet.length; i++) {
				var surfaces:ArrayList = complex.surfaceSet;
				for (var j:int = 0; j < surfaces.length; j++) {
					str += "<surface>";
					var surface:SG_Surface = surfaces.getItemAt(j) as SG_Surface;
					str += surface.getXML().toXMLString();
					str += "<surface/>";
				}
				
			}
			str += "</surfaces>";
					
			str += "<curves>";			
			for (i = 0; i < complex.curveSet.length; i++) {
				var curves:ArrayList = complex.curveSet;
				for (j = 0; j < curves.length; j++) {
					str += "<curve>";
					var curve:SG_Curve = curves.getItemAt(j) as SG_Curve;
					str += curve.getXML().toXMLString();
					str += "<curve/>";
				}
				
			}
			str += "</curves>";
			
			str += "<points>";			
			for (i = 0; i < complex.pointSet.length; i++) {
				var points:ArrayList = complex.pointSet;
				for (j = 0; j < points.length; j++) {
					str += "<point>";
					var point:SG_Point = points.getItemAt(j) as SG_Point;
					str += point.getXML().toXMLString();
					str += "<point/>";
				}
				
			}
			str += "</points>";

			str += "</ComplexSymbol>";
			
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit):void {
			var pointXMLList:XMLList = _xml.points.children();
			for each(var pointXML:XML in pointXMLList) {
				var point:SG_Point;
				point.setXML(pointXML, kit);
				complex.pointSet.addItem(point);
			}
			
			var curveXMLList:XMLList = _xml.curves.children();
			for each(var curveXML:XML in curveXMLList) {
				var curve:SG_Curve;
				curve.setXML(curveXML, kit);
				complex.curveSet.addItem(curve);
			}

			var surfaceXMLList:XMLList = _xml.surfaces.children();
			for each(var surfaceXML:XML in surfaceXMLList) {
				var surface:SG_Surface;
				surface.setXML(surfaceXML, kit);
				complex.surfaceSet.addItem(surface);
			}
			
			var strXMLList:XMLList = _xml.style.children();
			style.setXML(strXMLList[0]);
		}
		
		
	}
}