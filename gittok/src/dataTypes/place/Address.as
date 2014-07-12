package dataTypes.place
{
	import mx.utils.UIDUtil;

	public class Address
	{
		public var id:String;
		public var zipCode:String;
		public var element:String;
		public var country:String;
		
		// Constructor
		public function Address() {
			this.id = UIDUtil.createUID();			
		}
		
		public function getXML():XML {
			var str:String = '<Address id="' + this.id + '" ';
			str += 'zipCode="' + this.zipCode + '" ';
			str += 'element="' + this.element + '" ';
			str += 'country="' + this.country + '"/>';
			return XML(str);			
		}
		
		public function setXML(_xml:XML):void {
			this.id = _xml.@id.toString();
			this.zipCode = _xml.@zipCode.toString();
			this.element = _xml.@element.toString();
			this.country = _xml.@country.toString();
		}
	}
}