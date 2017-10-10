package com.balt.loaders
{
	import com.balt.loaders.LoadUtil;
	import com.balt.text.StyleManager;
	
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	public class BulkLoaderUtilItem extends EventDispatcher
	{
		protected var _loader:EventDispatcher;
		protected var _id:String;
		protected var _url:String;		
				
		public function BulkLoaderUtilItem( id:String, url:String )
		{
			this.id = id;
			this.url = url;
		}

		public function set id(value:String):void
		{
			if(value is String)
				_id = value;
		}
		public function get id():String
		{
			return _id;
		}

		public function set url(value:String):void
		{
			if((value is String))
				_url = value;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function load():void
		{
			if(id && url)
			{
				var func:Function
				var test:String = url.match(/\.\w+/).toString();
				
				switch( test )
				{
					case ".swf":
						func = LoadUtil.loadSWF;
					break;
					case ".jpg":
						func = LoadUtil.loadImage
					break;
					case ".gif":
						func = LoadUtil.loadImage
					break;					
					case ".png":
						func = LoadUtil.loadImage
					break;
					case ".css":
						func = LoadUtil.loadCSS
					break;
					default:
						func = LoadUtil.loadData
					break;
				}
		
				_loader = func(url, completeEvent_handler, progressEvent_handler, ioErrorEvent_handler, openEvent_handler) as EventDispatcher;
			}
			else dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, (this+":: either id or url was not a valid value. Please reference AssetManager documentation for a listing of valid types.")));
		}
		
		public function get content():Object
		{
			if(_loader.hasOwnProperty('contentLoaderInfo'))
				return LoaderInfo(_loader['contentLoaderInfo']).content
			else if(_loader is StyleManager)
				return _loader;
			else
				return _loader['data'];
		}
		
		protected function openEvent_handler(event:Event):void
		{
			dispatchEvent(event);
		}
		
		protected function ioErrorEvent_handler(event:IOErrorEvent):void
		{
			dispatchEvent( event);
		}
		
		protected function progressEvent_handler(event:ProgressEvent):void
		{
			dispatchEvent( event);
		}
		
		protected function completeEvent_handler(event:Event):void
		{
			dispatchEvent( event);
		}
		
		public function get bytesLoaded():uint
		{
			if(_loader.hasOwnProperty('contentLoaderInfo'))
				return _loader['contentLoaderInfo'].bytesLoaded as uint;
			else
				return _loader['bytesLoaded'] as uint;
		}
		
		public function get bytesTotal():uint
		{
			if(_loader.hasOwnProperty('contentLoaderInfo'))
				return _loader['contentLoaderInfo'].bytesTotal as uint;
			else
				return _loader['bytesTotal'] as uint;
		}
	}
}