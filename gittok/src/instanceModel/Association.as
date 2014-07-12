package instanceModel
{
	import dataTypes.place.*;
	import dataTypes.simpleDataTypes.*;
	import dataTypes.spatialGeometry.*;
	
	import flash.filesystem.*;
	import flash.utils.Dictionary;
	
	import gfm.*;
	
	import mx.collections.ArrayList;
	import mx.utils.UIDUtil;
	

	public class Association
	{	
		public var typeName:String;			// association type name
		
		public var id:String;
		public var attributes:Dictionary;
		public var relateFrom:ArrayList;	// arrayList of from features
		public var relateTo:ArrayList;		// arrayList of to features
		
		public function Association()
		{
			this.id = UIDUtil.createUID();
			this.attributes = new Dictionary();
			this.relateFrom = new ArrayList();
			this.relateTo   = new ArrayList();
		}
		
		public function getXML(aType:AssociationType):XML {
			var str:String 	= '<Association id="' + this.id + '" ';
			str += 'typeName="' + aType.name + '"';
					
			var strGeom:String = '';
			var strAddr:String = "";
			var m:int = aType.attributeTypes.length;
			for (var i:int = 0; i < m; i++) {
				var attType:AttributeType  = aType.attributeTypes.getItemAt(i) as AttributeType;
				var attValueList:ArrayList = this.attributes[attType.name] as ArrayList;
				if (attValueList != null) {
					var n:int = attValueList.length;
					if (n > 0) {
						if (attType.dataType == "Integer" 		|| attType.dataType == "Real"				||
							attType.dataType == "Bool" 			|| attType.dataType == "CharacterString" 	||
							attType.dataType == "URL" 			|| attType.dataType == "ImageLocation" 		||
							attType.dataType == "VideoLocation"	|| attType.dataType == "SoundLocation"		||
							attType.dataType == "Memo") {
							str += ' ' + attType.name + '="';
							var element:* = attValueList.getItemAt(0);
							str += element.value.toString();
							for (var j:int = 1; j < n; j++) {
								element = attValueList.getItemAt(j);
								str += ',' + element.value.toString();
							}
							str += '"';
						}
						else if (attType.dataType == "Address") {
							element = attValueList.getItemAt(0);
							if (element != null) {
								strAddr += '<' + attType.name + ' idref="';
								strAddr += element;
								for (j = 1; j < n; j++) {
									element = attValueList.getItemAt(j);
									strAddr += ',' + element;
								}
								strAddr += '"/>';
							}							
						}
						else {
							element = attValueList.getItemAt(0);
							if (element != null) {
								strGeom += '<' + attType.name + ' idref="';
								strGeom += element;
								for (j = 1; j < n; j++) {
									element = attValueList.getItemAt(j);
									strGeom += ',' + element;
								}
								strGeom += '"/>';
							}
						}
					}
				}
			}
			
			str += '>';
			str += strAddr;
			str += strGeom;
			
			str += '<relateFrom idref="';
			m = relateFrom.length;
			for (i = 0; i < m; i++) {
				var fromFt:Feature = relateFrom.getItemAt(i) as Feature;
				str += fromFt.id + ',';
			}
			str = str.substr(0, str.length - 1) + '"/>';		// cut the last ','.
			
			str += '<relateTo idref="';
			m = relateTo.length;
			for (i = 0; i < m; i++) {
				var toFt:Feature = relateTo.getItemAt(i) as Feature;
				str += toFt.id + ',';
			}
			str = str.substr(0, str.length - 1) + '"/>';		// cut the last ','.
			
			str += '</Association>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit = null):void {
			var appSchema:ApplicationSchema = kit.applicationSchema;
			
			this.id = _xml.@id.toString();
			var tn:String = _xml.@typeName.toString();
			var aType:AssociationType = appSchema.associationTypes[tn] as AssociationType;

			this.attributes = new Dictionary();
			var m:int = aType.attributeTypes.length;
			
			for (var i:int = 0; i < m; i++) {
				var attType:AttributeType = aType.attributeTypes.getItemAt(i) as AttributeType;
				this.attributes[attType.name] = new ArrayList();
			}
			
			for (i = 0; i < m; i++) {
				attType = aType.attributeTypes.getItemAt(i) as AttributeType;
				var attStr:String = _xml.attribute(attType.name);
				if (attStr != "") {
					var attArray:Array = attStr.split(",");
					var attList:ArrayList = new ArrayList();
					var n:int = attArray.length;
					for ( var j:int = 0; j < n; j++) {
						var value:* = attArray[j];
						if (attType.dataType == "Integer") {
							var ii:Integer = new Integer();
							ii.value = int(value);
							attList.addItem(ii);
						}
						else if (attType.dataType == "Real") {	
							var r:Real = new Real();
							r.value = Number(value);
							attList.addItem(r);
						}
						else if (attType.dataType == "Boolean") {	
							var b:Bool = new Bool();
							b.value = Boolean(value);
							attList.addItem(b);
						}
						else if (attType.dataType == "Image") {
							var img:ImageURL = new ImageURL();
							img.value = value;
							attList.addItem(img);
						}
						else if (attType.dataType == "Video") {
							var vdo:VideoURL = new VideoURL();
							vdo.value = value;
							attList.addItem(vdo);
						}
						else if (attType.dataType == "CharacterString") {
							var chr:CharacterString = new CharacterString();
							chr.value = value;
							attList.addItem(chr);
						}
						else if (attType.dataType == "Memo") {
							var mm:Memo = new Memo();
							mm.value = value;
							attList.addItem(mm);
						}

					}
					this.attributes[attType.name] = attList;
				}
			}
			
			for (i = 0; i < m; i++) {
				attType = aType.attributeTypes.getItemAt(i) as AttributeType;
				var attXMLList:XMLList = _xml.child(attType.name);
				if (attXMLList.length() > 0) {
					attStr = attXMLList[0].@idref.toString();
					var attIDArray:Array = attStr.split(',');
					n = attIDArray.length;
					var attID:String;
					for (j = 0; j < n; j++) {
						attID = attIDArray[j];
						if (attType.dataType == "SG_Point"	 ||
							attType.dataType == "SG_Curve" 	 ||
							attType.dataType == "SG_Surface" ||
							attType.dataType == "SG_Complex" ||
							attType.dataType == "Address") {
							this.attributes[attType.name].addItem(attID);
						}
					}
				}
			}
			
			var fromAtt:String = _xml.relateFrom.@idref;
			var fromIDArray:Array = fromAtt.split(',');
			m = fromIDArray.length;
			for (i = 0; i < m; i++) {
				var frid:String = fromIDArray[i].toString();
				var fromf:Feature = kit.featureList[frid] as Feature;
				fromf.connects.addItem(this);
				this.relateFrom.addItem(fromf);
				kit.featureList[frid] = fromf;
			}
			
			var toAtt:String = _xml.relateTo.@idref;
			var toIDArray:Array = toAtt.split(',');
			m = toIDArray.length;
			for (i = 0; i < m; i++) {
				var tid:String = toIDArray[i].toString();
				var tof:Feature = kit.featureList[tid] as Feature;
				tof.connectedBy.addItem(this);
				this.relateTo.addItem(tof);
				kit.featureList[tid] = tof;
			}
			
		}
	}
		
}