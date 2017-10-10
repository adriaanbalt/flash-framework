package com.balt.core.location
{
	import com.balt.loaders.LoadUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class AsyncroniousLocation extends Location
	{
		public function AsyncroniousLocation()
		{
		}
		
		public override function init ( dataPath: * = null ):void {
			if ( dataPath == null ) {
				this.dispatchEvent( new Event ( LocationConstants.EVENT_ON_INIT ) );
			} else {
				loadData ( dataPath );
			}
		}
		
		protected function loadData ( dataPath:String ) :void {
			LoadUtil.loadData( dataPath, onDataLoaded, onLoadError );
		}
		
		protected function onDataLoaded ( e:Event ):void {
			this.dispatchEvent( new Event ( LocationConstants.EVENT_ON_INIT ) );
		}
		
		protected function onLoadError ( e:IOErrorEvent ):void {
			throw new Error( " Exception: " + e.text);
		}

	}
}