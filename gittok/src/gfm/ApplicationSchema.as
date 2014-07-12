package gfm
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import gfm.FeatureType;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;

	public class ApplicationSchema
	{
		public var featureTypes:Dictionary;
		public var associationTypes:Dictionary;
		
		private var concreteType:FeatureType;
		private var concreteTypes:ArrayList;
		private var atts:ArrayList;
		private var opts:ArrayList;
		private var lnks:ArrayList;
		private var lnkBy:ArrayList;
		
		public function ApplicationSchema()
		{
			featureTypes = new Dictionary();
			associationTypes = new Dictionary();
		}
		
		public function constructConcreteTypes():ArrayList {
			//Initialize concrete (non abstract) types
			concreteTypes = new ArrayList();
			for each(var ftType:FeatureType in this.featureTypes) {				
				if (!ftType.isAbstract) 
					concreteTypes.addItem(ftType);
			}
			
			//Inherit properties from parent types, if required.
			var n:int = concreteTypes.length;
			for (var i:int = 0; i < n; i++) {
				atts 	= new ArrayList();
				opts 	= new ArrayList();
				lnks	= new ArrayList();
				lnkBy	= new ArrayList();
				concreteType = concreteTypes.getItemAt(i) as FeatureType;
				if (!concreteType.isAbstract) {
					// collect attrubute and association types
					atts.addAll(concreteType.attributeTypes);
					opts.addAll(concreteType.operationTypes);
					lnks.addAll(concreteType.links);
					lnkBy.addAll(concreteType.linkedBy);
					if (concreteType.parent != null) inheritProperties(concreteType.parent);
					concreteType = concreteTypes.getItemAt(i) as FeatureType;
					concreteType.attributeTypes = atts;
					concreteType.operationTypes = opts;
					concreteType.links          = lnks;
					concreteType.linkedBy       = lnkBy;
				}
			}
			
			return concreteTypes;
		}
		
		// Recursive operation to inherit properties
		protected function inheritProperties(fType:FeatureType):void {
			// attributes
			var m:int = fType.attributeTypes.length;
			var n:int = atts.length;
			var watts:ArrayList = new ArrayList();
			for (var i:int = 0; i < m; i++) {
				var wattf:AttributeType = fType.attributeTypes.getItemAt(i) as AttributeType;
				var flag:Boolean = false;
				for (var j:int = 0; j < n; j++) {
					var watt:AttributeType = atts.getItemAt(j) as AttributeType;
					// override
					if (watt.name == wattf.name) flag = true;
				}
				if (!flag) watts.addItem(wattf);
			}
			atts.addAll(watts);
			
			// operations
			m = fType.operationTypes.length;
			n = opts.length;
			var wopts:ArrayList = new ArrayList();
			for (i = 0; i < m; i++) {
				var woptf:OperationType = fType.operationTypes.getItemAt(i) as OperationType;
				flag = false;
				for (j = 0; j < n; j++) {
					var wopt:OperationType = opts.getItemAt(j) as OperationType;
					// override
					if (wopt.name == woptf.name) flag = true;
				}
				if (!flag) wopts.addItem(woptf);
			}
			
			opts.addAll(wopts);
			
			/* associations without override
			lnks.addAll(fType.links);
			lnkBy.addAll(fType.linkedBy);
			*/
			
			if (fType.parent != null) {
				inheritProperties(fType.parent);
			}
		}		
		
		public function getXML():XML {
			var str:String = '<ApplicationSchema>';
			
			str += '<featureTypes>';
			for each(var ftType:FeatureType in featureTypes) {
				str += ftType.getXML();
			}
			str += '</featureTypes>';
			
			str += '<associationTypes>';
			for each(var assType:AssociationType in associationTypes) {
				str += assType.getXML();
			}
			str += '</associationTypes>';
			str += '</ApplicationSchema>';
			
			return XML(str);
			
		}
		
		public function setXML(_xml:XML):void {

			// feature types
			this.featureTypes = new Dictionary();
			var ftTypes:XMLList = _xml.featureTypes.children();
			for each(var ftTypeXML:XML in ftTypes) {
				var ftType:FeatureType = new FeatureType();
				ftType.setXML(ftTypeXML);
				this.featureTypes[ftType.name] = ftType;
			}
			
			// Parent and children of a feature type
			for each(var fType:FeatureType in this.featureTypes) {
				// parent
				if (fType.parent != null) fType.parent = this.featureTypes[fType.parent.name];
				
				// children
				if (fType.children != null) {
					var ffType:FeatureType = new FeatureType();
					var m:int = fType.children.length;
					for (var i:int = 0; i < m; i++) {
						ffType = fType.children.getItemAt(i) as FeatureType;
						fType.children.setItemAt(this.featureTypes[ffType.name], i);
					}
				}
			}
						
			// association types
			this.associationTypes = new Dictionary();
			var assTypes:XMLList = _xml.associationTypes.children();
			for each(var assTypeXML:XML in assTypes) {
				var assType:AssociationType = new AssociationType();
				assType.setXML(assTypeXML);
				
				assType.from = this.featureTypes[assType.from.name];
				assType.to   = this.featureTypes[assType.to.name]; 
				
				this.associationTypes[assType.name] = assType;
				
			}
						
			// links and linkedBy of a feature type
			for each(fType in this.featureTypes) {
				// links
				if (fType.links != null) {
					var asType:AssociationType = new AssociationType();
					m = fType.links.length;
					for (i = 0; i < m; i++) {
						asType = fType.links.getItemAt(i) as AssociationType;
						fType.links.setItemAt(this.associationTypes[asType.name], i);
					}					
				}
			
				// linkedBy
				if (fType.links != null) {
					asType = new AssociationType();
					m = fType.linkedBy.length;
					for (i = 0; i < m; i++) {
						asType = fType.linkedBy.getItemAt(i) as AssociationType;
						fType.linkedBy.setItemAt(this.associationTypes[asType.name], i);
					}					
				}
			}
		}
		
	}
}