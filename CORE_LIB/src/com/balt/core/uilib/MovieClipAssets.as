package com.balt.core.uilib {
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

	public class MovieClipAssets extends MovieClip implements IUILibrary {
		private static var VERSION:String = "1.0";
		
		public function MovieClipAssets() 
		{
		}
		/**
		 * Description:	Use this class to retrieve instantiated library assets from the asset swf. Your Asset swf must define this class as it's document class.
		 * 
		 * 
		 */
		public function getLibraryAsset( p_id: String ): MovieClip {
			var results: MovieClip;
			
			try
			{
				results = new ( getDefinitionByName( p_id ) ) ();
			}
			catch ( p_error: * )
			{
				throw new Error("Exception: DefaultAsset:getLibraryAsset Cannot get the asset name " + p_id +
								" you might need to add asset: " + p_id + " on your fla file" + 
								" error -> " + p_error);
				//results = null;
			}
			
			return results;
		}
		
		public function getLibraryClass( p_id: String ): Class {
			var results: Class;
			
			try
			{
				results = getDefinitionByName( p_id ) as Class;
			}
			catch ( p_error: * )
			{
				throw new Error("Exception: DefaultAsset:getLibraryClass Cannot get the class " + p_id +
								" you might need to add class: " + p_id + " to your fla file" + 
								" error -> " + p_error);
				//results = null;
			}
			
			return results;
		}
		
		public function getVersion(): String {
			return MovieClipAssets.VERSION;
		}

	}
}