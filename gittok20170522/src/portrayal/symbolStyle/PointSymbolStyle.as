package portrayal.symbolStyle
{
	import dataTypes.spatialGeometry.Coordinate2;
	import dataTypes.spatialGeometry.CoordinateArray;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	import mx.graphics.RadialGradient;

	public class PointSymbolStyle extends SymbolStyle
	{
		public var size:Number;
		
		public var elements:ArrayList;				//arraylist of coordinate sequence
		public var styles:ArrayList;
		
		public function PointSymbolStyle()
		{
			super();
			elements = new ArrayList();
			styles = new ArrayList();
			
		}
		
		public override function getXML():XML {
			var str:String 	= '<PointSymbolStyle '
				+ 'size="' + this.size + '">'
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			
			str += '<elements>';
			for (var i:int = 0; i < elements.length; i++) {
				var crdArray:CoordinateArray = this.elements.getItemAt(i) as CoordinateArray;
				str += crdArray.getXML().toXMLString();
				
			}
			str += '</elements>';
			
			str += '<styles>';
			for (i = 0; i < this.styles.length; i++) {
				var style:* = styles.getItemAt(i);
				str += style.getXML().toXMLString();
			}
			str += '</styles>';
			str += '</PointSymbolStyle>';
			
			return XML(str);
		}
		
		public override function setXML(_xml:XML, lStyleDic:Dictionary = null):void {
			this.size = _xml.@size.toString();
			
			var strXMLList:XMLList = _xml.inheritance.children();
			var strXML:XML = strXMLList[0];
			super.setXML(strXML);
			
			strXMLList = _xml.elements.children();
			for each(strXML in strXMLList) {
				var crdArray:CoordinateArray = new CoordinateArray();
				crdArray.setXML(strXML);
				this.elements.addItem(crdArray);
			}
			
			strXMLList = _xml.styles.children();
			for each(strXML in strXMLList) {
				if (strXML.name().toString() == "LineSymbolStyle") {
					var lStyle:LineSymbolStyle = new LineSymbolStyle();
					lStyle.setXML(strXML);
					this.styles.addItem(lStyle);
				}
				if (strXML.name().toString() == "AreaSymbolStyle") {
					var aStyle:AreaSymbolStyle = new AreaSymbolStyle();
					aStyle.setXML(strXML, lStyleDic);
					this.styles.addItem(aStyle);
				}
				if (strXML.name().toString() == "CircleSymbolStyle") {
					var cStyle:CircleSymbolStyle = new CircleSymbolStyle();
					cStyle.setXML(strXML, lStyleDic);
					this.styles.addItem(cStyle);
				}

			}
		}
		

	}
}