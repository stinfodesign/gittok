package gfm
{

	public class AttributeType
	{
		public var derived:String;
		public var name:String;
		public var dataType:String;
		public var multiplicity:Boolean;
		public var unit:String;
		
		public function AttributeType() {
			derived = name = dataType = unit = "";
			multiplicity = false;
		}
		
		public function getXML():XML {
			var str:String 	= '<AttributeType '
							+ 'derived="' + this.derived + '" '
							+ 'name="' + this.name + '" ' 
							+ 'dataType="' + this.dataType + '" '
							+ 'multiplicity="' + this.multiplicity + '" '
							+ 'unit="' + this.unit + '"/>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.derived = _xml.@derived.toXMLString();
			
			this.name 	= _xml.@name.toXMLString();
			
			this.dataType	= _xml.@dataType.toXMLString();
			
			var b:String 	= _xml.@multiplicity.toXMLString();
			this.multiplicity = (b == "true") ? true : false;
			
			this.unit	= _xml.@unit;
		}
	}
}