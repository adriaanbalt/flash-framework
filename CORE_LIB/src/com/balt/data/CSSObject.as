package com.balt.data
{
/**
 * Class: CSSObject
 * 
 * Description: A dynamic class for parsing css data into a flash object to pull attributes for text and display objects.
 * With this class you can style not only text but also any attribute you want to pass to the display objects
 * 
 * @langversion ActionScript 3.0
 * @playerversion Flash 9
 * @author	Thaylin D. Burns
 *
 *
 *
 */
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	public dynamic class CSSObject extends EventDispatcher
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
		 * CSSObject constructor
		 * 
		 * @param file		A string parameter indicating the css file to retrieve
		 */
		public function CSSObject(file:String){
			_dispatcher = new EventDispatcher();
			retrieveCss(file);
		}
		/**
		 * Method to retrieve the the css from file passed in CSSObject constructor
		 * 
		 * @param f		String parameter indicating file to load
		 */
		private function retrieveCss(f:String):void{
			_loader = new URLLoader(new URLRequest(f));
			_loader.addEventListener(Event.COMPLETE, onLoad);
				
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
			
				for(var i:Number = 0; i<_cssStyle.styleNames.length; i++){
					var obj:String = new String(_cssStyle.styleNames[i])
					//create the dynamic object to reference based on the css node
					this[obj] = new Object();
					for(var prop:String in _cssStyle.getStyle(obj)){
	
						//now within the css node create the child object to set up the vars within the node
						var subObj:String = new String(prop);
						this[obj][subObj] = checkCss(_cssStyle.getStyle(obj)[prop]);
						// EDIT 1.2 - JF
						// Convert Array based CSS values to actual arrays
						try{
						if (this[obj][subObj].toString().indexOf('[') != -1) {
							// Remove brackets
							var tmpStr:String = this[obj][subObj].toString();
							
							tmpStr = tmpStr.substring(1,tmpStr.length - 1);
							var tmpArray:Array = tmpStr.split(',');
							
							// Assure properties witin array are valid css properties
							for (var j:Number = 0; j < tmpArray.length; j++){
								tmpArray[j] = checkCss(tmpArray[j]); // END for	
							}
							this[obj][subObj] = tmpArray;
						} // END if
						}catch(e:Error){
							
						}
					} // END for
				} // END for
			
			//since we've added a listener outside for this class to listen for this we'll now dispatch the event since everything it loaded and good.
			this.dispatchEvent(e);
			_loader.removeEventListener(Event.COMPLETE, onLoad)
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
	}
}