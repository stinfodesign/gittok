package instanceModel
{
	import dataTypes.place.*;
	import dataTypes.spatialGeometry.*;
	import dataTypes.theme.*;
	
	import flash.filesystem.*;
	import flash.utils.Dictionary;
	
	import gfm.*;
	
	import mx.collections.ArrayList;
	import mx.utils.UIDUtil;
	

	public class Association extends GeodataElement
	{	
		public var id:String;
		public var attributes:Dictionary;	// key: attribute name, velue: should be attribute id not value! 2017.03.26
		public var relateFrom:ArrayList;	// arrayList of from features
		public var relateTo:ArrayList;		// arrayList of to features
		
		public function Association()
		{
			this.id = UIDUtil.createUID();
			this.attributes = new Dictionary();
			this.relateFrom = new ArrayList();
			this.relateTo   = new ArrayList();
		}
		
		public function getXML(assoType:AssociationType):XML {
			var str:String 	= '<Association id="' + this.id + '" ';
			str += 'typeName="' + assoType.name + '">';
			
			var attributeTypes:ArrayList = assoType.attributeTypes;
			var m:int = assoType.attributeTypes.length;
			
			str+= '<attributes>';
			for (var i:int = 0; i < m; i++) {
				var attType:AttributeType  = attributeTypes.getItemAt(i) as AttributeType;
				var att:instanceModel.Attribute = new instanceModel.Attribute();
				att.attValueList = this.attributes[attType.name] as ArrayList;
				str += att.getXML(attType).toXMLString();
			}
			str += '</attributes>';
			
			m = relateFrom.length;
			if (m == 0) {
				str += '<relateFrom />';
			}
			else {
				str += '<relateFrom idref="';
				for (i = 0; i < m; i++) {
					var fromFt:Feature = relateFrom.getItemAt(i) as Feature;
					str += fromFt.id + ',';
				}
				str = str.substr(0, str.length - 1) + '"/>';		// cut the last ','.
			}
			
			m = relateTo.length;
			if (m == 0) {
				str += '<relateTo />';
			}
			else {
				str += '<relateTo idref="';
				for (i = 0; i < m; i++) {
					var toFt:Feature = relateTo.getItemAt(i) as Feature;
					str += toFt.id + ',';
				}
				
				str = str.substr(0, str.length - 1) + '"/>';		// cut the last ','.
			}
			
			str += '</Association>';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML, kit:Kit = null):void {
			var appSchema:ApplicationSchema = kit.applicationSchema;
				
			this.id = _xml.@id.toString();
				
			var attXMLList:XMLList = _xml.attributes.children();
			//trace(attXMLList[0].toXMLString());

			this.typeName = _xml.@typeName.toString();
			var assoType:AssociationType = appSchema.associationTypes[this.typeName] as AssociationType;
				
			this.attributes = new Dictionary();
			var m:int = assoType.attributeTypes.length;
			
			for (var i:int = 0; i < m; i++) {
				var attType:AttributeType = assoType.attributeTypes.getItemAt(i) as AttributeType;
				var name:String = attType.name;
				for (var j:int = 0; j < attXMLList.length(); j++) {
					var nm:String = attXMLList[j].@typeName.toString();
					if (name == nm) {
						var att:instanceModel.Attribute = new instanceModel.Attribute();
						this.attributes[attType.name] = att.setXML(attXMLList[j],attType, kit);						
					}
				}
			}
				/*
				if (attType.dataType == "SG_Point" ||
					attType.dataType == "SG_Curve" ||
					attType.dataType == "SG_Surface" ||
					attType.dataType == "SG_Complex"　||
					attType.dataType == "Address"  ||
					attType.dataType == "Memo") {
					
					var attXMLList:XMLList = _xml.child(attType.name);
					if (attXMLList.length() > 0) {
						var attXML:XML = attXMLList[0];
						var attStr:String = attXML.@idref.toString();
						if (attStr != "") {
							var attArray:Array = attStr.split(",");
							var attList:ArrayList = new ArrayList();
							var n:int = attArray.length;
							for ( var j:int = 0; j < n; j++) {
								var attID:String = attArray[j];
								if (attType.dataType == "SG_Point")
									attList.addItem(kit.pointList[attID] as SG_Point);
								if (attType.dataType == "SG_Curve")
									attList.addItem(kit.curveList[attID] as SG_Curve);
								if (attType.dataType == "SG_Surface")
									attList.addItem(kit.surfaceList[attID] as SG_Surface);
								if (attType.dataType == "SG_Complex")
									attList.addItem(kit.complexList[attID] as SG_Complex);
								if (attType.dataType == "SG_OrientableCurve")
									attList.addItem(kit.complexList[attID] as SG_OrientableCurve);	
								if (attType.dataType == "SG_Ring")
									attList.addItem(kit.complexList[attID] as SG_Ring);								
								if (attType.dataType == "Address")
									attList.addItem(kit.addressList[attID] as Address);
								if (attType.dataType == "Memo")
									attList.addItem(kit.memoList[attID] as Memo);
							}
							var att:Attribute = new Attribute();
							att.attValueList = attList;
							this.attributes[attType.name] = att;
						}
					}
				}
				else {
					attStr = _xml.attribute(attType.name);
					if (attStr != "") {
						attArray = attStr.split(",");
						attList = new ArrayList();
						n = attArray.length;
						for (j = 0; j < n; j++) {
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
							else if (attType.dataType == "Bool") {	
								var b:Bool = new Bool();
								b.value = Boolean(value);
								attList.addItem(b);
							}
							else if (attType.dataType == "ImageURL") {
								var img:ImageURL = new ImageURL();
								img.value = value;
								attList.addItem(img);
							}
							else if (attType.dataType == "VideoURL") {
								var vdo:VideoURL = new VideoURL();
								vdo.value = value;
								attList.addItem(vdo);
							}
							else if (attType.dataType == "SoundURL") {
								var snd:SoundURL = new SoundURL();
								snd.value = value;
								attList.addItem(snd);
							}
							else if (attType.dataType == "URL") {
								var url:URL = new URL();
								url.value = value;
								attList.addItem(url);
							}	
							else if (attType.dataType == "CharacterString") {
								var chr:CharacterString = new CharacterString();
								chr.value = value;
								attList.addItem(chr);
							}
							else if (attType.dataType == "GDate") {
								var dte:GDate = new GDate();
								var ds:String = value as String;
								dte.value = new Date();
								dte.value.setTime(Number(ds));
								attList.addItem(dte);
							}
							
						}
						att = new Attribute();
						att.attValueList = attList;
						this.attributes[attType.name] = att;
					}
				}				

			}
			*/
				
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