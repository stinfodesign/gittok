package dataTypes.temporalGeometry
{
	import mx.utils.UIDUtil;

	public class TG_Primitive
	{
		public var id:String;
		
		public function TG_Primitive()
		{
			this.id = UIDUtil.createUID();
		}
	}
}