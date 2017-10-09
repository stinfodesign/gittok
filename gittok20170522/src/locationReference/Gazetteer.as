package locationReference
{
	import flash.utils.Dictionary;
	
	import gfm.ApplicationSchema;
	import gfm.AttributeType;
	import gfm.FeatureType;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;

	public class Gazetteer
	{
		public var kitURL:String;
		public var featureType:FeatureType;
		public var geoNameType:AttributeType;
		public var positionType:AttributeType;
		public var locationInstances:ArrayList;
		
		public function Gazetteer()
		{
			locationInstances = new ArrayList();
		}
		
		public function getXML():XML {
			var str:String = '<Gazetteer ';
			str += 'kitURL="' + kitURL + '" ';
			str += 'featureType="' + featureType.name + '" ';
			str += 'geoNameType="' + geoNameType.name + '" ';
			str += 'positionType="' + positionType.name + '">';
			str += '<locationInstances>';
			for (var i:int = 0; i < locationInstances.length; i++) {
				var li:LocationInstance = locationInstances.getItemAt(i) as LocationInstance;
				str += li.getXML().toXMLString();
			}
			str += '</locationInstances>';
			str += '</Gazetteer>';
			return XML(str);
		}
		
		public function setXML(_xml:XML, applicationSchema:ApplicationSchema):void {
			kitURL = _xml.@kitURL;
			
			var concreteTypes:ArrayList = applicationSchema.constructConcreteTypes();

			var fTypeName:String = _xml.@featureType;
			var lTypeName:String = _xml.@geoNameType;
			var pTypeName:String = _xml.@positionType;
			for (var i:int = 0; i <concreteTypes.length; i++) {
				var cType:FeatureType = concreteTypes.getItemAt(i) as FeatureType;
				if (cType.name == fTypeName) {
					featureType = cType;
					break;
				}
			}
			geoNameType  = featureType.getAttributeTypeByName(lTypeName);
			positionType = featureType.getAttributeTypeByName(pTypeName);
			var liList:XMLList = _xml.locationInstances.children();
			
			locationInstances = new ArrayList();
			if (liList.length() > 0) {
				for (i = 0; i < liList.length(); i++) {
					var li:LocationInstance = new LocationInstance();
					li.setXML(liList[i]);
					locationInstances.addItem(li);
				}
			}
		}

		
	}
}