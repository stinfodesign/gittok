package gfm
{
	import mx.collections.ArrayList;

	public class OperationType
	{
		public var type:String;					// operation type in which this operation contains
		public var name:String;					// operation name
		public var returnFATypeName:String;		// Type Name of a frature or an association type that includes the return attribute type
		public var returnAttributeName:String;	// feature attribute name
		public var returnAttributeType:String;	// data type of the return value
		public var arguments:ArrayList;			// array of ArgAttPair
		
		public function OperationType()
		{
			this.arguments = new ArrayList();
		}
		
		public function getXML():XML {
			var str:String 	= '<OperationType '
				 			+ 'type="' + this.type + '" '
							+ 'name="' + this.name + '" '
							+ 'returnAttributeType="' + this.returnAttributeType + '" '
							+ 'returnAttributeName="' + this.returnAttributeName + '" '
							+ 'returnFATypeName="' + this.returnFATypeName +'">';
			
			str += '<arguments>';
			var m:int = this.arguments.length;
			for (var i:int = 0; i < m; i++) {
				var aap:ArgAttPair = this.arguments.getItemAt(i) as ArgAttPair;
				var aapXML:XML = aap.getXML();
				str += aapXML.toXMLString();
			}
			str += '</arguments>';
			
			str += '</OperationType>';
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.type = _xml.@type.toXMLString();
			this.name = _xml.@name.toXMLString();
			this.returnAttributeType = _xml.@returnAttributeType.toXMLString();
			this.returnAttributeName = _xml.@returnAttributeName.toXMLString();
			this.returnFATypeName = _xml.@returnFATypeName.toXMLString();
			
			this.arguments = new ArrayList();
			for each(var argXML:XML in _xml.arguments.children()) {
				var argAttPair:ArgAttPair = new ArgAttPair();
				argAttPair.setXML(argXML);
				this.arguments.addItem(argAttPair);
			}
		}

		
		
	}
}