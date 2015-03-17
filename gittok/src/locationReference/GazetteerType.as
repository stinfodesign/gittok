package locationReference
{
	import gfm.ApplicationSchema;
	import gfm.AttributeType;
	import gfm.FeatureType;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;

	public class GazetteerType
	{
		public var kitURL:String;
		public var featureType:FeatureType;
		public var geoNameType:AttributeType;
		public var positionType:AttributeType;
		public var gazetteItemList:ArrayList;
		
		public function GazetteerType()
		{
			gazetteItemList = new ArrayList();
		}
		
		public function getXML():XML {
			var str:String = '<GazetteerType ';
			str += 'kitURL="' + kitURL + '" ';
			str += 'featureType="' + featureType.name + '" ';
			str += 'geoNameType="' + geoNameType.name + '" ';
			str += 'positionType="' + positionType.name + '">';
			
			for (var i:int = 0; i < gazetteItemList.length; i++) {
				var gazette:GazetteItem = gazetteItemList.getItemAt(i) as GazetteItem;
				str += gazette.getXML().toXMLString();
			}
			str += '</GazetteerType>';
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit):void {
			var applicationSchema:ApplicationSchema = kit.applicationSchema;
			var fTypeName:String = _xml.@featureType;
			var lTypeName:String = _xml.@geoNameType;
			var pTypeName:String = _xml.@positionType;
			featureType  = applicationSchema.featureTypes[fTypeName] as FeatureType;
			geoNameType = featureType.attributeTypes[lTypeName];
			positionType = featureType.attributeTypes[pTypeName];
			var gazetteItems:XMLList = _xml.children();
			trace(gazetteItems.toXMLString());
		}
	}
}