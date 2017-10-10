package com.balt.core.asset
{
	import com.balt.core.uilib.IUILibrary;
	
	import flash.events.IEventDispatcher;	
	
	public interface IContentManager extends IEventDispatcher
	{
		function load( swfArr:Array ):void;
		function getLibrary( id:String=null ):IUILibrary;	
	}
}