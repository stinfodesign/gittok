package portrayal.gpm
{
	import flash.utils.Dictionary;
	
	import gfm.AttributeType;
	
	public class FeaturePortrayalUnit
	{
		public var typeID:String;				// feature type having portrayal parameters
		
		public var generalModifiers:Dictionary; 		// for a general purpose map
		public var thematicModifier:ThematicCondition;	// for a thematic map
		public var infoPages:Dictionary;				// for information pages on a map
		

		public function FeaturePortrayalUnit()
		{
			generalModifiers = new Dictionary();
			thematicModifier = new ThematicCondition();
			infoPages		 = new Dictionary();
		}
		
		public function getXML():XML {
			var str:String = '<FeaturePortrayalUnit typeID="' + this.typeID + '">';
			str += '<generalModifiers>';
			if (generalModifiers != null) {
				for each(var aslPair:* in generalModifiers) {
					if (aslPair is AttributeSymbolPair) {
						var asPair:AttributeSymbolPair = aslPair as AttributeSymbolPair;
						str += asPair.getXML().toXMLString();
					}
					else {
						var alPair:AttributeLabelPair = aslPair as AttributeLabelPair;
						str += alPair.getXML().toXMLString();
					}
				}
			}
			str += '</generalModifiers>';
			str += '<thematicModifier>';
			if (thematicModifier != null)
				str += thematicModifier.getXML().toXMLString();
			str+= '</thematicModifier>';
			
			str += '<infoPages>';
			for each(var infoPageAttType:AttributeType in infoPages) {
				str += infoPageAttType.getXML().toXMLString();
			}
			str += '</infoPages>';
			
			str += '</FeaturePortrayalUnit>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.typeID = _xml.@typeID;
			
			generalModifiers = new Dictionary();
			var strXMLList:XMLList = _xml.generalModifiers.children();
			if (strXMLList.length() > 0) {
				for each(var strXML:XML in strXMLList) {
					if (strXML.localName() == "AttributeSymbolPair") {
						var asPair:AttributeSymbolPair = new AttributeSymbolPair();
						asPair.setXML(strXML);
						generalModifiers[asPair.attName] = asPair;
					}
					else {
						var alPair:AttributeLabelPair = new AttributeLabelPair();
						alPair.setXML(strXML);
						generalModifiers[alPair.attName] = alPair;
					}
				}
			}			
			
			thematicModifier = new ThematicCondition();
			var themaXMLList:XMLList = _xml.thematicModifier.children();
			if (themaXMLList.length() > 0)
				thematicModifier.setXML(themaXMLList[0]);
			
			infoPages = new Dictionary();
			strXMLList = _xml.fpUnits.balloonsOnMap.children();
			if (strXMLList.length() > 0) {
				for each(strXML in strXMLList) {
					var infoPageAtt:AttributeType = new AttributeType();
					infoPageAtt.setXML(strXML);
					infoPages[infoPageAtt.name] = infoPageAtt;
				}
			}

		}
	}
}