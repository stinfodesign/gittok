package math
{
	public class AffineParam
	{
		public var coefficient:Array;
		public var variance:Array;
		public var ids:Array;
		public var error:Array;
		

		public function AffineParam()
		{
			coefficient = new Array();
			variance = new Array();
			ids = new Array();
			error = new Array();
		}
		
		public function getXML():XML {
			var str:String = '<AffineParam coefficient="';
			str += XML(coefficient).toXMLString();
			str += '" variance="';
			str += XML(variance).toXMLString();
			str += '"id="';
			str += XML(ids).toXMLString();
			str += '" error="';
			str += XML(error).toXMLString();
			str += '"/>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			var strCoeff:String = _xml.@coefficient;
			var strVariance:String = _xml.@variance;
			var strError:String = _xml.@error;
			var strIds:String = _xml.@id;
			
			var element:Array = strCoeff.split(',');
			var m:int = element.length;
			var i:int = 0;
			for (var j:int = 0; j < 3; j++) {
				coefficient[j] = new Array();
				for (var k:int = 0; k < 2; k++) {
					this.coefficient[j][k] = Number(element[i++]);	
				}
			}
			
			element = strVariance.split(',');
			i = 0;
			for (j = 0; j < 2; j++) {
				variance[j] = new Array();
				for (k = 0; k < 2; k++) {
					this.variance[j][k] = Number(element[i++]);
				}
			}
			
			element = strIds.split(',');
			var n:int = element.length;
			i = 0;
			for (j = 0; j < n; j++) {
				ids[j] = new Array();
				this.ids[j] = element[i++];
			}
			
			element = strError.split(',');
			n = element.length;
			i = 0;
			for (j = 0; j < n; j++) {
				error[j] = new Array();
				for (k = 0; k < 2; k++) {
					this.error[j][k] = Number(element[i++]);
				}
			}

			
		}
	}
}