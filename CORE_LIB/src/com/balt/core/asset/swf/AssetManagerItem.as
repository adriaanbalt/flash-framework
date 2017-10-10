package com.balt.core.asset.swf
{
	import com.balt.core.uilib.IUILibrary;
	import com.balt.loaders.BulkLoaderUtilItem;
	
	import flash.events.Event;
	
	public class AssetManagerItem extends BulkLoaderUtilItem
	{
		private var _assets : IUILibrary;
		
		public function AssetManagerItem( id:String, url:String ) {
			super( id, url );
		}
		
		public function assets():IUILibrary
		{
			return IUILibrary( this._assets );
		}
		
		protected override function completeEvent_handler(event:Event):void
		{
			_assets = IUILibrary( content ); 
			dispatchEvent(event);
		}
	}
}
