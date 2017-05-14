package portrayal.gpm
{
	import flash.utils.Dictionary;
	
	import gfm.FeatureType;
	
	import mx.collections.ArrayList;
	
	import portrayal.gpm.*;

	public class PortrayalSchema
	{
		public var applicationSchema:String;
		public var symbolStyleDictionary:String;
		public var labelStyleDictionary:String;
		public var representationOrder:ArrayList;
		public var fpUnits:Dictionary;
		
		public function PortrayalSchema()
		{
			fpUnits = new Dictionary();
		}
		
		public function getXML():XML {
			var str:String = '<?xml version=“1.1” encoding="UTF-8"?>';

			str += '<PortrayalSchema applicationSchema="' + this.applicationSchema + '" ';
			str += 'symbolStyleDictionary="' + this.symbolStyleDictionary + '" ';
			str += 'labelStyleDictionary="' + this.labelStyleDictionary + '"';
			
			str += 'representationOrder="';
			var rOrder:String = representationOrder.getItemAt(0) as String;
			for (var i:int = 1; i < representationOrder.length; i++) {
				rOrder += "," + representationOrder.getItemAt(i) as String;
			}
			str += rOrder + '">'				
			
			str += '<fpUnits>';
			for each(var fpPair:* in fpUnits) {
				if (fpPair is FeaturePortrayalUnit)
					fpPair = fpPair as FeaturePortrayalUnit;
				else
					fpPair = fpPair as AssociationPortrayalUnit;
				str += fpPair.getXML().toString();
			}
			str += '</fpUnits>';
			str += '</PortrayalSchema>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.applicationSchema = _xml.@applicationSchema;
			this.symbolStyleDictionary = _xml.@symbolStyleDictionary;
			this.labelStyleDictionary  = _xml.@labelStyleDictionary;
			
			var rStr:String = _xml.@representationOrder;
			var rOrder:Array = rStr.split(",");
			this.representationOrder = new ArrayList(rOrder); 
			
			var strXMLList:XMLList = _xml.fpUnits.children();
			for each(var strXML:XML in strXMLList) {
				var fpPair:FeaturePortrayalUnit = new FeaturePortrayalUnit();
				fpPair.setXML(strXML);
				fpUnits[fpPair.typeID] = fpPair;
			}
		}
		
		
	}
}