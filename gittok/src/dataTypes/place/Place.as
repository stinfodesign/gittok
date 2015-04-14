package dataTypes.place
{
	public class Place
	{
		public var featureID:String;
		
		public function Place()
		{
		}
		
		public function getXML():XML {
			var str:String = '<Place featureID="' + this.featureID + '"/>';
			return XML(str);			
		}
		
		public function setXML(_xml:XML):void {
			this.featureID = _xml.@featureID.toString();
		}
	}
}