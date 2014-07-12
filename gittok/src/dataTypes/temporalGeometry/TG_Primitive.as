package dataTypes.temporalGeometry
{
	public class TG_Primitive
	{
		public var id:Number;
		
		public function TG_Primitive()
		{
			var d:Date = new Date();
			this.id = d.getTime();	// milliseconds from 1970.01.01
		}
	}
}