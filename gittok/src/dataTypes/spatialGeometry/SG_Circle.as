package dataTypes.spatialGeometry
{
	import flash.utils.Dictionary;
	
	import instanceModel.Kit;
	
	public class SG_Circle extends SG_Primitive
	{
		public var center:Coordinate2;
		public var radius:Number;
		
		public function SG_Circle()
		{
			super();
		}
		
		public override function getXML():XML {
			// Header
			var str:String = '<SG_Circle radius="';
			str += radius + '">'; 
			
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';			
			
			// Extent
			str += '<center>';
			str += center.getXML().toXMLString();
			str += '</center>';
						
			// Footer
			str += '</SG_Circle>';
			
			return XML(str);
			
		}
		
		public override function setXML(_xml:XML, kit:Kit = null):void {
			var strXMLList:XMLList = _xml.inheritance.children();
			var strXML:XML = strXMLList[0];
			
			this.id = strXML.@id;
			this.featureID = strXML.@featureID;
			
			// radius
			this.radius = Number(_xml.@radius);
			
			// center
			var llXMLList:XMLList = _xml.center.children();
			var llXML:XML = llXMLList[0];
			var strCoord:String = llXML.@component;
			var elements:Array  = strCoord.split(",");
			this.center.x = Number(elements[0]);
			this.center.y = Number(elements[1]);			
		}
		
	}
}