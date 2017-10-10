package com.balt.core.text
{
	import com.balt.core.log.Log;
	
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	*	@author Aaron Clinger
	*	@version 10/14/08
	*/	

	public class BaseTextField extends TextField
	{
		protected var _isAutoSizeLeft:Boolean;
		protected var _disableAutoSizeFix:Boolean;
		
		public function BaseTextField()
		{
			super();
			
			this.color             = 0x000000;
			this.selectable        = false;
			this.multiline         = true;
			this.wordWrap          = true;
			this.mouseWheelEnabled = false;
			this.autoSize          = TextFieldAutoSize.LEFT;
			this.antiAliasType     = AntiAliasType.ADVANCED;
		}
		
		override public function set htmlText(value:String):void
		{
			if (!this._isAutoSizeLeft)
			{
				super.htmlText = value;
				return;
			}
			
			super.autoSize = TextFieldAutoSize.LEFT;
			super.htmlText = value;
			
			if (this._disableAutoSizeFix) return;
			
			var autoWidth:Number  = this.width;
			var autoHeight:Number = this.height;
			
			super.autoSize = TextFieldAutoSize.NONE;
			
			this.width  = autoWidth;
			this.height = autoHeight;
		}
		
		override public function set text(value:String):void
		{
			if (!this._isAutoSizeLeft)
			{
				super.text = value;
				return;
			}
			
			super.autoSize = TextFieldAutoSize.LEFT;
			super.text     = value;
			
			if (this._disableAutoSizeFix) return;
			
			var autoWidth:Number  = this.width;
			var autoHeight:Number = this.height;
			
			super.autoSize = TextFieldAutoSize.NONE;
			
			this.width  = autoWidth;
			this.height = autoHeight;
		}
		
		override public function set autoSize(value:String):void
		{
			this._isAutoSizeLeft = (value == TextFieldAutoSize.LEFT) ? true : false;
		}
		
		public function disableAutoSizeFix():void
		{
			this._disableAutoSizeFix = true;
		}
		
		public function alignCenter():void
		{
			this.align = TextFormatAlign.CENTER;
		}
		
		public function alignRight():void
		{
			this.align = TextFormatAlign.RIGHT;
		}
		
		public function antiAliasNormal():void
		{
			this.antiAliasType = AntiAliasType.NORMAL;
		}
		
		public function autoEmbed():void
		{
			var txtArr:Array = this.text.split(String.fromCharCode(13));	
			var txtStr:String = txtArr.join();
			var embedToggle:Boolean;
			var curFont:String;
			var embeddedFonts:Array = Font.enumerateFonts(false);
			embeddedFonts.sortOn("fontName", Array.CASEINSENSITIVE);
			
			for (var i:int=0; i < embeddedFonts.length; i++)
			{
				if (embeddedFonts[i].fontName == getFont(this))
				{
					curFont = embeddedFonts[i].fontName;
					embedToggle = embeddedFonts[i].hasGlyphs(txtStr);
				}
			}
			Log.debug( curFont + " Embedded: " + embedToggle );
			this.embedFonts = embedToggle;
		}		
		
		public function getStyle(styleName:String):Object
		{
			return this.styleSheet.getStyle(styleName);
		}
		
		public function setStyle(styleName:String, styleObject:Object):void
		{
			var style:StyleSheet = this.styleSheet;
			style.setStyle(styleName, styleObject);
			
			this.styleSheet = style;
		}
		
		public function set styleString(s:String):void
		{
			var style:StyleSheet = new StyleSheet();
			style.parseCSS(s);
			
			this.styleSheet = style;
		}
		
		public function set embed( b:Boolean ):void
		{
			this.embedFonts = b;
		}		
		
		public function set font(n:String):void
		{
			var format:TextFormat  = this.defaultTextFormat;
			format.font            = n;
			this.defaultTextFormat = format;
			this.setTextFormat(format);
		}
		
		public function get font():String
		{
			var format:TextFormat  = this.getTextFormat();
			return format.font;
		}		
		
		public function set align(a:String):void
		{
			var format:TextFormat  = this.defaultTextFormat;
			format.align           = a;
			this.defaultTextFormat = format;
			this.setTextFormat(format);
		}
		
		public function set size(s:Number):void
		{
			var format:TextFormat  = this.defaultTextFormat;
			format.size            = s;
			this.defaultTextFormat = format;
			this.setTextFormat(format);
		}
		
		public function set leading(l:Number):void
		{
			var format:TextFormat  = this.defaultTextFormat;
			format.leading         = l;
			this.defaultTextFormat = format;
			this.setTextFormat(format);
		}
		
		public function set color(c:uint):void
		{
			var format:TextFormat  = this.defaultTextFormat;
			format.color           = c;
			this.defaultTextFormat = format;
			this.setTextFormat(format);
		{			
	}
}