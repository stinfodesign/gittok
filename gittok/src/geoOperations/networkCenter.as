package geoOperations
{
	import dataTypes.spatialGeometry.*;
	import dataTypes.theme.*;
	
	import flash.utils.Dictionary;
	
	import math.*;
	
	import mx.collections.ArrayList;
	
	public class networkCenter
	{
		public function networkCenter()
		{
		}
		
		public static function getCenter(argObj:Object):SG_Point {
			//initialization
			var ap:AffineParam = argObj["affineParam"] as AffineParam;
			
			var verteces:ArrayList = argObj["verteces"] as ArrayList;
			var edges:ArrayList    = argObj["edges"] as ArrayList;
			
			var m:int = verteces.length;
			
			var vertexDic:Dictionary = new Dictionary();
			for (var i:int = 0; i < m; i++) {
				var vArray:ArrayList = verteces.getItemAt(i) as ArrayList;
				var p:SG_Point = vArray.getItemAt(0) as SG_Point;
				vertexDic[p.id] = i;
			}
			
			var d:Array = new Array(m);
			for (i = 0; i < m; i++) {
				d[i] = new Array(m);
				for (var j:int = 0; j < m; j++) {
					d[i][j] = Number.MAX_VALUE;
					if (i == j) d[i][j] = 0.0;
				}
			}
			
			for (i = 0; i < m; i++) {
				vArray = verteces.getItemAt(i) as ArrayList;
				p = vArray.getItemAt(0) as SG_Point;
				var vIndex:int = vertexDic[p.id];
				var n:int = p.goOut.length;
				for (j = 0; j < n; j++) {
					var e:SG_Curve = p.goOut.getItemAt(j) as SG_Curve;
					var argObj4CurveLength:Object = new Object();
					argObj4CurveLength["affineParam"] = ap;
					var curves:ArrayList = new ArrayList();
					curves.addItem(e);
					var curvesArray:ArrayList = new ArrayList();
					curvesArray.addItem(curves);
					argObj4CurveLength["curve"] = curvesArray;
					var curveLength:Real = Length.lengthOfCurve(argObj4CurveLength);
					var eid:String = e.end.id;
					d[vIndex][vertexDic[eid]] = curveLength.value;
					d[vertexDic[eid]][vIndex] = curveLength.value;
				}
			}
			
			
			// Path initilization
			var path:Array = new Array(m);
			for (i = 0; i < m; i++) {
				path[i] = new Array(m);
				for (j = 0; j < m; j++) {
					path[i][j] = "";
				}
			}
			
			// WarshallFloyd			
			for (var k:int = 0; k < m; k++) {
				for (i = 0; i < m; i++) {
					var flag:Boolean = false;
					for (j = 0; j < m; j++) {
						if (d[i][j] > (d[i][k] + d[k][j])) {
							d[i][j] = d[i][k] + d[k][j];
							path[i][j] = path[i][k] + " " + k + " " + path[k][j];
						}
					}
				}
			}
			
			for (i = 0; i < m; i++) {
				for (j = 0; j < m; j++) {
					trace("i:" + i + " j:" + j + " " + path[i][j]);
				}
			}			
			
			// Get potentials
			var potentials:Array = new Array(m);
			for (i = 0; i < m; i++) {
				potentials[i] = 0.0;
				for (j = 0; j < m; j++) {
					potentials[i] += d[i][j];
				}
			}
			
			// Place of the Least potential
			var least:Number = Number.MAX_VALUE;
			var leastNo:int;
			for (i = 0; i < m; i++) {
				if (least > potentials[i]) {
					least = potentials[i];
					leastNo = i;
				}
			}
			trace("least:" + leastNo);
			vArray = verteces.getItemAt(leastNo) as ArrayList;
			p = vArray.getItemAt(0) as SG_Point;			
			
			return p;
		}
	}
}