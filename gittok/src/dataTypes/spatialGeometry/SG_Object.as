package dataTypes.spatialGeometry
{
	import flash.utils.Dictionary;
	
	import gfm.AttributeType;
	
	import instanceModel.Kit;
	
	import mx.utils.UIDUtil;

	public class SG_Object
	{
		public var id:String;
		public var featureID:String;
		public var attributeName:String;
		// The relationship between feature and geometry shall be "one to one".
		// Otherwise, you cannot get an unique feature from geometric attribute.

		public function SG_Object()
		{
			this.id = UIDUtil.createUID();
			this.featureID = this.attributeName = "";		
		}
		
		public function getXML():XML {
			var str:String = '<SG_Object id="' + this.id 
				+ '" featureID="' + this.featureID 
				+ '" attributeName ="' + this.attributeName 
				+ '"/>'
			
			return XML(str);			
		}
		
		public function setXML(_xml:XML, kit:Kit = null):void {
			this.id = _xml.@id;
			this.featureID = _xml.@featureID;
			this.attributeName = _xml.@attributeName;
		}
		
	}
}