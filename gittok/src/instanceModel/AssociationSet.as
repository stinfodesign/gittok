package instanceModel
{
	import flash.utils.Dictionary;
	
	import gfm.AssociationType;
	
	public class AssociationSet
	{
		public var typeID:String;
		public var associations:Dictionary;
		
		public function AssociationSet()
		{
			super();
			associations = new Dictionary();
		}
		
		public function getXML():XML {
			var str:String = '<AssociationSet typeID="' + this.typeID + '">';
			str += '<associations';
			var flag:Boolean = false;
			var aids:String = ' idref="';
			for each(var association:Association in associations) {
				aids += association.id + ',';
				flag = true;
			}
			if (flag) aids = aids.substr(0,aids.length - 1) + '"';
			else aids = '';
			str += aids;
			str += '/>';
			str += '</AssociationSet>';
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit):void {
			this.typeID = _xml.@typeID.toString();
			this.associations = new Dictionary();
			var asXMLList:XMLList = _xml.associations;
			var asXML:XML = asXMLList[0];
			var aids:String = asXML.@idref.toString();
			if (aids != "") {
				var aidArray:Array = aids.split(",");
				var m:int = aidArray.length;
				for (var i:int = 0; i < m; i++) {
					var aid:String = aidArray[i];
					var ass:Association = kit.associationList[aid] as Association;
					this.associations[aid] = kit.associationList[aid] as Association;	
				}
			}
		}
	}
}