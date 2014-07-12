package instanceModel
{
	import coordinateReference.CRS;
	
	import dataTypes.place.Address;
	import dataTypes.spatialGeometry.*;
	
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import gfm.*;
	
	import math.Affine;
	import math.AffineParam;
	import math.Angle;
	import math.GaussKruger;
	import math.Matrix;
	
	import mx.collections.ArrayList;
	
	
	public class Kit
	{
		//application schema
		public var applicationSchemaURL:String;
		
		//base map image
		public var baseMapImageURL:String;		// url of the image
		
		//Coordinate reference system for the conversion from/to geodetic coordinate.
		public var crsURL:String;					// url of the CRS definition file
		
		//affine parameters for conversion from screen to ground plane coordinates
		public var affineParam:AffineParam;
		
		//feature
		public var featureSetArray:Dictionary;	//index: Feature Type Name, element: featureSet

		//association
		public var associationSetArray:Dictionary;
		
		//geometry attributes
		public var pointList:Dictionary;
		public var curveList:Dictionary;
		public var surfaceList:Dictionary;
		public var complexList:Dictionary;
				
		public var orientableCurveList:Dictionary;
		public var ringList:Dictionary;
		
		//address
		public var addressList:Dictionary;
		
		// list of feature and association instances
		public var featureList:Dictionary;
		public var associationList:Dictionary;
		
		private var xml:XML;
		
		public var kitURL:String;
		public var applicationSchema:ApplicationSchema;
		

		
		public function Kit()
		{
			featureSetArray     = new Dictionary();
			associationSetArray = new Dictionary();
			
			featureList			= new Dictionary(); 
			associationList		= new Dictionary();
			
			pointList   		= new Dictionary();
			curveList   		= new Dictionary();
			surfaceList 		= new Dictionary();
			complexList			= new Dictionary();
			orientableCurveList = new Dictionary();
			ringList			= new Dictionary();
			
			addressList			= new Dictionary();
			
			/*
			you cannot create affine param, 
			because geometry window ask if it exists or not.
			*/
			
			// General Feature Model
			registerClassAlias("gfm.AttributeType", AttributeType);
			registerClassAlias("gfm.OperationType", OperationType);
			registerClassAlias("gfm.FeatureType", FeatureType);
			registerClassAlias("gfm.AssociationType", AssociationType);
			registerClassAlias("gfm.ApplicationSchema", ApplicationSchema);	
			registerClassAlias("gfm.ArgAttPair", ArgAttPair);

		}
		
		public function screenToLocalPlane():Coordinate2 {

			var origin:Coordinate2 = new Coordinate2();
			origin.x = -Number.MAX_VALUE;
			origin.y =  Number.MAX_VALUE;				
			
			//convert coordinate and get origin point
			//pointList
			for each(var p:SG_Point in pointList) {
				var coor:Coordinate2 = p.position;
				p.position = math.Affine.conversion(coor, affineParam.coefficient);
				if (p.position.x > origin.x) origin.x = p.position.x;
				if (p.position.y < origin.y) origin.y = p.position.y;
			}
			//curveList
			for each(var c:SG_Curve in curveList) {
				var coorArray:CoordinateArray = c.shape;
				if (coorArray != null) {
					var m:int = coorArray.length;
					for (var i:int = 0; i < m; i++) {
						coor = coorArray.getItemAt(i) as Coordinate2;
						coor = math.Affine.conversion(coor, affineParam.coefficient);
						coorArray.setItemAt(coor, i);
						if (coor.x > origin.x) origin.x = coor.x;
						if (coor.y < origin.y) origin.y = coor.y;
					}
					c.shape = coorArray;
				}
			}
			
			//shift to local plane coodinate and 
			//cross-change coordinate elements, because direction of x in plane coordinate is north
			//pointList
			var ce:Number;
			for each(p in pointList) {
				p.position.x = origin.x - p.position.x;
				p.position.y -= origin.y;
				ce = p.position.x;
				p.position.x = p.position.y;
				p.position.y = ce;
			}
			//curveList
			for each(c in curveList) {
				coorArray = c.shape;
				if (coorArray != null) {
					m = coorArray.length;
					for (i = 0; i < m; i++) {
						coor = coorArray.getItemAt(i) as Coordinate2;
						coor.x = origin.x - coor.x;
						coor.y -= origin.y;
						ce = coor.x;
						coor.x = coor.y;
						coor.y = ce;
						coorArray.setItemAt(coor, i);
					}
					c.shape = coorArray;
				}
			}
			return origin;
		}
		
		public function planeCoordinateTransfer(s:Number, center:Coordinate2, shift:Coordinate2):void {
			for each(var p:SG_Point in pointList) {
				p.position.x = s * (p.position.x - center.x) + shift.x;
				p.position.y = s * (p.position.y - center.y) + shift.y;
			}
			
			//curveList
			for each(var c:SG_Curve in curveList) {
				var coorArray:CoordinateArray = c.shape;
				
				if (coorArray != null) {
					var m:int = coorArray.length;
					for (var i:int = 0; i < m; i++) {
						var coor:Coordinate2 = coorArray.getItemAt(i) as Coordinate2;
						coor.x = s * (coor.x - center.x) + shift.x;
						coor.y = s * (coor.y - center.y) + shift.y;
						coorArray.setItemAt(coor, i);
					}
					c.shape = coorArray;
				}
			}			
		}
		
		public function screenToPlane():void {
			//pointList
			var coor:Coordinate2;
			for each(var p:SG_Point in pointList) {
				coor = p.position;
				coor = math.Affine.conversion(coor, affineParam.coefficient);
				p.position.x = coor.x;
				p.position.y = coor.y;
				
			}
			//curveList
			for each(var c:SG_Curve in curveList) {
				var coorArray:CoordinateArray = c.shape;
				if (coorArray != null) {
					var m:int = coorArray.length;
					for (var i:int = 0; i < m; i++) {
						coor = coorArray.getItemAt(i) as Coordinate2;
						coor = math.Affine.conversion(coor, affineParam.coefficient);
						coorArray.setItemAt(coor, i);
					}
					c.shape = coorArray;
				}
			}			
		}
		
		public function screenToGeodetic(crs:CRS):void {
			var gk:GaussKruger = new GaussKruger();
			gk.setParameters(crs);
			
			//pointList
			for each(var p:SG_Point in pointList) {
				var coor:Coordinate2 = p.position;
				coor = math.Affine.conversion(coor, affineParam.coefficient);
				var gc:GeodeticCoordinate = gk.XYtoBL(coor);
				p.position.x = math.Angle.radToDecimal(gc.lat);
				p.position.y = math.Angle.radToDecimal(gc.lon);

			}
			//curveList
			for each(var c:SG_Curve in curveList) {
				var coorArray:CoordinateArray = c.shape;
				if (coorArray != null) {
					var m:int = coorArray.length;
					for (var i:int = 0; i < m; i++) {
						coor = coorArray.getItemAt(i) as Coordinate2;
						coor = math.Affine.conversion(coor, affineParam.coefficient);
						gc = gk.XYtoBL(coor);
						coor.x = math.Angle.radToDecimal(gc.lat);
						coor.y = math.Angle.radToDecimal(gc.lon);
						coorArray.setItemAt(coor, i);
					}
					c.shape = coorArray;
				}
			}
		}
		

		
		public function planeToScreen():void {
			for each(var p:SG_Point in pointList) {
				var coor:Coordinate2 = p.position;
				p.position = math.Affine.inverseConversion(coor, affineParam.coefficient);
			}
			
			for each(var c:SG_Curve in curveList) {
				var coorArray:CoordinateArray = c.shape;
				if (coorArray != null) {
					var m:int = coorArray.length;
					for (var i:int = 0; i < m; i++) {
						coor = coorArray.getItemAt(i) as Coordinate2;
						coor = math.Affine.inverseConversion(coor, affineParam.coefficient);
						coorArray.setItemAt(coor, i);
					}
					c.shape = coorArray;
				}
			}
		}
		
		
		public function geodeticToScreen(crs:CRS):void {
			var gk:GaussKruger = new GaussKruger();
			gk.setParameters(crs);
			
			/* Get inverse affine parameter
			var c4i:Array = affineParam.coefficient;
			c4i[0][2] = c4i[1][2] = 0;
			c4i[2][2] = 1;
			*/
			
			//pointList
			for each(var p:SG_Point in pointList) {
				var coor:Coordinate2 = p.position;
				coor.x = math.Angle.decimalToRad(coor.x); // lat
				coor.y = math.Angle.decimalToRad(coor.y); // lon
				var pc:PlaneRectangularCoordinate = gk.BLtoXY(coor);
				coor.x = pc.x;
				coor.y = pc.y;
				p.position = math.Affine.inverseConversion(coor, affineParam.coefficient);
			}
			//curveList
			for each(var cv:SG_Curve in curveList) {
				var coorArray:CoordinateArray = cv.shape;
				if (coorArray != null) {
					var m:int = coorArray.length;
					for (var i:int = 0; i < m; i++) {
						coor = coorArray.getItemAt(i) as Coordinate2;
						coor.x = math.Angle.decimalToRad(coor.x);
						coor.y = math.Angle.decimalToRad(coor.y);						
						pc = gk.BLtoXY(coor);
						coor.x = pc.x;
						coor.y = pc.y;
						coor = math.Affine.inverseConversion(coor, affineParam.coefficient);
						coorArray.setItemAt(coor, i);
					}
					cv.shape = coorArray;
				}
			}
		}
		
		public function getGeographicExtent():SG_Rectangle {
			var lowerLeft:Coordinate2  = new Coordinate2();
			var upperRight:Coordinate2 = new Coordinate2();
			lowerLeft.x  = lowerLeft.y  = Number.MAX_VALUE;
			upperRight.x = upperRight.y = Number.MIN_VALUE;
			
			//Point extent
			for each (var p:SG_Point in pointList) {
				if (lowerLeft.x > p.position.x) lowerLeft.x   = p.position.x;
				if (lowerLeft.y > p.position.y) lowerLeft.y   = p.position.y;
				if (upperRight.x < p.position.x) upperRight.x = p.position.x;
				if (upperRight.y < p.position.y) upperRight.y = p.position.y;				
			}
			
			//Curve extent
			for each (var c:SG_Curve in curveList) {
				var cArray:CoordinateArray = c.coordinateSeqence();
				var m:int = cArray.length;
				var crd:Coordinate2;
				for (var i:int = 0; i < m; i++) {
					crd = cArray.getItemAt(i) as Coordinate2;
					if (lowerLeft.x > crd.x) lowerLeft.x   = crd.x;
					if (lowerLeft.y > crd.y) lowerLeft.y   = crd.y;
					if (upperRight.x < crd.x) upperRight.x = crd.x;
					if (upperRight.y < crd.y) upperRight.y = crd.y;				
				}
			}
			
			//Surface extent
			for each (var s:SG_Surface in surfaceList) {
				var sArray:CoordinateArray = s.exterior.coordinateSequence();
				m = sArray.length;
				for (i = 0; i < m; i++) {
					crd = sArray.getItemAt(i) as Coordinate2;
					if (lowerLeft.x > crd.x) lowerLeft.x   = crd.x;
					if (lowerLeft.y > crd.y) lowerLeft.y   = crd.y;
					if (upperRight.x < crd.x) upperRight.x = crd.x;
					if (upperRight.y < crd.y) upperRight.y = crd.y;				
				}				
			}
			
			//create extent
			var extent:SG_Rectangle = new SG_Rectangle();
			extent.lowerLeft  = lowerLeft;
			extent.upperRight = upperRight;
			
			return extent;
		}
		
		public function getCenter():Coordinate2 {
			var center:Coordinate2 = new Coordinate2();
			
			// Get extent
			var extent:SG_Rectangle = this.getGeographicExtent();
			
			var horizon:Number  = extent.upperRight.x - extent.lowerLeft.x;
			var vertical:Number = extent.upperRight.y - extent.lowerLeft.y;
			
			center.x = horizon  * 0.5 + extent.lowerLeft.x;
			center.y = vertical * 0.5 + extent.lowerLeft.y;	
			
			return center;
			
		}
		
		public function getXML():XML {
			var str:String = '<Kit';
			str += ' applicationSchemaURL="' + applicationSchemaURL + '"';
			str += ' baseMapImageURL="' + baseMapImageURL + '"';
			if (crsURL == null)
				str += ' crsURL="">';
			else 
				str += ' crsURL="' + crsURL +'">';
			
			str += '<affineParam>';
			if (affineParam != null)
				str += affineParam.getXML().toXMLString();
			str += '</affineParam>';
						
			str += '<featureSetArray>';
			for each(var fSet:FeatureSet in this.featureSetArray) {
				str += fSet.getXML();
			}
			str += '</featureSetArray>';
			
			str += '<associationSetArray>';
			for each(var aSet:AssociationSet in this.associationSetArray) {
				str += aSet.getXML();
			}
			str += '</associationSetArray>';
			
			str += '<pointList>';
			for each(var pt:SG_Point in this.pointList) {
				str += pt.getXML();
			}
			str += '</pointList>';
			
			str += '<curveList>';
			for each(var cv:SG_Curve in this.curveList) {
				str += cv.getXML();
			}
			str += '</curveList>';
			
			str += '<surfaceList>';
			for each(var sf:SG_Surface in this.surfaceList) {
				str += sf.getXML();
			}
			str += '</surfaceList>';
			
			str += '<complexList>';
			for each(var cp:SG_Complex in this.complexList) {
				str += cp.getXML();
			}
			str += '</complexList>';
			
			str += '<orientableCurveList>';
			for each(var oc:SG_OrientableCurve in this.orientableCurveList) {
				str += oc.getXML();
			}
			str += '</orientableCurveList>';
			
			str += '<ringList>';
			for each(var rg:SG_Ring in this.ringList) {
				str += rg.getXML();
			}
			str += '</ringList>';
			
			str += '<addressList>';
			for each(var addrsObj:* in this.addressList) {
				var addrs:Address = new Address();
				
				if (addrsObj is Object) {
					addrs.country = addrsObj["country"];
					addrs.element = addrsObj["element"];
					addrs.id = addrsObj["id"];
					addrs.zipCode = addrsObj["zipCode"];
				}
				else addrs = addrsObj as Address;
				
				str += addrs.getXML().toXMLString();
			}
			str += '</addressList>';
			
			var fTypes:Dictionary = applicationSchema.featureTypes;
			var aTypes:Dictionary = applicationSchema.associationTypes;
			var fType:FeatureType;
			var aType:AssociationType;
			
			str += '<featureList>';
			for each(var ft:Feature in this.featureList) {
				fType = fTypes[ft.typeName] as FeatureType;
				str += ft.getXML(fType).toXMLString();
			}
			str += '</featureList>';

			str += '<associationList>';
			for each(var asso:Association in this.associationList) {
				aType = aTypes[asso.typeName] as AssociationType;
				str += asso.getXML(aType).toXMLString();
			}
			str += '</associationList>';

			str += '</Kit>';
			
			return XML(str);
			
		}
		
		/*
		private function constructConcreteTypes():void {
			//Initialize concrete (non abstract) types
			concreteTypes = new ArrayList();
			for each(var ftType:FeatureType in applicationSchema.featureTypes) {				
				if (!ftType.isAbstract) 
					concreteTypes.addItem(ftType);
			}
			
			//Inherit properties from parent types, if required.
			var n:int = concreteTypes.length;
			for (var i:int = 0; i < n; i++) {
				atts 	= new ArrayList();
				opts 	= new ArrayList();
				concreteType = concreteTypes.getItemAt(i) as FeatureType;
				if (!concreteType.isAbstract) {
					// collect attrubute and association types
					atts.addAll(concreteType.attributeTypes);
					opts.addAll(concreteType.operationTypes);
					if (concreteType.parent != null) inheritProperties(concreteType.parent);
					concreteType = concreteTypes.getItemAt(i) as FeatureType;
					concreteType.attributeTypes = atts;
					concreteType.operationTypes = opts;
				}
			}
						
		}
		
		// Recursive operation to inherit properties
		protected function inheritProperties(fType:FeatureType):void {
			var m:int = fType.attributeTypes.length;
			var n:int = atts.length;
			var watts:ArrayList = new ArrayList();
			for (var i:int = 0; i < m; i++) {
				var wattf:AttributeType = fType.attributeTypes.getItemAt(i) as AttributeType;
				var flag:Boolean = false;
				for (var j:int = 0; j < n; j++) {
					var watt:AttributeType = atts.getItemAt(j) as AttributeType;
					if (watt.name == wattf.name) flag = true;
				}
				if (!flag) watts.addItem(wattf);
			}
			atts.addAll(watts);
			
			m = fType.operationTypes.length;
			n = opts.length;
			var wopts:ArrayList = new ArrayList();
			for (i = 0; i < m; i++) {
				var woptf:OperationType = fType.operationTypes.getItemAt(i) as OperationType;
				flag = false;
				for (j = 0; j < n; j++) {
					var wopt:OperationType = opts.getItemAt(j) as OperationType;
					if (wopt.name == woptf.name) flag = true;
				}
				if (!flag) wopts.addItem(woptf);
			}
			
			opts.addAll(wopts);
			
			if (fType.parent != null) {
				inheritProperties(fType.parent);
			}
		}

		*/
		
		public function setXML(_xml:XML):void {
			xml = _xml;
			//application schema
			this.applicationSchemaURL  = _xml.@applicationSchemaURL;
								
			//backgraound image
			this.baseMapImageURL	= xml.@baseMapImageURL;
		
			// coordinate reference system
			var crsURL:String = xml.@crsURL.toString();
			if (crsURL == "") 
				this.crsURL = "";
			else
				this.crsURL = crsURL;
		
			//affine paramaters
			var xmlList:XMLList = xml.affineParam.children();
			if (xmlList[0] != null) {
				this.affineParam = new AffineParam();
				this.affineParam.setXML(xmlList[0]);
			}
			//point list
			this.pointList = new Dictionary();
			var ptXMLList:XMLList = xml.pointList;
			var ptListXML:XMLList = ptXMLList[0].child("SG_Point");
			for each(var ptXML:XML in ptListXML) {
				var pt:SG_Point = new SG_Point();
				pt.setXML(ptXML);
				this.pointList[pt.id] = pt;
			}
		
			//curve list
			this.curveList = new Dictionary();
			var cvXMLList:XMLList = xml.curveList;
			var cvListXML:XMLList = cvXMLList[0].child("SG_Curve");
			for each(var cvXML:XML in cvListXML) {
				var cv:SG_Curve = new SG_Curve();
				cv.setXML(cvXML, this);
				this.curveList[cv.id] = cv;
			}
		
			//orientable curve list
			this.orientableCurveList = new Dictionary();
			var ocvXMLList:XMLList = xml.orientableCurveList;
			var ocvListXML:XMLList = ocvXMLList[0].child("SG_OrientableCurve");
			for each(var ocvXML:XML in ocvListXML) {
				var ocv:SG_OrientableCurve = new SG_OrientableCurve();
				ocv.setXML(ocvXML, this);
				this.orientableCurveList[ocv.id] = ocv; 
			}
		
			//ring list
			this.ringList = new Dictionary();
			var rgXMLList:XMLList = xml.ringList;
			var rgListXML:XMLList = rgXMLList[0].child("SG_Ring");
			for each(var rgXML:XML in rgListXML) {
				var rg:SG_Ring = new SG_Ring();
				rg.setXML(rgXML, this);
				this.ringList[rg.id] = rg; 
			}
		
			//surface list
			this.surfaceList = new Dictionary();
			var sfXMLList:XMLList = xml.surfaceList;
			var sfListXML:XMLList = sfXMLList[0].child("SG_Surface");
			for each(var sfXML:XML in sfListXML) {
				var sf:SG_Surface = new SG_Surface();
				sf.setXML(sfXML, this);
				this.surfaceList[sf.id] = sf; 
			}
		
			//complex list
			this.complexList = new Dictionary();
			var cpXMLList:XMLList = xml.complexList;
			var cpListXML:XMLList = cpXMLList[0].child("SG_Complex");
			for each(var cpXML:XML in cpListXML) {
				var cp:SG_Complex = new SG_Complex();
				cp.setXML(cpXML, this);
				this.complexList[cp.id] = cp; 
			}
		
			//addressList
			this.addressList = new Dictionary();
			var adXMLList:XMLList = xml.addressList;
			var adListXML:XMLList = adXMLList[0].child("Address");
			for each(var adXML:XML in adListXML) {
				var ad:Address = new Address();
				ad.setXML(adXML);
				this.addressList[ad.id] = ad;
			}
		
			//featureList
			this.featureList = new Dictionary();
			var fListXML:XMLList = xml.featureList.children();
			for each(var fXML:XML in fListXML) {
				var typeName:String = fXML.@typeName.toString();
				var fType:FeatureType = applicationSchema.featureTypes[typeName] as FeatureType;
				var f:Feature = new Feature();
				f.typeName = fType.name;
				f.setXML(fXML, this);
				this.featureList[f.id] = f; 
			}
		
			//feature set array
			this.featureSetArray = new Dictionary();
			var ftSetXMLList:XMLList	= xml.featureSetArray;
			var ftSetListXML:XMLList = ftSetXMLList[0].FeatureSet;			
			for each(var ftSetXML:XML in ftSetListXML) {
				var featureSet:FeatureSet = new FeatureSet();
				featureSet.setXML(ftSetXML, this);
				featureSetArray[featureSet.typeID] = featureSet;
			}
		
			// association list
			this.associationList = new Dictionary();
			var assListXML:XMLList = xml.associationList.children();
			for each(var assXML:XML in assListXML) {
				typeName = assXML.@typeName.toString();
				var aType:AssociationType = applicationSchema.associationTypes[typeName] as AssociationType;
				var ass:Association = new Association();
				ass.typeName = aType.name;
				ass.setXML(assXML, this);
				this.associationList[ass.id] = ass; 
			}
		
			//association set array
			this.associationSetArray = new Dictionary();
			var assSetXMLList:XMLList	= xml.associationSetArray;
			var assSetListXML:XMLList = assSetXMLList[0].AssociationSet;			
			for each(var assSetXML:* in assSetListXML) {
				var associationSet:AssociationSet = new AssociationSet();
				associationSet.setXML(assSetXML, this);
				associationSetArray[associationSet.typeID] = associationSet;
			}

		}

	}
}