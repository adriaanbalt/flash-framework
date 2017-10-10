package com.balt.core.uilib
{
	import flash.display.MovieClip;
	
	public interface IUILibrary
	{
		
		function getLibraryAsset( p_id: String ): MovieClip;
		
		function getLibraryClass( p_id: String ): Class;
		
		//function getLibraryFilters( p_id: String ): Array;
		
		//function getLibraryValue( p_id: String ): Number;
		
		function getVersion(): String;
	}
}
