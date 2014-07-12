package dataTypes.temporalGeometry
{
	import mx.collections.ArrayList;

	public class TG_Instant extends TG_Primitive
	{
		public var position:Date;
		public var begunBy:ArrayList;
		public var endedBy:ArrayList;
		
		public function TG_Instant() 
		{
			super();
			begunBy = new ArrayList();
			endedBy = new ArrayList();
		}
	}
}