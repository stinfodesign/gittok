package portrayal.portrayalStyle
{
	import flash.utils.Dictionary;
	import gfm.AttributeType;
	
	public class FeaturePortrayalPair
	{
		public var featureTypeID:String;				// feature type having portrayal parameters
		public var generalModifiers:Dictionary; 		// for a general purpose map
		public var thematicModifier:ThematicCondition;	// for a thematic map
		public var balloonsOnMap:Dictionary;			// for balloon display on map
		
		/* asPair is a attribute and style pair, element of generalModifiers
		"attName" ---- Keyword of the dictionary
		*/
		public function FeaturePortrayalPair()
		{
			generalModifiers = new Dictionary();
			thematicModifier = new ThematicCondition();
			balloonsOnMap    = new Dictionary();
		}
		
		public function getXML():XML {
			var str:String = '<FeaturePortrayalPair featureTypeID="' + this.featureTypeID + '">';
			str += '<generalModifier>';
			for each(var asPair:AttributeStylePair in generalModifiers) {
				str += asPair.getXML();
			}
			str += '</generalModifier>';
			
			str += '<thematicModifier>';
			str += thematicModifier.getXML();
			str+= '</thematicModifier>';
			
			str += '<balloonsOnMap>';
			for each(var balloonAttType:AttributeType in balloonsOnMap) {
				str += balloonAttType.getXML();
			}
			str += '</balloonOnMap>';
			
			
			str += '</FeaturePortrayalPair>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.featureTypeID = _xml.@featureTypeID;
			
			generalModifiers = new Dictionary();
			var strXMLList:XMLList = _xml.generalModifier.children();
			for each(var strXML:XML in strXMLList) {
				var asPair:AttributeStylePair = new AttributeStylePair();
				asPair.setXML(strXML);
				generalModifiers[asPair.attName] = asPair;
			}
			
			thematicModifier = new ThematicCondition();
			thematicModifier.setXML(_xml.thematicModifier);
			
			balloonsOnMap = new Dictionary();
			strXMLList = _xml.balloonsOnMap.children();
			for each(strXML in strXMLList) {
				var balloonAtt:AttributeType = new AttributeType();
				balloonAtt.setXML(strXML);
				balloonsOnMap[balloonAtt.name] = balloonAtt;
			}

		}
	}
}