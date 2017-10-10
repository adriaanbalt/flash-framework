package com.balt.core.asset.swf
{
	import com.balt.core.asset.IContentManager;
	import com.balt.core.uilib.IUILibrary;
	import com.balt.events.GenericDataEvent;
	import com.balt.loaders.BulkLoaderUtil;
	
	import flash.events.ErrorEvent;

	public class AssetsManager extends BulkLoaderUtil implements IContentManager
	{		
		// connects to SiteLoader
		private var data : Object;
		
		public function AssetsManager( $data:Object )
		{
			data = $data;
		}
		
		public override function load( files:Array ):void
		{
			var numOfFiles:int = files.length;
			
			for(var i:int = 0; i<numOfFiles; i++)
			{
				if(files[i] is AssetManagerItem)
				{
					addItem(files[i] as AssetManagerItem);
				}
				else
				{
					var item:AssetManagerItem = convertToAssetManagerItem(files[i]);
					
					if(item) addItem( item );
					else dispatchEvent(new GenericDataEvent(ErrorEvent.ERROR, false, false, files[i]));
				}
			}
		}
		
		public function getLibrary( id:String=null ):IUILibrary
		{
			return getItems()[0];
		}
		
		private function convertToAssetManagerItem(obj:Object):AssetManagerItem
		{
			var item:AssetManagerItem;
			
			if(obj.hasOwnProperty("id") && obj.hasOwnProperty("url"))
			{
				item = new AssetManagerItem(obj.id, obj.url);
			}
			else dispatchEvent(new GenericDataEvent(ErrorEvent.ERROR, false, false, obj));
			
			return item;
		}
	}
}