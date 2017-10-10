package com.balt.core.init
{
	import com.balt.core.log.Log;
	import com.balt.loaders.LoadUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class Config extends EventDispatcher
	{
		public static const ON_INIT:String = "onInit";
		public static const ON_ERROR:String = "onError";
		
		public var dataObj:* = null;
		
		private var _mainTimeline:DisplayObjectContainer;		
		
		public function Config( mainTimeline:DisplayObjectContainer, configObj:Object, pathRoot:String )
		{
			this._mainTimeline = mainTimeline;
			
			if( configObj is String )
    		{
    			var configPath:String = pathRoot + String( configObj );
				LoadUtil.loadData( configPath, onConfigInit, onConfigError );
    		}
    		else
    		{
    			dataObj = configObj;
    			init();
    		}
		}
		
		private function onConfigInit( evt:Event ):void
		{	
			Log.debug( "Config.loaded" );
			var dataXML:XML = XML( evt.target.data );			
			if( dataXML ) this.dataObj = dataXML;		
			
			init();
		}		
		
		private function onConfigError( evt:IOErrorEvent ):void
		{
			Log.error( "Config.Error: ERROR LOADING CONFIG DATA." );
			this.dispatchEvent( new Event( Config.ON_ERROR ) );
		}
		
		private function init():void
		{
			Log.info( "Config.init" );
			this.dispatchEvent( new Event( Config.ON_INIT ) );
			
			this._mainTimeline.stage.scaleMode = this.dataObj.siteConfig.stageScaleMode.toString();
			this._mainTimeline.stage.align = this.dataObj.siteConfig.stageAlign.toString();
			
			this._mainTimeline.contextMenu = setContextMenu( this.dataObj.siteConfig.contextMenu );
			
			setSecurity( this.dataObj.siteConfig.crossDomain );			
		}
		
		private function setContextMenu( dataList:* ):ContextMenu
		{
			var menu:ContextMenu = new ContextMenu();
			var copyright:ContextMenuItem = new ContextMenuItem( dataList.copyright.toString() );
			menu.hideBuiltInItems();
			menu.customItems.push( copyright );
			
			return menu;		
		}
		
		private function setSecurity( dataList:* ):void
		{
			if(dataList is XMLList)
			{
				for each( var item:* in dataList )
				{
					if( item.name() == "allow" ) Security.allowDomain( item.@src );
					else if( item.name() == "allowInsecure" ) Security.allowInsecureDomain( item.@src );
					else if( item.name() == "policy" ) Security.loadPolicyFile( item.@src );				
				}
			}
			else
			{
				for(var objItem:String in dataList)
				{
					Security[objItem](dataList[objItem]);
				}
			}
		}
	}
}