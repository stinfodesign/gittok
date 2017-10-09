package portrayal.gpm
{
	
	import mx.collections.ArrayList;

	public class ConditionElement
	{
		public var valueType:String;
		public var value:*;
		public var symName:String;
		public var symType:String;
		
		public function ConditionElement()
		{
			symName = symType = "";
		}
		
		public function getXML():XML {
			var outValue:String;
			
			if (value is Boolean) {
				valueType = "Boolean";
				outValue = (value == true) ? "true": "false";
			}
			else if (value is String) {
				valueType = "String";
				outValue = value as String;
			}
			else if (value is ArrayList) {
				valueType = "Number";
				var v0:Number = value.getItemAt(0) as Number;
				var v1:Number = value.getItem(1) as Number;
				outValue = "" + v0 + "," + v1;
			}
			var str:String = '<ConditionElement valueType="' + valueType
							+ '" value="' + outValue
							+ '" symName="' + this.symName
							+ '" symType="' + this.symType + '"/>';
			return XML(str);
		}
		
		public function setXML(_xml:XML): void {
			var inValue:String = _xml.@value.toString();
			this.valueType = _xml.@valueType.toString();
			
			if (valueType == "Boolean") {
				this.value = (inValue == "true") ? true : false;		
			}
			else if (valueType == "String") {
				this.value = inValue;
			}
			else if (valueType == "Number") {
				var va:Array = inValue.split(",");
				this.value = new ArrayList();
				this.value.addItem(Number(va[0]));
				this.value.addItem(Number(va[1]));
			} 

			this.symName  = _xml.@symName.toString();
			this.symType  = _xml.@symType.toString();
		}
	}
}