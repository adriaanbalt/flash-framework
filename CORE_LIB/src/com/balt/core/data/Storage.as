/**
 * 
 * Storage.as
 * @author adriaan scholvinck
 * 
 * handles the loading of data from databases, xml, php and more
 * this handles the back end and will feed the interface its necessary data
 * Modularized data management - this class is used only by the Middleware, which is then used by the Views
 * 
 * holds the paths that are used to load data
 * 
 * there are many different Storage classes, each one would have their own data strings relative to that specific section
 * 
 * This is an extendable class
 * 
 * @version 1.0 create
 * @version 1.1 add asset path and updateAsset path function.
 *
 */

package com.balt.core.data
{
	import com.balt.loaders.LoadUtil;
	import com.balt.core.log.Log;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	public class Storage extends EventDispatcher implements IStorage
	{	
		public static var EVENT_ON_DATA_PROGRESS	:String = ProgressEvent.PROGRESS;
		public static var EVENT_ON_DATA_ERROR		:String = IOErrorEvent.IO_ERROR;
		public static var EVENT_ON_DATA_LOADED 		:String = Event.COMPLETE;
		
		protected var assetPath:String;
		protected var middleware:Middleware;
		protected var path:String;
		protected var xml:XML;
		protected var xml_file_name:String; // to be replaced
		
		public function Storage( $middleware : Middleware = null )
		{
			middleware = $middleware;
		}
		
		// override
		public function initialize():void {}
		
		public function loadData( $path:String = null ):void
		{
			// loads some based on path
			path = $path;
			
			Log.debug( "Got To Storage.loadData. Loading data from " + path );
			LoadUtil.loadData( path, onLoadInit, onLoadError, onProgress );
		}
		
		public function updateDataPath( $path:String ):void
		{
			path = $path + xml_file_name;
		}
		
		public function getXMLData():XML
		{
			return xml;
		}
		
		public function updateAssetPath ( p_path:String ):void
		{
			assetPath = p_path;
		}

		protected function onLoadInit(evt:Event):void
		{
			Log.debug( "Got To Storage.onLoadInit. Loaded data from " + path );
			xml = XML(evt.target.data);
			dispatchEvent ( new Event( EVENT_ON_DATA_LOADED ) );
		}
		
		// override
		protected function onProgress(event:ProgressEvent):void {}
		
		protected function onLoadError(event:Event):void
		{
			Log.error( "Error loading data from " + path );
			dispatchEvent ( new Event( EVENT_ON_DATA_ERROR ) );
		}
	}
}