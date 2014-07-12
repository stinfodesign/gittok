package metadata
{
	public class TemporalExtent
	{
		public var begin:Date;
		public var end:Date;
		
		public function TemporalExtent()
		{
			begin = new Date();
			end = new Date();
		}
		
		public function getXML():XML {
			// getTime returns milli-sec from　1970-01-01 00:00:00 (UTC) 
			var str:String = '<TemporalExtent ';
			str += 'begin="' + begin.getTime() + '" '
				+  'end="'   + end.getTime() + '"/>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			var str:String = _xml.@begin.toString();
			this.begin = new Date(Number(str));
			str = _xml.@end.toString();
			this.end = new Date(Number(str));
		}
	}
}