package math
{
	import dataTypes.theme.Bool;
	import dataTypes.spatialGeometry.Coordinate2;
	
	import mx.collections.ArrayList;

	public class Sort
	{
		public function Sort()
		{
		}
		
		/*
		Minimum point of lexicographic order (辞書式順序)
		the coordinate having minimum x value.
		If more than one minimum x values are exist, 
		then the condition is added such that the coordinate having minimum y-value
		will be the minimum.
		*/
		public static function lexicoMin(crds:ArrayList):Coordinate2 {
			var min:Coordinate2 = new Coordinate2();
			min.x = min.y = Number.MAX_VALUE;
			
			var crd:Coordinate2;
			
			var m:int = crds.length;
			for (var i:int = 0; i < m; i++) {
				crd = crds.getItemAt(i) as Coordinate2;
				if (min.x > crd.x) min = crd;
				else if (min.x == crd.x) {
					if (min.y > crd.y) min = crd;
				}
			}
			
			return min;
		}
		
		/*
		Sort records by the key-column. 
		Record in this case is an array of any value.
		However, data type of the key-column shall be Number.
		ordering: true = assending, false = dissending
		*/
		public static function sortRecords(records:ArrayList, keyColumn:int, ordering:Boolean = true):ArrayList {
			var answer:ArrayList = new ArrayList;
			var index:int;
			var m:int = records.length;
			var item:Array;
			
			if (ordering) {
				//assending
				for (var i:int = 0; i < m; i++) {
					index = getMinRecIndex(records, keyColumn);
					answer.addItem(records.getItemAt(index));
					records.removeItemAt(index);
					m--;
					i = -1; // Because of i++
				}
			} 
			else {
				//dissending
				for (i = 0; i < m; i++) {
					index = getMaxRecIndex(records, keyColumn);
					answer.addItem(records.getItemAt(index));
					records.removeItemAt(index);
					m--;
					i = -1;	// Because of i++
				}				
			}
			
			return answer;
		}
		
		public static function getMinRecIndex(records:ArrayList, keyColumn:int):int {
			var min:Number = Number.MAX_VALUE;
			var wrec:Array;
			var minIndex:int = -1;
			var m:int = records.length;
			for (var i:int = 0; i < m; i++) {
				wrec = records.getItemAt(i) as Array;
				if (min > wrec[keyColumn]) {
					min = wrec[keyColumn];
					minIndex = i;
				}
			}
			return minIndex;
		}
		
		public static function getMaxRecIndex(records:ArrayList, keyColumn:int):int {
			var max:Number = Number.MIN_VALUE;
			var wrec:Array;
			var maxIndex:int = -1;
			var m:int = records.length;
			for (var i:int = 0; i < m; i++) {
				wrec = records.getItemAt(i) as Array;
				if (max < wrec[keyColumn]) {
					max = wrec[keyColumn];
					maxIndex = i;
				}
			}
			return maxIndex;
		}

	}
}