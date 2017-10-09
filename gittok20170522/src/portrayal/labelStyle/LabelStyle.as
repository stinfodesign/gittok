package portrayal.labelStyle
{
	import flash.text.Font;
	
	import mx.utils.UIDUtil;

	public class LabelStyle
	{
		public var id:String;
		public var name:String;				// name of the label style
		public var font:String;				// font
		public var fontSize:Number;			// pixels
		public var bold:Boolean;			// bold: true
		public var color:uint;				// RGB color
		public var alpla:Number;			// transparency
		public var reference:int;			// 0:upper left ---- 8:lower right
		
		public function LabelStyle()
		{
			id = UIDUtil.createUID();
		}
		
		public function getXML():XML {
			var str:String = '<LabelStyle ';
			str += 'id="' + id + '" ';
			str += 'name="' + name + '" ';
			str += 'font="' + font + '" ';
			str += 'fontSize="' + fontSize + '" ';
			str += 'bold="' + bold + '" ';
			str += 'color="' + color + '" ';
			str += 'reference="' + reference + '" />';
			
			return XML(str);
		}
		
		public function setXML(_xml:XML):void {
			this.id = _xml.@id;
			this.name = _xml.@name;
			this.font = _xml.@font;
			this.fontSize = Number(_xml.@fontSize);
			this.bold = (_xml.@bold == "true") ? true: false;
			this.color = uint(_xml.@color);
			this.reference = int(_xml.@reference);	
		}
	}
}