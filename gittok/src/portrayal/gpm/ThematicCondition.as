package portrayal.gpm
{
	import mx.collections.ArrayList;

	public class ThematicCondition
	{
		public var attName:String;				// attribute name that affects the proxy
		public var attType:String;				// attribute type that affects the proxy
		public var elements:ArrayList; 			// arraylist of modifiers
		
		public function ThematicCondition()
		{
			attName = attType = "";
			elements = new ArrayList();
		}
		
		public function getXML():XML {
			var str:String = '<ThematicCondition attName="' + this.attName
				+ '" attType="' + this.attType + '">';
			
			str += '<elements>';
			var n:int = elements.length;
			for (var i:int = 0; i < n; i++) {
				var md:Modifier = elements.getItemAt(i) as Modifier;
				if (md is BooleanModifier) {
					var bmd:BooleanModifier = md as BooleanModifier;
					str += bmd.getXML().toString();
				}
				else if (md is QualitativeModifier) {
					var qlmd:QualitativeModifier = md as QualitativeModifier;
					str += qlmd.getXML().toString();
				}
				else {
					var qnmd:QuantitativeModifier = md as QuantitativeModifier;
					str += qnmd.getXML().toString();
				}
			}
			str += '</elements>';
			str += '</ThematicCondition>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML): void {
			this.attName = _xml.@attName.toString();
			this.attType = _xml.@attType.toString();
			
			elements = new ArrayList();
			var elementXMLList:XMLList = _xml.elements(BooleanModifier);
			if (elementXMLList != null) {
				for each (var element:XML in elementXMLList) {
					var bmd:BooleanModifier = new BooleanModifier();
					bmd.setXML(element);
					elements.addItem(bmd);
				}
				return;
			}
			
			elementXMLList = _xml.elements(QualitativeModifier);
			if (elementXMLList != null) {
				for each (element in elementXMLList) {
					var qlmd:QualitativeModifier = new QualitativeModifier();
					qlmd.setXML(element);
					elements.addItem(qlmd);
				}
				return;
			}
			
			elementXMLList = _xml.elements(QualitativeModifier);
			if (elementXMLList != null) {
				for each (element in elementXMLList) {
					var qnmd:QuantitativeModifier = new QuantitativeModifier();
					qnmd.setXML(element);
					elements.addItem(qnmd);
				}
			}
		}
	}
}