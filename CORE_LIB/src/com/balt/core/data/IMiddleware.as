package com.balt.core.data {

	import com.balt.core.data.IStorage;
	//import com.balt.core.data.dataInterface.IMainStorage;
	
	public interface IMiddleware
	{
		function initialize ():void;
		function updateDataPath( $dir : String ) : void;
		function updateAssetPath ( dir: String ) : void;
		function addStorage( $storage : Storage ) : Boolean;
		function getStorage( $storageID : String ) : IStorage;
	}
}