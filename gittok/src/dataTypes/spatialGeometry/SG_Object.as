package dataTypes.spatialGeometry
{
	import flash.utils.Dictionary;
	
	import gfm.AttributeType;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;
	import mx.utils.UIDUtil;

	public class SG_Object
	{
		public var id:String;
		public var featureID:ArrayList;
		public var attributeName:ArrayList;

		public function SG_Object()
		{
			this.id = UIDUtil.createUID();
			this.featureID = new ArrayList();
			this.attributeName = new ArrayList();		
		}
		
		public function getXML():XML {
			var str:String = '<SG_Object id="' + this.id; 
			
			var idstr:String = "";
			if (featureID.length > 0) {
				idstr = featureID.getItemAt(0) as String;
				for (var i:int = 1; i < featureID.length; i++) {
					idstr += "," + featureID.getItemAt(i) as String;
				}
			}
			
			var atstr:String = "";
			if (attributeName.length > 0) {
				atstr = attributeName.getItemAt(0) as String;
				for (i = 1; i < attributeName.length; i++) {
					atstr += "," + attributeName.getItemAt(i) as String;
				}
			}			
			
			str	+= '" featureID="' + idstr 
				+ '" attributeName ="' + atstr 
				+ '"/>'
			
			return XML(str);			
		}
		
		public function setXML(_xml:XML, kit:Kit = null):void {
			this.id = _xml.@id;
			
			var idstr:String = _xml.@featureID;
			this.featureID = new ArrayList();
			if (idstr != "") {
				var ids:Array = idstr.split(",");
				var idsList:ArrayList = new ArrayList(ids);
				this.featureID.addAll(idsList);
			}

			var atstr:String = _xml.@attributeName;
			this.attributeName = new ArrayList();
			if (atstr != "") {
				var ats:Array = atstr.split(",");
				var atsList:ArrayList = new ArrayList(ats);
				this.attributeName.addAll(atsList);
			}
		}
		
	}
}