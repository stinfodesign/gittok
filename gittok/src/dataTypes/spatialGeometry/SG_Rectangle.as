package dataTypes.spatialGeometry
{
	
	import flash.utils.Dictionary;
	import mx.utils.UIDUtil;

	public class SG_Rectangle
	{
		public var id:String;
		public var lowerLeft:Coordinate2;	// lower left coordinate
		public var upperRight:Coordinate2;	// upper right coordinate
		
		public function SG_Rectangle()
		{
			this.id = UIDUtil.createUID();			
			lowerLeft  = new Coordinate2();
			upperRight = new Coordinate2();
		}

		public function getXML():XML {
			// Header
			var str:String = '<SG_Rectangle id="' + this.id + '">';
			
			// Extent
			str += '<lowerLeft>';
			str += lowerLeft.getXML().toXMLString();
			str += '</lowerLeft>';
			
			str += '<upperRight>';
			str += upperRight.getXML().toXMLString();
			str += '</upperRight>';

			// Footer
			str += '</SG_Rectangle>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML, geometryDic:Dictionary = null):void {
			
			this.id = _xml.@id;
			
			// lower left
			var llXMLList:XMLList = _xml.lowerLeft.children();
			var llXML:XML = llXMLList[0];
			var strCoord:String = llXML.@component;
			var elements:Array  = strCoord.split(",");
			this.lowerLeft.x = Number(elements[0]);
			this.lowerLeft.y = Number(elements[1]);			
			
			// upper right
			var whXMLList:XMLList = _xml.upperRight.children();
			var whXML:XML = whXMLList[0];
			strCoord = whXML.@component;
			elements = strCoord.split(",");
			this.upperRight.x = Number(elements[0]);
			this.upperRight.y = Number(elements[1]);			
			
		}
	}
}