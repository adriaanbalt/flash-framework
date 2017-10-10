package com.balt.core.data
{
	import flash.events.IEventDispatcher;
	
	public interface IStorage extends IEventDispatcher
	{
		function initialize() : void;
		function loadData( $path : String = null ) : void;
		function updateDataPath( $path : String ) : void;
		function getXMLData() : XML;
		function updateAssetPath ( p_path: String ) : void;
	}
}