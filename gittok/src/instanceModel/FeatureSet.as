package instanceModel
{
	import flash.utils.Dictionary;
	
	

	public class FeatureSet
	{
		public var typeID:String;
		public var features:Dictionary;
		
		public function FeatureSet()
		{
			features = new Dictionary();
		}
		
		public function getXML():XML {
			var str:String = '<FeatureSet typeID="' + this.typeID + '">';
			str += '<features';
			var flag:Boolean = false;
			var fids:String = ' idref="';
			for each(var feature:Feature in features) {
				if (feature != null) {
					fids += feature.id + ',';
					flag = true;
				}
			}
			if (flag) fids = fids.substr(0,fids.length - 1) + '"';
			else fids = '';
			str += fids;
			str += '/>';
			str += '</FeatureSet>';
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit):void {
			this.typeID = _xml.@typeID.toString();
			this.features = new Dictionary();
			var fsXMLList:XMLList = _xml.features;
			var fsXML:XML = fsXMLList[0];
			var fids:String = fsXML.@idref.toString();
			if (fids != "") {
				var fidArray:Array = fids.split(",");
				var m:int = fidArray.length;
				for (var i:int = 0; i < m; i++) {
					var fid:String = fidArray[i];
					//var ft:Feature = kit.featureList[fid] as Feature;
					this.features[fid] = kit.featureList[fid] as Feature;	
				}
			}
		}
	}
}