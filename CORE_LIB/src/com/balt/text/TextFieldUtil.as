package com.balt.text
{	
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontType;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 
	 * <strong>Author</strong> Adriaan Scholvincnk
	 * 
	 * <p>
	 * The TextFieldUtil is used to format the flash.text.TextField. To use the TextFieldUtil, pass an instance of 
	 * Cascading Style Sheets (CSS) styles to style text fields, using <code>TextFeildUtil()</code> constructor.
	 * </p>
	 * 
	 * 
	 * <p>
	 * <strong>Version History</strong>
	 * 1.0 Created.
	 * 1.2 Fix inner html attribute one or more pairs to be supported.
	 * 1.3 Textformat tag support
	 * 1.4 Add configInput function.
	 * 1.5 Check if device font has gyphs
	 * </p>		
	 *
	 * @usage  <code>
	 * 				private function loadStyleSheet():void {
	 *					var nokiaStyleSheet:NokiaStyleSheet = new NokiaStyleSheet( _styleSheetPath );
	 *					nokiaStyleSheet.addEventListener( "cssLoaded", onStyleSheetLoaded, false, 0, true );
	 *				}
	 *				private function onStyleSheetLoaded( p_event:Event ):void {
	 *					_styleSheet = new StyleSheet();
	 *					_styleSheet = p_event.target.getTextStyle();
	 *					_textFieldUtil = new TextFieldUtil( _styleSheet );
	 *				}
	 * </code>
	 */
	public class TextFieldUtil
	{
		private var _version:		String = "1.3"
		private var _style_sheet:	StyleSheet;
		
		
		public function TextFieldUtil(p_ss:StyleSheet)
		{
			_style_sheet = p_ss;
		}
		
		/**
		 * setupTextBlock
		 * 
		 * @param p_tf				 	TextField you are going to display.
		 * @param p_text 				Text that is going to be display on the TextField.
		 * @param p_tagOrClassName		HTML tag name as "li" for <li> div class name as ".myDivClassName" for <div class=".myDivClassName"> for your CSS.
		 * @param p_autoSize			see TextFieldAutoSize class.
		 * @param p_multiline			is the multi lines of textfield?
		 * @param p_wordwrap			defalut is false.
		 * @param p_selectable			when user drag the textfild.
		 * @param p_antiAliasType		see AntiAliasType class.
		 * 
		 * @usage <code>
		 * 			setupTextBlock(my_tf, "my text", ".myClass");  // this doesn't have inner tag on the string
		 * 			setupTextBlock(my_tf, "my text <a href='http:\\www.google.com' class='.myInnerClass'>my inner a tag</a>", ".myParentClass");  // this is myInnerClass is going to work
		 * </code>
		 **/
		public function setupTextBlock(p_tf:TextField, 
									   p_text:String, 
									   p_tagOrClassName:String, 
									   p_autoSize:String = null, 
									   p_multiline:Boolean = false, 
									   p_wordWrap:Boolean = false,
									   p_selectable:Boolean = false, 
									   p_antiAliasType:String = null):void {
			
			var tagOrClassName:String = getAvailableCSS(p_tagOrClassName); 
			var prefix:String;
			var suffix:String;
			var htmlText:String;
			var ss:StyleSheet = new StyleSheet();
			var tagAtts:String = "";
			
			p_tf.selectable = p_selectable;
			if ( p_autoSize == null ) {
				p_tf.autoSize = TextFieldAutoSize.LEFT;
			} else {
				p_tf.autoSize = p_autoSize;
			}
			if ( p_antiAliasType == null ) {
				
				p_tf.antiAliasType = AntiAliasType.ADVANCED;
			}else {
				p_tf.antiAliasType = p_antiAliasType;
			}
			// for test
			//p_tf.antiAliasType = AntiAliasType.ADVANCED
			
			p_tf.multiline = p_multiline;
			p_tf.wordWrap = p_wordWrap;
			p_tf.gridFitType = GridFitType.PIXEL; // always
			//p_attDict = { blockindent:10, leading:2};
			/*
			if(p_attDict != null) {
				for(var prop:String in p_attDict) {
					tagAtts += " " + prop + "=" + "'" + p_attDict[prop] + "'";
				}
			}
			*/
			
			if(tagOrClassName.charAt(0) == ".") {
				// this tag is class name.
				var className:String = tagOrClassName.substr(1, tagOrClassName.length);
				prefix = "<span CLASS='"+className+"'" + tagAtts + ">";
				suffix = "</span>"
			}else {
				// html tag prefix
				prefix = "<" + tagOrClassName + tagAtts + ">";
				suffix = "</"+tagOrClassName+">";
			}
			
			//if there is tag inside of htmlText We need to stylelize that one too. 
			/* this regexp is modified with <
												/?\w+
													(
														(\s+
															\w+
																(\s*=\s*
																	(?:".*?"
																	|'.*?'
																	|[^'">\s]+
																	)
																)
															?)+\s*
															|\s*
														)
											/?>
			*/
			// http://haacked.com/archive/2004/10/25/UsingRegularExpressionsToMatchHTML.aspx 
			
			var htmlRegex:RegExp = /<(?P<tag>\w+)((\s+(?P<arg>\w+)\s*=\s*(\"(?P<value1>.*?)\"|'(?P<value2>.*?)'|(?P<value3>[^'\">\s]+))?)+\s*|\s*)?\/?>/img;
			var matchArray:Array = p_text.match(htmlRegex);
			
			for(var i:uint=0; i<matchArray.length; i++) {
				var arr:Array = new Array();
				var match:String;
				// not sure why I need to put space here.
				match = " " + matchArray[i] + " ";
				htmlRegex = /<(?P<tag>\w+)((\s+(?P<arg>\w+)\s*=\s*(\"(?P<value1>.*?)\"|'(?P<value2>.*?)'|(?P<value3>[^'\">\s]+))?)+\s*|\s*)?\/?>/img;
				arr = htmlRegex.exec( match );
				if(arr != null) {
					setStyle(arr.tag, tagOrClassName);
					if(String(arr.arg).toLowerCase() == "class") {
						if(arr.value1 != "") {
							setStyle("."+arr.value1, tagOrClassName);
						}else {
							setStyle("."+arr.value2, tagOrClassName);
						}
					}
				}
			}
			setStyle(tagOrClassName);
			
			htmlText = prefix+p_text+suffix;
			p_tf.htmlText = htmlText;
			
			function setStyle(p_p_tagOrClassName:String, p_parentTagOrClass:String = null):void {
				// check if there is css for this tagOrClassName.
				var obj:Object = _style_sheet.getStyle(p_p_tagOrClassName);
				obj = parseCSS(obj, p_text, p_parentTagOrClass);
				
				ss.setStyle(p_p_tagOrClassName, obj);
				p_tf.embedFonts = obj.isEmbed;
				p_tf.styleSheet = ss;
			}
			
//			p_tf.border = true; // debug
		}
		
		private function parseCSS(obj:Object, p_text:String ="", p_parentTagOrClass:String = null):Object {
			// cascade wrapped tag class property.
			if(p_parentTagOrClass != null) {
				var parentsObj:Object = _style_sheet.getStyle(p_parentTagOrClass);
				for(var parentsProp:String in parentsObj) {
					if(!isPropThereInThisTag(parentsProp, obj)){
						obj[parentsProp] = parentsObj[parentsProp];
					}
				}
			}
			
			var fontFamily:String = obj.fontFamily;
			var fontFamilyArray:Array = new Array();
			if(fontFamily != null) {
				fontFamilyArray = fontFamily.split(/,(\s){0,}/);
			}
			var font:Font;
			
			// check embeded font is available with this text.
			font = getAvailableFont(fontFamilyArray, false);
			
			var isEmbed:Boolean = true;
			if( font != null && font.hasGlyphs( stripLowCharacters( p_text ) ) ) 
            { 
                 obj.fontFamily = font.fontName; 
            } 
            else 
            { 
                 isEmbed = false; 
                 // embeded fonts are not available for these charactors.  
                 // need to us system fonts. 
                 font = getAvailableFont(fontFamilyArray, true, p_text); 
                 if( font != null ) 
                 { 
                     obj.fontFamily = font.fontName; 
                 } 
                 else 
                 { 
                      obj.fontFamily = "_sans"; 
                 } 
            } 
            obj.isEmbed = isEmbed;
			return obj;
			
			function isPropThereInThisTag(p_prop:String, p_obj:Object):Boolean {
				for(var prop:String in p_obj) {
					if(prop == p_prop) {
						return true
					}
				}
				return false;
			}
		}
		
		/**
		 * truncateTextBlock
		 * 
		 * it is pretty much same as setupTextBlock except it will truncate your string if the string width is longer 
		 * then your p_maxHeight or hight is higher then your p_maxHeight ( when you use p_multiline = true ).
		 * 
		 **/
		public function truncateTextBlock( p_tf: TextField, 
										   p_text: String, 
										   p_tagOrClassName:String,
										   p_maxWidth: Number, 
										   p_numOfLine: Number = NaN, 
										   p_maxHeight: Number = NaN, 
										   p_autoSize:String=null,
									   	   p_multiline:Boolean=false, p_selectable:Boolean=false,
									   	   p_antiAliasType:String = null ): Boolean
		{	
			var isTruncated:Boolean = false;
			var rawText: String = p_text;
			var truncatedText: String = p_text;
			
			setupTextBlock(p_tf, p_text, p_tagOrClassName, p_autoSize, 
						   p_multiline, p_multiline, p_selectable, p_antiAliasType);
						   
			var charRect:Rectangle;
			var index: Number = rawText.length;
			if( p_text.length > 0 )
			{
				if( p_multiline )
				{
					p_tf.width = p_maxWidth;
					charRect = p_tf.getCharBoundaries(0);
					var maxHeight: Number;
					if( isNaN( p_numOfLine ) == false )
					{
						maxHeight = ( p_numOfLine + 1 ) * charRect.height
					}
					else if( isNaN( p_maxHeight ) == false )
					{
						maxHeight = p_maxHeight;
					}
					
					if( isNaN( maxHeight ) == false )
					{
						while( p_tf.height >= maxHeight )
						{
							isTruncated = true;
							truncatedText = rawText.substr( 0, index -- ) + "...";
							setupTextBlock( p_tf, truncatedText, p_tagOrClassName, p_autoSize, 
									   	   p_multiline, p_multiline, p_selectable, p_antiAliasType );
						}
					}
				}
				else
				{
					while( p_tf.width > p_maxWidth )
					{
						isTruncated = true;
						truncatedText = rawText.substr( 0, index -- ) + "...";
						setupTextBlock( p_tf, truncatedText, p_tagOrClassName, p_autoSize, 
								   	   p_multiline, p_multiline, p_selectable, p_antiAliasType );
						
						if( index == 1 )
						{
							break;
						}
					}
				}
			}
			
			return isTruncated;
		}
		
		private function getAvailableFont(p_fonts:Array, p_onlySystemFonts:Boolean=false, p_txt:String = null):Font {
			var availableFonts:Array = Font.enumerateFonts(true);
			var fonts:Array = p_fonts
			var font:Font;
			for (var i:int=0; i<fonts.length; i++) {
				var fontName:String = fonts[i];
				for(var j:int=0; j<availableFonts.length; j++) {
					font = availableFonts[j];
					
					if( !p_onlySystemFonts || font.fontType == FontType.DEVICE ) {
						if(font.fontName == fontName) {
							// change for China issues 
							if ( p_txt != null ) {
								if (  font.hasGlyphs( stripLowCharacters( p_txt ) ) ) {
									return font;
								}
							} else {
								return font;
							}
						}
					}
				}
			}
			return null;
		}
		
		private function getAvailableCSS(p_tag:String):String {
			var isStyleAvailable:Boolean = false;
//			for (var i:int=0; i<_style_sheet.styleNames.length; i++) {
//				if(_style_sheet.styleNames[i] == p_tag.toLowerCase()) {
//					isStyleAvailable = true;
//					break;
//				}
//			}
			isStyleAvailable = _style_sheet.styleNames.indexOf( p_tag.toLowerCase() ) > -1;
			
			if(!isStyleAvailable) {
				var arr:Array = p_tag.split(".");
				if(arr.length > 1) {
					var parentsTag:String = "";
					for (var j:int=0; j<arr.length-1; j++) {
						if(j != 0) parentsTag += ".";
						parentsTag += arr[j];
					}
					return getAvailableCSS(parentsTag);
				}else {
					// return defalt tag.
					return "body";
				}
			}else {
				return p_tag;
			}
		}
		
		private function stripLowCharacters( p_text: String ): String
		{
			if( p_text == null )
			{
				return "";
			}
			
			var start: int = p_text.length - 1;
			for( var i: int = start; i >=0; i-- )
			{
				if( p_text.charCodeAt( i ) < 32  )
				{
					p_text = p_text.split( p_text.charAt( i ) ).join( " " );
				}
			}
			
			return p_text;
		}
		
		/**
		 * setupTextInput
		 * set up textFild that need to have user input. AS3 doesn't support stylesheet for user input textfield so
		 * you need to use this function instead of setupTextField, when you create text input field.
		 * 
		 * @param p_txtField 	TextField you are going to display.
		 * @param p_str 		Text that is going to be display on the TextField.
		 * @param p_restricted	String or Reguar Exprestion that will assign restirected charactors.
		 * @param p_maxChars	Maximum Charactor for input field
		 * @param p_tagName		CSS div tag name as a String to assign to the TextFormat object in this case.
		 * @param p_multiline	is the multi lines of textfield?
		 * @param p_wordwrap	defalut is false.
		 **/
		public function setupTextInput( p_txtField:TextField, p_str:String, p_restricted: String, p_maxChars: Number, 
									 	p_tagName:String = null, p_autoSize:String = null,
									 	p_multiline:Boolean = false, p_wordWrap:Boolean = false ): void
		{	
			var format:TextFormat = new TextFormat();
			var obj:Object = getCSSTextFormat(p_tagName);
			format = obj.format;
			
			p_txtField.embedFonts = obj.isEmbed;
			p_txtField.antiAliasType = AntiAliasType.ADVANCED;
			p_txtField.multiline = p_multiline;
			p_txtField.wordWrap = p_wordWrap;
			p_txtField.type = TextFieldType.INPUT;
			p_txtField.defaultTextFormat = format;
			
			p_txtField.restrict = p_restricted;
			
			if(p_restricted != null) { 
				if(p_restricted.length > 0){ 
					p_txtField.text = p_restricted.charAt( 0 );
				}
			} else {
				p_txtField.text = 'A';
			}
			var characterRect: Rectangle = p_txtField.getCharBoundaries( 0 )
			var height: Number = characterRect.height + characterRect.y + 1;
			p_txtField.height = height;	
			
			p_txtField.maxChars = p_maxChars;
			p_txtField.text = p_str;
		}
		
		/**
		 * getCSSTextFormat
		 * if you pass CSS (NokiaStyleSheet) tag name you will get Object that has format (TextFormat)
		 * 
		 * @param p_tag String CSS tag.
		 * @usage <code>
		 * 			var format:TextFormat = new TextFormat();
		 *		  	var obj:Object = getCSSTextFormat(p_tagName);
		 *			format = obj.format;
		 * 		  </code>
		 **/
		public function getCSSTextFormat( p_tag:String ):Object
		{
			var tagOrClassName:String = getAvailableCSS(p_tag); 
			var obj:Object = _style_sheet.getStyle(tagOrClassName);
			obj = parseCSS(obj);
			//var obj:Object = _style_sheet.getStyle(p_tag);
			var format:TextFormat = new TextFormat();
			if(obj.color != null)
				var colorNum:String = String(obj.color);
				if(beginsWith(colorNum, "#")){
					format.color =  colorNum.replace(/\#/, "0x");
				}
			if(obj.fontFamily != null) 
				format.font = obj.fontFamily;
			if(obj.fontSize != null) 
				format.size = obj.fontSize;
			if(obj.fontWeight != null) 
				format.bold = (obj.fontWeight == "bold");
			if(obj.fontStyle != null) 
				format.italic = (obj.fontStyle == "italic");
			var align:String;
			
			if(obj.textAlign != null) {
				if(obj.textAlign == "left") {
					align = TextFormatAlign.LEFT;
				}else if(obj.textAlign == "right") {
					align = TextFormatAlign.RIGHT;
				}else if (obj.textAlign == "center") {
					align = TextFormatAlign.CENTER;
				}
				format.align = align;
			} 
			if(obj.leading != null) {
				format.leading = obj.leading;
			}
			obj = {format:format, isEmbed:obj.isEmbed}
			return obj;
		}
		
		private function beginsWith (input:String, prefix:String):Boolean
		{
			return (prefix == input.substring(0, prefix.length));
		}
	}
}