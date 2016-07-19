package gfm
{
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;

	public class AssociationType 
	{
		
		public var name:String;					// type name
		public var definition:String			// it will be used in near future! -----------------
		
		public var attributeTypes:ArrayList;	// of AttributeType
		public var operationTypes:ArrayList;	// of OperationType
		
		public var style:String;				// association or composition
		public var roleName:String;
		public var correspondence:String;		// "1:1", "1:n", "m:1", or "m:n"
		public var from:FeatureType;
		public var to:FeatureType;
		
		public function AssociationType()
		{
			name = "";
			definition = "";
			
			attributeTypes	= new ArrayList();
			operationTypes	= new ArrayList();

			from = new FeatureType();
			to = new FeatureType();
			correspondence = "1:1";
		}
		
		public function getXML():XML {
			var str:String 	= '<AssociationType name="' + this.name + '" '
							+ 'definition="' + this.definition + '" '
							+ 'correspondence="' + this.correspondence + '">';

			
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
			
			str += '<from idref="' + from.name + '"/>';
			
			str += '<to roleName="' + this.roleName + '" '
					+ 'style="' + this.style + '" '
					+ 'idref="' + to.name + '"/>';
			
			str += '</AssociationType>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit=null):void {
			// name
			this.name = _xml.@name;
			
			// definition
			this.definition = _xml.@definition;
			
			// correspondence
			this.correspondence = _xml.@correspondence;
			
			// attributeTypes
			this.attributeTypes = new ArrayList();
			var attXMLList:XMLList = _xml.attributeTypes.children();
			for each(var attXML:XML in attXMLList) {
				var attType:AttributeType = new AttributeType();
				attType.setXML(attXML);
				this.attributeTypes.addItem(attType);
			}
			
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
			
			// from
			this.from.name = _xml.from.@idref;
			
			// to
			this.to.name = _xml.to.@idref;
			this.style = _xml.to.@style;
			this.roleName = _xml.to.@roleName;

		}
	}
}