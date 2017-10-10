package com.balt.loaders
{
	import com.balt.events.GenericDataEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * Currently valid file extensions are .css, .gif, .jpg, .png, .xml, and .swf 
	 * 
	 * @author Thaylin D. Burns
	 * 
	 */	
	public class BulkLoaderUtil extends EventDispatcher
	{
		public static const START_EVENT:String 		= Event.COMPLETE;
		public static const COMPLETE_EVENT:String 	= Event.COMPLETE;
		public static const PROGRESS_EVENT:String 	= ProgressEvent.PROGRESS;
		public static const IO_ERROR_EVENT:String 	= IOErrorEvent.IO_ERROR;
		public static const ERROR_EVENT:String		= ErrorEvent.ERROR;
		
		// Loading items
		protected var _loadingItems:Array = new Array();
		// Loaded items
		protected var _loadedItems:Dictionary = new Dictionary();
		// Howmany bytes loaded
		protected var _bytesLoaded:int = 0;
		// Total bytes to load
		protected var _bytesTotal:int = 0;
		//How many items have been started
		protected var _startedItems:int = 0;
		// How many items loaded
		protected var _loaded:int = 0;
		// Howmany items to load
		protected var _count:int = 0;
		// If all items are started, enable the progress event
		protected var _enableProgress:Boolean = false;
		
		public function BulkLoaderUtil(){ }
		
		/**
		 * Description	Passing in an array of either BulkLoaderItems or objects with id,url key value pairs loads all files passed.
		 * 				Currently only css, xml, and swf extensions are valid. Could also extend this class to be a repository to cache images. 
		 * @param files
		 * 
		 */		
		public function load(files:Array):void
		{
			var numOfFiles:int = files.length;
			
			for(var i:int = 0; i<numOfFiles; i++)
			{
				if(files[i] is BulkLoaderUtilItem)
				{
					addItem(files[i] as BulkLoaderUtilItem);
				}
				else
				{
					var item:BulkLoaderUtilItem = convertToBulkLoaderItem(files[i]);
					
					if(item) addItem( item );
					else dispatchEvent(new GenericDataEvent(ErrorEvent.ERROR, false, false, files[i]));
				}
			}
			//_enableProgress = true;
		}
		
		/**
		 * Description	Returns and array of the loaded items within the bulk loader. 
		 * @return 
		 * 
		 */		
		public function getItems():Array
		{
			var itemArr:Array = [];
			for each (var value:Object in _loadedItems)
			{
				itemArr.push(value);
			}
			return itemArr;
		}
		
		public function getItemByID(id:String):Object
		{
			var item:BulkLoaderUtilItem = _loadedItems[id]
			
			return item.content;
		}
		
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		protected function addItem(item:BulkLoaderUtilItem):void
		{
			_count++;
			addListeners(item)
			item.load();
			_loadingItems.push( item );
		}
		
		protected function addListeners(dispatcher:BulkLoaderUtilItem):void
		{
			dispatcher.addEventListener(COMPLETE_EVENT, completeEvent_handler);
			dispatcher.addEventListener(IO_ERROR_EVENT, ioErrorEvent_handler);
			dispatcher.addEventListener(ERROR_EVENT, ioErrorEvent_handler);
			dispatcher.addEventListener(Event.OPEN, openEvent_handler);
			dispatcher.addEventListener(PROGRESS_EVENT, progressEvent_handler);
		}
		
		protected function openEvent_handler(event:Event):void
		{
			_startedItems++
			checkStartProgress();
		}
		
		protected function ioErrorEvent_handler(event:ErrorEvent):void
		{
			_count--;
			checkStartProgress();
			var evt:GenericDataEvent = new GenericDataEvent(event.type, event.bubbles, event.cancelable);
			evt.data = {id:event.currentTarget.id, url:event.currentTarget.url, error:event.text}
			dispatchEvent( evt );
		}
		
		protected function checkStartProgress():void
		{
			if(_startedItems == _count) _enableProgress = true;
		}
		
		protected function progressEvent_handler(event:ProgressEvent):void
		{
			var loadedBytes:Number = 0;
			_bytesTotal = 0;
			
			for( var i:int = 0; i < _count;i++ )
			{
				loadedBytes += _loadingItems[i].bytesLoaded;
				_bytesTotal += _loadingItems[i].bytesTotal;
			}
			
			_bytesLoaded = loadedBytes;
			
			var progressEvent:ProgressEvent = new ProgressEvent(PROGRESS_EVENT, event.bubbles, event.cancelable, _bytesLoaded, _bytesTotal);
			
			if( _enableProgress ) dispatchEvent( progressEvent );
		}
		
		protected function completeEvent_handler(event:Event):void
		{
			_loadedItems[event.target.id] = event.target;
			_loaded++;
			if( _loaded == _count ) dispatchEvent(new Event(COMPLETE_EVENT));
		}
		
		protected function convertToBulkLoaderItem(obj:Object):BulkLoaderUtilItem
		{
			var item:BulkLoaderUtilItem;
			
			if(obj.hasOwnProperty("id") && obj.hasOwnProperty("url"))
			{
				item = new BulkLoaderUtilItem(obj.id, obj.url);
			}
			else dispatchEvent(new GenericDataEvent(ErrorEvent.ERROR, false, false, obj));
			
			return item;
		}
	}
}