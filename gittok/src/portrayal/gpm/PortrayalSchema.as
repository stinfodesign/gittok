package portrayal.gpm
{
	import flash.utils.Dictionary;
	import portrayal.gpm.FeaturePortrayalUnit;

	public class PortrayalSchema
	{
		public var applicationSchema:String;
		public var symbolStyleDictionary:String;
		public var labelStyleDictionary:String;
		public var fpUnits:Dictionary;
		
		public function PortrayalSchema()
		{
			fpUnits = new Dictionary();
		}
		
		public function getXML():XML {
			var str:String = '<?xml version=“1.1” encoding="UTF-8"?>';

			str += '<PortrayalDic applicationSchema="' + this.applicationSchema + '" ';
			str += 'symbolStyleDictionary="' + this.symbolStyleDictionary + '" ';
			str += 'labelStyleDictionary="' + this.labelStyleDictionary + '">';
			for each(var fpPair:FeaturePortrayalUnit in fpUnits) {
				str += fpPair.getXML().toString();
			}
			str += '</PortrayalDic>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.applicationSchema = _xml.@applicationSchema;
			this.symbolStyleDictionary = _xml.@symbolStyleDictionary;
			this.labelStyleDictionary  = _xml.@labelStyleDictionary;
			var strXMLList:XMLList = _xml.children();
			for each(var strXML:XML in strXMLList) {
				var fpPair:FeaturePortrayalUnit = new FeaturePortrayalUnit();
				fpPair.setXML(strXML);
				fpUnits[fpPair.featureTypeID] = fpPair;
			}
		}
		
		
	}
}