

package dataTypes.spatialGeometry
{
	import flash.utils.Dictionary;
	
	import gfm.AttributeType;
	
	import instanceModel.Kit;
	
	import mx.utils.UIDUtil;
	
	public class SG_Primitive extends SG_Object
	{
		
		public function SG_Primitive()
		{
			super();
		}
		
		public override function getXML():XML {
			var str:String = '<SG_Primitive>'
						+ '<inheritance>'
						+ super.getXML().toXMLString()
						+ '</inheritance>' 
						+ '</SG_Primitive>';
				
			return XML(str);
		}
		
		public override function setXML(_xml:XML, kit:Kit = null):void {
			var primiList:XMLList = _xml.inheritance.children();
			super.setXML(primiList[0]);

		}
	}
}