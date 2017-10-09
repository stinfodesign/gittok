package instanceModel
{
	import dataTypes.place.*;
	import dataTypes.spatialGeometry.*;
	import dataTypes.theme.*;
	
	import flash.filesystem.*;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import flashx.textLayout.tlf_internal;
	
	import gfm.ApplicationSchema;
	import gfm.AttributeType;
	import gfm.FeatureType;
	
	import mx.collections.ArrayList;
	import mx.messaging.management.Attribute;
	import mx.utils.UIDUtil;
	
	public class Feature extends GeodataElement
	{
		public var id:String;
		public var attributes:Dictionary;
		public var connects:ArrayList;			// an array of associations with different types
		public var connectedBy:ArrayList;
		
		public function Feature()
		{
			//this.id = UIDUtil.createUID();
			this.id = UIDUtil.getUID(this);
			
			attributes  = new Dictionary();	
			connects    = new ArrayList();
			connectedBy = new ArrayList();
		}
		
		public function hasAttributes():Boolean {
			for each (var att:instanceModel.Attribute in attributes) {
				if (att != null) {
					if (att.attValueList.length > 0) return true;
				}
			}
			return false;
		}
		
		public function getXML(fType:FeatureType):XML {
			var str:String 	= '<Feature id="' + this.id + '" ';
			str += 'typeName="' + fType.name + '">';
			
			var attributeTypes:ArrayList = fType.attributeTypes;
			var m:int = attributeTypes.length;
			
			str += '<attributes>';
			for (var i:int = 0; i < m; i++) {
				var attType:AttributeType = attributeTypes.getItemAt(i) as AttributeType;
				var att:instanceModel.Attribute = new instanceModel.Attribute();
				att.attValueList = this.attributes[attType.name] as ArrayList;
				str += att.getXML(attType).toXMLString();
			}
			str += '</attributes>';	
			
			str += '<connects';
			m = connects.length;
			if (m > 0) {
				str += ' idref="';
				for (i = 0; i < m; i++) {
					var a:Association = connects.getItemAt(i) as Association;
					str += a.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"';
				
			}
			str += '/>';
			
			str += '<connectedBy';
			m = connectedBy.length;
			if (m > 0) { 
				str += ' idref="';
				for (i = 0; i < m; i++) {
					a = connectedBy.getItemAt(i) as Association;
					str += a.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"';
			}
			str += '/>';
			
			str += '</Feature>';
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit):void {
			var appSchema:ApplicationSchema = kit.applicationSchema;
			
			this.id = _xml.@id.toString();
			
			var attXMLList:XMLList = _xml.attributes.children();
			//trace(attXMLList[0].toXMLString());
			
			this.typeName = _xml.@typeName.toString();
			var fType:FeatureType = appSchema.featureTypes[this.typeName] as FeatureType;

			this.attributes = new Dictionary();
			var m:int = fType.attributeTypes.length;
			
			for (var i:int = 0; i < m; i++) {
				var attType:AttributeType = fType.attributeTypes.getItemAt(i) as AttributeType;
				var name:String = attType.name;
				for (var j:int = 0; j < attXMLList.length(); j++) {
					var nm:String = attXMLList[j].@typeName.toString();
					if (name == nm) {
						var att:instanceModel.Attribute = new instanceModel.Attribute();
						var attArrayList:ArrayList = att.setXML(attXMLList[j],attType, kit);	
						this.attributes[attType.name] = attArrayList;
					}
				}
			}
		}
	}
}