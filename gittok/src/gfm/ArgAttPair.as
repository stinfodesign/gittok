package gfm
{
	import instanceModel.Kit;

	public class ArgAttPair
	{
		public var fromTo:String;				// "self", "from" or "to"
		public var targetTypeName:String;
		public var attributeType:AttributeType; // corresponding attribute with the argument
		public var argumentType:AttributeType;	// argument of the operation
		
		public function ArgAttPair()
		{
			this.argumentType = new AttributeType();
			this.attributeType = new AttributeType();
		}
		
		public function getXML():XML {
			var str:String 	= '<ArgAttPair '
							+ 'fromTo="' + this.fromTo 
							+ '" targetTypeName="' + this.targetTypeName 
							+ '">';
			str += '<argumentType>'  + argumentType.getXML().toXMLString() + '</argumentType>';
			str += '<attributeType>' + attributeType.getXML().toXMLString() + '</attributeType>';
			str += '</ArgAttPair>';
			
			return XML(str);
		}

		public function setXML(_xml:XML):void {
			this.fromTo = _xml.@fromTo;
			this.targetTypeName = _xml.@targetTypeName;
			
			var aList:XMLList = _xml.argumentType.children();			
			this.argumentType.setXML(aList[0]);
			
			aList = _xml.attributeType.AttributeType;
			this.attributeType.setXML(aList[0]);

		}
		
	}
}