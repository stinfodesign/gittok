package dataTypes.spatialGeometry
{
	import mx.collections.ArrayList;

	public class SG_CompositeCurve extends SG_Complex
	{
		public var element:ArrayList;
		
		public function SG_CompositeCurve()
		{
			super();
			element = new ArrayList();
		}
		
	}
}