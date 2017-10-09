package instanceModel
{
	import dataTypes.place.*;
	import dataTypes.spatialGeometry.*;
	import dataTypes.theme.*;
	
	import gfm.AttributeType;
	
	import mx.collections.ArrayList;
	import mx.utils.UIDUtil;
	import mx.controls.Alert;


	public class Attribute extends GeodataElement
	{
		public var id:String;
		public var attValueList:ArrayList;
		
		public function Attribute()
		{
			super();
			this.id = UIDUtil.createUID();
			attValueList = new ArrayList();
		}
		
		public function getXML(attType:AttributeType):XML {
			var strGeom:String = "";
			var strAddr:String = "";
			var strMemo:String = "";

			var str:String = "";
			var attValueList:ArrayList = this.attValueList as ArrayList;
			if (attValueList != null) {
				var n:int = attValueList.length;
				if (n > 0) {
					if (attType.dataType == "Integer" 	    || attType.dataType == "Real"				||
						attType.dataType == "Bool" 		    || attType.dataType == "CharacterString" 	||
						attType.dataType == "URL" 		    || attType.dataType == "ImageURL" 			||
						attType.dataType == "VideoURL"      || attType.dataType == "SoundURL") {
						str += '<Attribute typeName="' + attType.name + '" value="';
						var element:* = attValueList.getItemAt(0);
						str += element.value.toString();
						for (var j:int = 1; j < n; j++) {
							element = attValueList.getItemAt(j);
							str += ',' + element.value.toString();
						}
						str += '"/>';
					}
					else if (attType.dataType == "GDate") {
						var dte:GDate = attValueList.getItemAt(0) as GDate;	
						var t:Number = dte.value.getTime();
						str += '<Attribute typeName="' + attType.name + '" value="' + t + '"/>';
					}
					else if (attType.dataType == "Memo") {
						var memo:Memo = attValueList.getItemAt(0) as Memo;
						if (memo != null) {
							strMemo += '<Attribute typeName="' + attType.name + '" idref="';
							strMemo += memo.id;
							for (j = 1; j < n; j++) {
								memo = attValueList.getItemAt(j) as Memo;
								strMemo += ',' + memo.id;
							}
							strMemo += '"/>';								
						}
					}
					else if (attType.dataType == "Address") {
						var addr:Address = attValueList.getItemAt(0) as Address;
						if (addr != null) {
							strAddr += '<Attribute typeName="' + attType.name + '" idref="';
							strAddr += addr.id;
							for (j = 1; j < n; j++) {
								addr = attValueList.getItemAt(j) as Address;
								strAddr += ',' + addr.id;
							}
							strAddr += '"/>';
						}							
					}
					else {
						// Geometry
						var geom:SG_Object = attValueList.getItemAt(0) as SG_Object;
						if (geom != null) {
							strGeom += '<Attribute typeName="' + attType.name + '" idref="';
							strGeom += geom.id;
							for (j = 1; j < n; j++) {
								geom = attValueList.getItemAt(j) as SG_Object;
								strGeom += ',' + geom.id;
							}
							strGeom += '"/>';
						}
					}
				}
			}
			str += strAddr;
			str += strGeom;
			str += strMemo;
			
			return XML(str);
		}
		
		public function setXML(attXML:XML, attType:AttributeType, kit:Kit):ArrayList {
			if (attType.dataType == "SG_Point" ||
				attType.dataType == "SG_Curve" ||
				attType.dataType == "SG_Surface" ||
				attType.dataType == "SG_Complex"　||
				attType.dataType == "Address"  ||
				attType.dataType == "Memo") {
				
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
					return attList;
				}
				else {
					return null;
				}
			}
			else {
				attStr = attXML.attribute("value");
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
					return attList;
				}
			}
			return null;
		}
		
	}
}