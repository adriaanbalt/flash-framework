package com.balt.core.asset.css
{
	import com.balt.loaders.BulkLoaderUtilItem;
	import com.balt.loaders.LoadUtil;
	import com.balt.text.CSSObject;
	import com.balt.text.StyleManager;
	
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	public class StylesManagerItem extends BulkLoaderUtilItem
	{

		public function StylesManagerItem( id:String, url:String )
		{
			super( id, url )
		}

		public override function load():void
		{
			if(id && url)
			{
				_loader = LoadUtil.loadCSS(url, completeEvent_handler, progressEvent_handler, ioErrorEvent_handler, openEvent_handler) as EventDispatcher;
			}
			else dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, (this+":: either id or url was not a valid value. Please reference AssetManager documentation for a listing of valid types.")));
		}
		
		public override function get content():Object
		{
			if(_loader.hasOwnProperty('contentLoaderInfo'))
				return LoaderInfo(_loader['contentLoaderInfo']).content
			else if(_loader is CSSObject)
				return _loader;
			else
				return _loader['data'];
		}
		
		protected override function completeEvent_handler(event:Event):void
		{
			dispatchEvent( event);
		}
		
	}
}