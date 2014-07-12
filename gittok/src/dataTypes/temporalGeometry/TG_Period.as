package dataTypes.temporalGeometry
{
	public class TG_Period extends TG_Primitive
	{
		public var begins:TG_Instant;
		public var ends:TG_Instant;
		
		public function TG_Period()
		{
			begins = new TG_Instant();
			ends = new TG_Instant();
		}
	}
}