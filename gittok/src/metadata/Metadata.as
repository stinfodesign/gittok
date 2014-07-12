package metadata
{
	import dataTypes.spatialGeometry.SG_Rectangle;
	import dataTypes.temporalGeometry.TG_Period;
	
	import flash.filesystem.File;
	
	import instanceModel.Kit;
	
	import mx.collections.ArrayList;

	public class Metadata
	{
		public var title:String;
		
		public var overview:String;
		
		public var keywords:ArrayList;
		
		public var responsibleParty:String;
		
		public var publicationDate:Date;
		
		public var geographicExtent:SG_Rectangle;
		
		//public var temporalExtent:TemporalExtent;
		
		public var kitURL:String;
		
		public function Metadata()
		{
			keywords   		 = new ArrayList();
			geographicExtent = new SG_Rectangle();
			//temporalExtent   = new TemporalExtent();
		}
		
		public function getXML():XML {
			var str:String = '<Metadata ';
			str += 'title="' + this.title + '" '
				+  'overview="' + this.overview + '" '
				+  'keywords="'
				
			var m:int = keywords.length;
			for (var i:int = 0; i < m; i++) {
				var key:String = this.keywords.getItemAt(i) as String;
				str += key + ',';
			}
			str = str.substr(0, str.length - 1) + '" ';
			
			str += 'responsibleParty="' + this.responsibleParty + '" '
				+  'publicationDate="' + this.publicationDate.getTime() + '" '
				+  'kitURL="' + this.kitURL + '">';
			
			str += '<geographicExtent>';
			str += this.geographicExtent.getXML().toXMLString();
			str += '</geographicExtent>';
			
			/*
			str += '<temporalExtent>';
			str += this.temporalExtent.getXML().toXMLString();
			str += '</temporalExtent>';
			*/
			
			str += '</Metadata>';
			
			return XML(str);	
		}
		
		public function setXML(_xml:XML):void {
			this.title = _xml.@title.toString();
			this.overview = _xml.@overview.toString();
			
			this.keywords = new ArrayList();
			var str:String = _xml.@keywords.toString();
			if (str != "") {
				var strArray:Array = str.split(',');
				var m:int = strArray.length;
				for (var i:int = 0; i < m; i++) {
					keywords.addItem(strArray[i] as String);	
				}
			}
			
			this.responsibleParty = _xml.@responsibleParty.toString();
			this.publicationDate = new Date(Number(_xml.@publicationDate));
			this.kitURL = _xml.@kitURL.toString();
			
			var strXMLList:XMLList = _xml.geographicExtent.children();
			this.geographicExtent.setXML(strXMLList[0]);
			
			/*
			strXMLList = _xml.temporalExtent.children();
			this.temporalExtent.setXML(strXMLList[0]);
			*/
		}
	}
}