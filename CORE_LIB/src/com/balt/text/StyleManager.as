package com.balt.text
{
/**
 * Class: StyleManager
 * 
 * A dynamic class for parsing css data into a flash object to pull attributes for text and display objects.
 * Once css is loaded the user can then retrieve the css classes by simply calling that class. 
 * Example:
 * 			<code>
 * 
 * 				//within css
 * 				//	cssClass
 * 				//	{
 * 				//		value1:true;
 * 				//		value2:#00FF00;
 * 				//		value3:0xFF0000;
 * 				//		value4: [#FF1212, 0xFFFFFF, 4, false];
 * 				//	}
 *				//	fontTest
 * 				//	{
 * 				//		font-family:Arial;
 * 				//		font-size:12pt;
 * 				//		font-weight:bold;
 * 				//		color:#63594C;
 * 				//	}
 * 				var style:StyleManager = new StyleManager(new URLRequest("assets/styles.css"));
 * 				style.addEventListener(Event.COMPLETE, handleCssLoad);
 * 
 * 				private function handleCssLoad(event:Event):void
 * 				{
 * 					var style:StyleManager = event.target as StyleManager;
 * 					trace(style.cssClass.value1); // returns Boolean
 * 					trace(style.cssClass.value2); // returns uint
 * 					trace(style.cssClass.value4); // returns Array
 * 				}
 * 
 * 				// Or pulling text format from css is just as easy. Remember to structure your css properly!
 * 				private function handleCssLoad(event:Event):void
 * 				{
 * 					var style:StyleManager = event.target as StyleManager;
 * 					var frmt:TextFormat = style.getTextFormat("fontTest");
 * 					trace(frmt.color);	//returns 6510924
 * 					trace(fmrt.font); 	//returns Arial
 * 					trace(frmt.size);	//returns 12
 * 				}				
 * 				
 * 			</code>
 * 
 * @langversion ActionScript 3.0
 * @playerversion Flash 9
 * @author	Thaylin D. Burns
 *
 *
 *
 */
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	
	public dynamic class StyleManager extends EventDispatcher
	{
		/*------------------------
		/	CLASS VARIABLES
		/-----------------------*/
		private var _loader:URLLoader;
		private var _dispatcher:EventDispatcher;
		private var _cssStyle:StyleSheet;
		
		/**
		 * Method to retrieve the textFormat of a particular style residing within the styleSheet
		 * 
		 * @param style		A string parameter representing a style within the stylesheet
		 * @return TextFormat
		 */
		public function getTextFormat(style:String):TextFormat
		{
			return _cssStyle.transform(_cssStyle.getStyle(style));
		}
		public function get stylesheet():StyleSheet { return this._cssStyle; }
		/**
		 * StyleManager constructor
		 * 
		 * @param file		A string parameter indicating the css file to retrieve
		 */
		public function StyleManager(urlRequest:URLRequest = null)//file:String)
		{
			_dispatcher = new EventDispatcher();
			
			if(urlRequest)retrieveCss(urlRequest);
			
		}
		public function load(urlRequest:URLRequest):void
		{
			retrieveCss(urlRequest);
		}
		public function get bytesLoaded():uint
		{
			return _loader.bytesLoaded;
		}
		public function get bytesTotal():uint
		{
			return _loader.bytesTotal;
		}
		private function retrieveCss(urlRequest:URLRequest):void
		{
			if(urlRequest.url)
			{
				_loader = new URLLoader(urlRequest);
				addListeners();
				
			}else if(urlRequest)
			{
				throw new Error(this+" :: URLRequests must contain the url property in order to load data for styles")
			}
		}
		private function handleLoadError(event:IOErrorEvent):void
		{
			dispatchEvent(event);
			removeListeners();
		}
		/**
		 * onLoad event triggered when the css file has loaded. Once loaded it creates dynamic variables that can be accessed outside of 
		 * class and then dispatches an event to inform caller of completion.
		 * 
		 * @param e		Event passed when data has loaded
		 */
		private function onLoad(e:Event):void{
			_cssStyle = new StyleSheet();
			_cssStyle.parseCSS(e.currentTarget.data)
			
			for each(var item:String in _cssStyle.styleNames)
			{
				this[item] = new Object();
				for(var property:String in _cssStyle.getStyle(item))
				{
					this[item][property] = checkCss(_cssStyle.getStyle(item)[property]);
					
					if (this[item][property].toString().indexOf('[') != -1) {
							// Remove brackets
							var tmpStr1:String = this[item][property].toString();
							
							tmpStr1 = tmpStr1.substring(1,tmpStr1.length - 1);
							var tmpArray1:Array = tmpStr1.split(',');
							
							// Assure properties witin array are valid css properties
							for (var k:Number = 0; k < tmpArray1.length; k++){
								tmpArray1[k] = removeLeadingWhitespace(tmpArray1[k]);
								tmpArray1[k] = checkCss(tmpArray1[k]);
							}
							this[item][property] = tmpArray1;
						}
				}
			}
			//since we've added a listener outside for this class to listen for this we'll now dispatch the event since everything is loaded and good.
			dispatchEvent(e);
			removeListeners();
		}
		/**
		 * Method used to check for issues within css such as hexidecimal colors or px within a number like a width or height.
		 * On finding these it converts to the neccessary data, be it a uint number (color) or a Number (sizes, positioning).
		 * Otherwise if nothing found, just returns back string passed in
		 * 
		 * @param col		String to check for issues
		 * @return *	Returns a type based on what data found.
		 */
		private function checkCss(col:String):*{
			if (col != null && col != '') {
				
				var myPattern:RegExp;
				if(col.search('#')==0){
					//if this is a hexidecimal code then replace with 0x and output a uint for color
					myPattern = /#/;
					col = col.replace(myPattern,'0x');
					return uint(col);
				}else if(col.search('px') != -1){
					//if this is a pixel position variable then kill the px and convert to number
					myPattern = /px/;
					col = col.replace(myPattern, '');
					return Number(col);
				}else if(!isNaN(Number(col))){
					return Number(col)
				}else{
					if(col=='true')return true;
					else if(col=='false')return false;
					//otherwise return the string as it came in
					else
					return col;
				}
			}
		}
		/**
		 * Strip leading and trailing whitespace from string  
		 * @param str
		 * @return 
		 * 
		 */		
		private function removeLeadingWhitespace(str:String):String
		{
			var reg : RegExp = /^(\s*)([\W\w]*)(\b\s*$)/;
			if ( reg.test(str) );
			str = str.replace(reg, '$2');
			return str;
		}
		private function addListeners():void
		{
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
			_loader.addEventListener(Event.COMPLETE, onLoad)
		}
		private function removeListeners():void
		{
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
			_loader.removeEventListener(Event.COMPLETE, onLoad)
		}
		public override function toString():String
		{
			return "[object StyleManager]";
		}
	}
}