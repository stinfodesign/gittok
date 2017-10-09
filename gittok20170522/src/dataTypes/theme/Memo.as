package dataTypes.theme
{
	import mx.utils.UIDUtil;
	
	public class Memo extends ThematicDataType
	{
		public var id:String;
		public var title:String;
		
		public function Memo()
		{
			super();
			this.id = UIDUtil.createUID();			
			title = "";
		}
		
		// set and get "value" 
		
		public function get value():String  {
			return v as String;
		}
		
		public function set value(_v:String):void {
			v = _v;
		}
		
		public function getXML():XML {
			var str:String = '<Memo id="' + this.id;
			//str += '" featureID="' + this.featureID; 
			str += '" title="' + this.title;
			str += '" value="' + this.value + '"/>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.id 		= _xml.@id.toString();
			//this.featureID 	= _xml.@featureID.toString();
			this.title 		= _xml.@title.toString();
			this.value 		= _xml.@value.toString();
			
		}
		
	}
}