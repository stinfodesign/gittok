package dataTypes.place
{
	import mx.utils.UIDUtil;

	public class Address
	{
		public var id:String;
		public var zipCode:String;
		public var location:String;
		public var country:String;
		
		// Constructor
		public function Address() {
			this.id = UIDUtil.createUID();			
		}
		
		public function getXML():XML {
			var str:String = '<Address id="' + this.id + '" ';
			str += 'zipCode="' + this.zipCode + '" ';
			str += 'location="' + this.location + '" ';
			str += 'country="' + this.country + '"/>';
			return XML(str);			
		}
		
		public function setXML(_xml:XML):void {
			this.id = _xml.@id.toString();
			this.zipCode = _xml.@zipCode.toString();
			this.location = _xml.@location.toString();
			this.country = _xml.@country.toString();
		}
		
		public function toString():String {
			return location + " " + zipCode + " " + country;
		}
	}
}