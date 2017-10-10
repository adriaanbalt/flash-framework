package com.balt.core.asset.css
{
/**
 * Class: StylesManager
 * 
 * 
 * Manages a group of CSS stylesheets allowing you to extract styles from any sheet based on an identifier. 
 * 
 * 
 * @langversion ActionScript 3.0
 * @playerversion Flash 9
 * @author	Thaylin D. Burns
 * @author  adriaan scholvinck
 * 
 */
	import com.balt.core.path.PathManager;
	import com.balt.events.GenericDataEvent;
	import com.balt.loaders.BulkLoaderUtil;
	
	import flash.events.ErrorEvent;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	public dynamic class StylesManager extends BulkLoaderUtil
	{
		/*------------------------
		/	CLASS VARIABLES
		/-----------------------*/
		private var _cssObjects : Array; 
		private var data : Object;
		private var pathManager : PathManager;
		
		public function StylesManager( $data:Object )
		{
			data = $data;
		}
		
		/**
		 * Method to retrieve the textFormat of a particular style residing within the styleSheet
		 * 
		 * @param style		A string parameter representing a style within the stylesheet
		 * @param id		A string param that designates which CSS file to read the style from
		 * @return TextFormat
		 */
		public function getTextFormat( style:String, id : String ):TextFormat
		{
			var tf : TextFormat;
			for ( var i : int = 0; i < getItems().length; i++ ) {
				if ( id == getItems()[i] ) {
					tf = getItems()[i].transform(getItems()[i].getStyle(style));
					break;
				}
			}
			return tf;
		}
		public function getStylesheet( id : String ):StyleSheet {
			var cssStyle : StyleSheet;
			for ( var i : int = 0; i < getItems().length; i++ ) {
				if ( id == getItems()[i] ) {
					cssStyle = getItems()[i].transform(getItems()[i].getStyle(style));
					break;
				}
			}
			return cssStyle;
		}
		
		public override function load(files:Array):void
		{
			var numOfFiles:int = files.length;
			
			for(var i:int = 0; i<numOfFiles; i++)
			{
				if(files[i] is StylesManagerItem)
				{
					addItem(files[i] as StylesManagerItem);
				}
				else
				{
					var item : StylesManagerItem = convertToStylesManagerItem(files[i]);
					if(item) addItem( item );
					else dispatchEvent(new GenericDataEvent(ErrorEvent.ERROR, false, false, files[i]));
				}
			}
		}
		
		private function convertToStylesManagerItem(obj:Object):StylesManagerItem
		{
			var item:StylesManagerItem;
			
			if(obj.hasOwnProperty("id") && obj.hasOwnProperty("url"))
			{
				item = new StylesManagerItem(obj.id, obj.url);
			}
			else dispatchEvent(new GenericDataEvent(ErrorEvent.ERROR, false, false, obj));
			
			return item;
		}
	}
}