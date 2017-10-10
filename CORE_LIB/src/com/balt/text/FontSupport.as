package com.balt.text
{
	import com.balt.log.Log;
	
	import flash.text.Font;
	import flash.text.TextFormat;
	
	/**
	* Font information and manipulation utilities
	* 
	* @example
	* var targetClip:* = this;<br>
	*/	
	
	public class FontSupport
	{
		/**
		* @private
		*/
		
		public function FontSupport():void
		
		/**
		* Turns font embedding on or off based on the content of a textField object
		* 
		* @param txtObj Textfield or extended textfield object to be evaluated
		*/		
		public static function setFontEmbed( txtObj:Object, logPriority:int=Log.DEBUG ):void
		{			
			var txtArr:Array = txtObj.text.split(String.fromCharCode(13));	
			var txtStr:String = txtArr.join();
			var embedToggle:Boolean;
			var curFont:String;
			var embeddedFonts:Array = Font.enumerateFonts(false);
			embeddedFonts.sortOn("fontName", Array.CASEINSENSITIVE);
			
			for (var i:int=0; i < embeddedFonts.length; i++)
			{
				if (embeddedFonts[i].fontName == getFont(txtObj))
				{
					curFont = embeddedFonts[i].fontName;
					embedToggle = embeddedFonts[i].hasGlyphs(txtStr);
				}
			}

			Log.traceMsg( curFont + " Embedded: " + embedToggle, logPriority);
			txtObj.embedFonts = embedToggle;
		}		
		
		/**
		* Returns the name of the font used in a textfield object
		* 
		* @param txtObj Textfield or extended textfield object to be evaluated
		* @return Name of textfield object font
		*/		
		
		public static function getFont(txtObj:Object):String
		{
			if (txtObj) {
				var format:TextFormat = txtObj.getTextFormat();
				return format.font;
			} else {
				return null;
			}
		}
		
		/**
		* Creates system font list and sends it to trace output
		*/		
		
		public static function listSysFonts(verifyFontName:String=null, logPriority:int=Log.DEBUG, filter:String=null):Boolean
		{

			return listFonts(true, verifyFontName, logPriority, filter);
		}
		
		public static function listEmbeddedFonts(verifyFontName:String=null, logPriority:int=Log.DEBUG, filter:String=null):Boolean
		{
			return listFonts(false, verifyFontName, logPriority, filter);
		}
		
		public static function listAllFonts(verifyFontName:String=null, logPriority:int=Log.DEBUG, filter:String=null):Boolean
		{
			var foundIt:Boolean = false;
			foundIt = listSysFonts(verifyFontName, logPriority, filter);
			foundIt = foundIt || listEmbeddedFonts(verifyFontName, logPriority, filter);
			return foundIt;
		}
		
		private static function listFonts(enumerateDeviceFonts:Boolean, verifyFontName:String=null, logPriority:int=Log.DEBUG, filter:String=null):Boolean
		{
			var foundFont:Boolean = false;
			var font_array:Array = Font.enumerateFonts(enumerateDeviceFonts);
			font_array.sortOn("fontName", Array.CASEINSENSITIVE);
			
			for (var i:int=0; i < font_array.length; i++) {
				var thisFont:Font = font_array[i];
				
				// **************************************************************
				// *** BYPASS ALL OF THE ARGUMENTS AND JUST TRACE THE LIST!!! ***
				// **************************************************************
				if( verifyFontName==null && filter==null )
				{
					logPriority = Log.WARN;
					Log.traceMsg("Font " + i + ": Type: '" + "Name: '" + thisFont.fontName + "'   ", logPriority);
				}
				// **************************************************************
				// **************************************************************
				
				else
				{
					// Subselect those fonts matching the optional filter string
					if (!filter || (filter != null && TextUtil.stringContains(thisFont.fontName.toLowerCase(), filter.toLowerCase()))) {
						Log.traceMsg("Font " + i + ": Type: '" + "Name: '" + thisFont.fontName + "'          " +
										thisFont.fontType + "' Style: '" + thisFont.fontStyle + "'   ", logPriority);
					}
					if (verifyFontName && verifyFontName == thisFont.fontName) {
						foundFont = true;
					}
				}
			}
			if (i == 0) {
				Log.traceMsg("No fonts found for enumerateDeviceFonts: " + enumerateDeviceFonts, Log.traceThreshold);
			}
			if (verifyFontName) {
				if (foundFont) {
					Log.traceMsg("Font '" + verifyFontName + "' was found", Log.DEBUG);
				} else {
					Log.traceMsg("Font '" + verifyFontName + "' was NOT found", Log.ERROR);
				}
			}
			return foundFont;
		}
	}
}