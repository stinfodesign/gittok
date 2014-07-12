package gfm
{
	public class ArgAttPair
	{
		public var fromTo:String;				// "self", "from" or "to"
		public var targetType:FeatureType;
		public var attributeType:AttributeType; // corresponding attribute with the argument
		public var argumentType:AttributeType;	// argument of the operation
		
		public function ArgAttPair()
		{
			this.argumentType = new AttributeType();
			this.attributeType = new AttributeType();
		}
		
		public function getXML():XML {
			var str:String 	= '<ArgAttPair '
							+ 'fromTo="' + this.fromTo + '">';
			str += '<argumentType>'  + argumentType.getXML().toXMLString() + '</argumentType>';
			str += '<attributeType>' + attributeType.getXML().toXMLString() + '</attributeType>';
			if (targetType != null)
				str += '<targetType>' + targetType.getXML().toXMLString() + '</targetType>';
			str += '</ArgAttPair>';
			
			return XML(str);
		}

		public function setXML(_xml:XML):void {
			this.fromTo = _xml.@fromTo;
			var aList:XMLList = _xml.argumentType.AttributeType;			
			this.argumentType.setXML(aList[0]);
			aList = _xml.attributeType.AttributeType;
			this.attributeType.setXML(aList[0]);
			aList = _xml.targetType;
			if (aList != null) 
				this.targetType.setXML(aList[0]);
		}
		
	}
}