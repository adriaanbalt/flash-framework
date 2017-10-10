package com.balt.core.asset
{
	import com.balt.core.path.IPathManager;
	import com.balt.events.GenericDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	public class SiteLoader extends EventDispatcher
	{
		public static const ON_COMPLETE:String = Event.COMPLETE;
		public static const PROGRESS_EVENT:String = ProgressEvent.PROGRESS;
		
		private var _assetPaths:Array = new Array();
		private var _cssPaths:Array = new Array();
		private var _fontPaths:Array = new Array();

		private var _bytesLoaded : Number = 0;
		private var _bytesTotal : Number = 0;
		 
		public function SiteLoader( pathList:*, pathManager:IPathManager )
		{
			if( pathList is XMLList )
			{
				for each( var assetItem:String in pathList.asset.@src ){ _assetPaths.push( pathManager.getSWFPath() + assetItem ); }
				for each( var cssItem:String in pathList.css.@src ){ _cssPaths.push( pathManager.getCSSPath() + cssItem ); }
				for each( var fontItem:String in pathList.font.@src ){ _fontPaths.push( pathManager.getSWFPath() + fontItem ); }					
			}
			else
			{
				this._assetPaths = pathList.asset;
				this._cssPaths = pathList.css;
				this._fontPaths = pathList.font;
			}
		}
		
		public function get assetPaths():Array
		{
			return _assetPaths;
		}
		
		public function get cssPaths():Array
		{
			return _cssPaths;
		}

		public function get fontPaths():Array
		{
			return _fontPaths;
		}				
		
		// listens to progress and complete events from other classes
		// tally's all progress information from the managers that are connect to this class
		// dispatches events with the combined total of the progress which is then listened to by the visual representation, Project specific class
		
		public function openEvent( $e : Event ) : void {
			this._bytesTotal += $e.target._bytesTotal;
		}
		
		public function progressEvent( $e : Event ) : void {
			this._bytesLoaded += $e.target._bytesLoaded;
			dispatchEvent( new GenericDataEvent( ProgressEvent.PROGRESS, false, false, _bytesLoaded ));
		}
		
		public function completedEvent( $e : Event ) : void {
			// probably not going to be used
		}
		
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
	}
}