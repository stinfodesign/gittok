package gfm
{
	import flash.utils.Dictionary;
	
	import instanceModel.Association;
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;

	public class FeatureType
	{
		public var name:String;					// type name
		public var definition:String			// feature type definition
		public var isAbstract:Boolean;			// abstract:true, concrete:false
		
		public var attributeTypes:ArrayList;	// of AttributeType
		public var operationTypes:ArrayList;	// of OperationType
		
		public var parent:FeatureType;			// parent feature type, if it is a child
		public var children:ArrayList;			// child feature types, if it is a parent
				
		public var links:ArrayList;				// to associations
		public var linkedBy:ArrayList;			// from associations
		
		public var proxyName:String;			// feature representative on maps or lists.
		
		public function FeatureType()
		{
			name = "";
			definition = "";
			isAbstract = false;
			
			attributeTypes	= new ArrayList();
			operationTypes	= new ArrayList();

			parent 		= null;
			children	= new ArrayList();

			links		= new ArrayList();
			linkedBy 	= new ArrayList();
			
			proxyName 		= "";
		}
		
		public function getAttributeTypeByName(attName:String):AttributeType {
			var aType:AttributeType;
			var n:int = attributeTypes.length;
			for (var i:int = 0; i < n; i++) {
				aType = attributeTypes.getItemAt(i) as AttributeType;
				if (aType.name == attName) {
					return aType;
				}
			}
			return null;
		}
		
		public function getOperationTypeByName(otName:String):OperationType {
			var oType:OperationType;
			var n:int = operationTypes.length;
			for (var i:int = 0; i < n; i++) {
				oType = operationTypes.getItemAt(i) as OperationType;
				if (oType.name == otName) {
					return oType;
				}
			}
			return null;
		}
		
		public function getProxyType():AttributeType {
			if (proxyName == "") return null;
			
			return getAttributeTypeByName(proxyName);
		}
		
		public function getXML():XML {
			var str:String 	= '<FeatureType name="' + this.name + '" '
							+ 'definition="' + this.definition + '" '
							+ 'isAbstract="' + this.isAbstract + '">';
			
			if (proxyName != "") {
				str += '<proxy idref="';
				str += proxyName;
				str += '" />';
			}
			else str += '<proxy/>';
			
			str += '<attributeTypes>';			
			var m:int = this.attributeTypes.length;
			for (var i:int = 0; i < m; i++) {
				var att:AttributeType = this.attributeTypes.getItemAt(i) as AttributeType;
				str += att.getXML().toXMLString();
			}
			str += '</attributeTypes>';
			
			str += '<operationTypes>';
			m = this.operationTypes.length;
			for (i = 0; i< m;i++) {
				var opt:OperationType = this.operationTypes.getItemAt(i) as OperationType;
				str += opt.getXML().toXMLString();
			}
			str += '</operationTypes>';
			
			str += (this.parent == null) ? '<parent/>': '<parent idref="' + this.parent.name + '"/>';
			
			str += '<children';
			m = this.children.length;
			if (m > 0) {
				str += ' idref="';
				for (i = 0; i < m; i++) {
					var ft:FeatureType = this.children.getItemAt(i) as FeatureType;
					str += ft.name + ',';
				}
				str = str.substr(0, str.length - 1) + '"';
			}
			str += '/>';
			
			str += '<links';
			m = this.links.length;
			if (m > 0) {
				str += ' idref="';
				for (i = 0; i < m; i++) {
					var ass:AssociationType = this.links.getItemAt(i) as AssociationType;
					str += ass.name + ',';
				}
				str = str.substr(0, str.length - 1) + '"';
			}
			str += '/>';
			
			str += '<linkedBy';
			m = this.linkedBy.length;			
			if (m > 0) {
				str += ' idref="';
				for (i = 0; i < m; i++) {
					ass = this.linkedBy.getItemAt(i) as AssociationType;
					str += ass.name + ','; 
				}
				str = str.substr(0, str.length - 1) + '"';
			}
			str += '/>';
				
			str += '</FeatureType>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit = null):void {
			// name
			this.name = _xml.@name;
			
			// definition
			this.definition = _xml.@definition;
			
			// isAbstract
			var b:String = _xml.@isAbstract.toXMLString();
			this.isAbstract = (b == "true") ? true: false;
			
			// attributeTypes
			this.attributeTypes = new ArrayList();
			var attXMLList:XMLList = _xml.attributeTypes.children();
			for each(var attXML:XML in attXMLList) {
				var attType:AttributeType = new AttributeType();
				attType.setXML(attXML);
				this.attributeTypes.addItem(attType);
			}
			
			// proxy
			this.proxyName = "";
			this.proxyName = _xml.proxy.@idref;
			
			// operationTypes
			this.operationTypes = new ArrayList();
			var opeXMLList:XMLList = _xml.operationTypes.children();
			for each(var opeXML:XML in opeXMLList) {
				var opeType:OperationType = new OperationType();
				opeType.setXML(opeXML);
				this.operationTypes.addItem(opeType);
			}
			
			/*
			It is impossible to put all contents except typeID in under types, 
			because only IDs are stored in XML. Other contents are stored at the 
			second step of setXML() provided by Application Schema
			*/
			
			// parent
			var prStr:String = _xml.parent.@idref;
			if (prStr != "") {
				this.parent = new FeatureType();
				this.parent.name = prStr;
			}
			
			// children
			var chlStr:String = _xml.children.@idref;
			if (chlStr != "") {
				this.children = new ArrayList();
				var chlArray:Array = chlStr.split(',');
				var m:int = chlArray.length;
				for (var i:int = 0; i < m; i++) {
					var ftType:FeatureType = new FeatureType();
					ftType.name = chlArray[i];
					this.children.addItem(ftType);
				}
			}
			
			// links
			var linkStr:String = _xml.links.@idref;
			if (linkStr != "") {
				this.links = new ArrayList();
				var linkArray:Array = linkStr.split(',');
				m = linkArray.length;
				for (i = 0; i < m; i++) {
					var assType:AssociationType = new AssociationType();
					assType.name = linkArray[i];
					this.links.addItem(assType);
				}
			}
			
			// linkedBy
			var linkedByStr:String = _xml.linkedBy.@idref;
			if (linkedByStr != "") {
				this.linkedBy = new ArrayList();
				var linkedByArray:Array = linkedByStr.split(',');
				m = linkedByArray.length;
				for (i = 0; i < m; i++) {
					assType = new AssociationType();
					assType.name = linkedByArray[i];
					this.linkedBy.addItem(assType);
				}
			}
			
			
		}
		
	}
}