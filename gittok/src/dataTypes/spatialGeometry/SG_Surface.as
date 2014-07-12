package dataTypes.spatialGeometry
{
	
	import flash.utils.Dictionary;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;

	public class SG_Surface extends SG_Primitive
	{	
		public var exterior:SG_Ring;
		public var interior:ArrayList;		// A set of rings
		
		public function SG_Surface()
		{
			super();
			exterior = new SG_Ring();
			interior = new ArrayList();
		}
		
		public override function getXML():XML {
			var str:String = '<SG_Surface>';
			
			str += '<inheritance>';
			str += super.getXML().toXMLString();
			str += '</inheritance>';
			
			str += '<exterior idref="' + exterior.id + '"/>';
			var m:int = interior.length;
			if (m > 0) {
				str += '<interior idref="';
				for (var i:int = 0; i < m; i++) {
					var r:SG_Ring = interior.getItemAt(i) as SG_Ring;
					str += r.id + ',';
				}
				str = str.substr(0, str.length - 1) + '" ';				
				str += '/>';
			}
			str += '</SG_Surface>';
			
			return XML(str);
		}
		
		public override function setXML(_xml:XML, kit:Kit = null):void {
			var ringList:Dictionary = kit.ringList;
						
			var strXMLList:XMLList = _xml.inheritance.children();
			var strXML:XML = strXMLList[0];
			
			super.setXML(strXML);
			
			var rid:String = _xml.exterior.@idref.toString();
			this.exterior = ringList[rid] as SG_Ring;	
						
			var str:String = _xml.interior.@idref;
			
			if (str == "") return;
			
			var elements:Array = str.split(',');
			for (var i:int = 0; i < elements.length; i++) {
				rid = elements[i];
				this.interior.addItem(ringList[rid] as SG_Ring);
			}

		}
		

	}
}