package portrayal.gpm.list
{
	//import gfm.ApplicationSchema;
	import gfm.ApplicationSchema;
	import gfm.AttributeType;
	import gfm.FeatureType;
	
	import mx.collections.ArrayList;

	public class ListSchema
	{
		public var applicationSchemaURL:String;
		
		public var selectedFeatureTypes:ArrayList;
		
		public function ListSchema()
		{
			selectedFeatureTypes = new ArrayList();
		}
		
		public function getXML():XML {
			var str:String = '<ListSchema applicationSchemaURL="' + this.applicationSchemaURL + '">';
			str += '<selectedFeatureTypes>';
			
			for (var i:int = 0; i < selectedFeatureTypes.length; i++) {
				var sfType:FeatureTypeForListing = selectedFeatureTypes.getItemAt(i) as FeatureTypeForListing;
				str += sfType.getXML().toXMLString();
			}
			
			str += '</selectedFeatureTypes>';
			str	+= '</ListSchema>';
			return XML(str);
		}
		
		public function setXML(_xml:XML): void {
			this.applicationSchemaURL = _xml.@applicationSchemaURL.toString();	
			
			var sfTypeXMLList:XMLList = _xml.selectedFeatureTypes.children();
			var n:int = sfTypeXMLList.length();
			for (var i:int = 0; i < n; i++) {
				var featureTypeForListing:FeatureTypeForListing = new FeatureTypeForListing();
				featureTypeForListing.setXML(sfTypeXMLList[i]);
				selectedFeatureTypes.addItem(featureTypeForListing);
			}
		}
	}
}