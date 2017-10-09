package portrayal.gpm.list
{
	import gfm.AttributeType;
	import gfm.FeatureType;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;

	public class FeatureTypeForListing extends FeatureType
	{
		public var selectedAttributeTypes:ArrayList;
		
		public function FeatureTypeForListing()
		{
			super();	
			selectedAttributeTypes = new ArrayList();
		}
		
		override public function getXML():XML {
			var attributeNames:String = '<selectedAttributeTypeNames names="';
			for (var i:int = 0; i < selectedAttributeTypes.length; i++) {
				var aType:AttributeType = selectedAttributeTypes.getItemAt(i) as AttributeType;
				attributeNames += aType.name + ",";
			}
			attributeNames = attributeNames.substring(0, attributeNames.length - 1);
			attributeNames += '" />';
			
			var str:String = "";
			str = "<FeatureTypeForListing>";
			str += "<inheritance>";
			str += super.getXML();
			str += "</inheritance>";
			str += attributeNames;
			str += "</FeatureTypeForListing>";
			
			return XML(str);
		}
		
		override public function setXML(_xml:XML, kit:Kit=null):void {
			var fTypeXMLList:XMLList = _xml.inheritance.children();
			super.setXML(fTypeXMLList[0]);
			var str:String = _xml.selectedAttributeTypeNames.@names;
			var atNames:Array = str.split(",");
			for (var i:int = 0; i < atNames.length; i++) {
				for (var j:int = 0; j < attributeTypes.length; j++) {
					var aType:AttributeType = attributeTypes.getItemAt(j) as AttributeType;
					if (atNames[i] == aType.name) {
						selectedAttributeTypes.addItem(aType);						
					}
				}
			}
		}
		
	}
}