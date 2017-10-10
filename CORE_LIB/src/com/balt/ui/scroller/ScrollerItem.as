package com.balt.ui.scroller {

	import flash.display.DisplayObject;
	import flash.display.Sprite;	

	public class ScrollerItem extends Sprite{
		
		private var content:DisplayObject;
		private var index:uint;
		private var message:String;
		
		public function ScrollerItem(_content:DisplayObject,_loadIndex:uint) 
		{
			index = _loadIndex;
			content = _content;
			addChild(content);	
		}
		public function setMessage(_message:String):void
		{
			message = _message;	
		}
		public function getMessage():String 
		{
			return message;	
		}
		
	}
}
