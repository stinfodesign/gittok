package coordinateReference
{
	public class PrimeMeridian
	{
		
		public var greenwichLongitude:Number;	// The longitude of the prime meridian, its unit is decimal degree
		
		public function PrimeMeridian()
		{
		}
		
		public function getXML():XML {
			var str:String = '<PrimeMeridian greenwichLongitude="' + this.greenwichLongitude + '"/>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.greenwichLongitude = parseFloat(_xml.@greenwichLongitude.toString());
		}
	}
}