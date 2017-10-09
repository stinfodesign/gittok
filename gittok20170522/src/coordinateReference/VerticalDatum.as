package coordinateReference
{
	public class VerticalDatum
	{
		public var id:String;
		public var name:String;
		
		public function VerticalDatum()
		{
			id = "";
			name = "";
		}
		
		public function getXML():XML {
			if (id != "") {
				var str:String = '<VerticalDatum id="' + this.id + '" name="' + this.name + '"/>';
				return XML(str);
			}
			return XML('<VerticalDatum/>');
		}
		
		public function setXML(_xml:XML):void {
			if (_xml.@id != null) {
				this.id = _xml.@id;
				this.name = _xml.@name;
			}
		}
	}
}