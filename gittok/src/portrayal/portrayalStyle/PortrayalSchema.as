package portrayal.portrayalStyle
{
	import flash.utils.Dictionary;
	import portrayal.portrayalStyle.FeaturePortrayalPair;

	public class PortrayalSchema
	{
		public var applicationSchema:String;
		public var symbolStyleSchema:String;
		public var labelStyleSchema:String;
		public var fpPairs:Dictionary;
		
		public function PortrayalSchema()
		{
			fpPairs = new Dictionary();
		}
		
		public function getXML():XML {
			var str:String = '<PortrayalDic applicationSchema="' + this.applicationSchema + '" ';
			str += 'symbolStyleSchema="' + this.symbolStyleSchema + '" ';
			str += 'labelStyleSchema="' + this.labelStyleSchema + '">';
			for each(var fpPair:FeaturePortrayalPair in fpPairs) {
				str += fpPair.getXML().toString();
			}
			str += '</PortrayalDic>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.applicationSchema = _xml.@applicationSchema;
			this.symbolStyleSchema = _xml.@symbolStyleSchema;
			this.labelStyleSchema  = _xml.@labelStyleSchema;
			var strXMLList:XMLList = _xml.children();
			for each(var strXML:XML in strXMLList) {
				var fpPair:FeaturePortrayalPair = new FeaturePortrayalPair();
				fpPair.setXML(strXML);
				fpPairs[fpPair.featureTypeID] = fpPair;
			}
		}
		
		
	}
}