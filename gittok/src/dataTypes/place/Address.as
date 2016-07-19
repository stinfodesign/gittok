package dataTypes.place
{
	import mx.utils.UIDUtil;

	public class Address extends Place
	{
		public var id:String;
		public var zipCode:String;
		public var location:String;
		public var country:String;
		
		// Constructor
		public function Address() {
		  id = UIDUtil.createUID();	
		}
		
		public override function getXML():XML {
			var str:String = '<Address id="' + this.id + '" ';
			str += 'zipCode="' + this.zipCode + '" ';
			str += 'location="' + this.location + '" ';
			str += 'country="' + this.country + '">';
			
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			
			str += '</Address>';
			
			return XML(str);			
		}
		
		public override function setXML(_xml:XML):void {
			var strXMLList:XMLList = _xml.inheritance.children();
			var strXML:XML = strXMLList[0];

			super.setXML(strXML);
			
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