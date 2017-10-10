/**
 * 
 * @author adriaan scholvinck
 * @version october 4th 2008
 * 
 * handles the data accessing
 * connects to an exterior data management interface @see Storage.as
 * 
 * preloader of data files being loaded
 * 		=could be assets too
 * retreives data just like a Model
 * doesnt actually hold anything relative to the loading of data, but rather returns data from the loaders
 */
 
 
package com.balt.core.data {

	public class Middleware implements IMiddleware
	{
		private var storage_arr : Array; // holds a list of all the storage containers should we need to update all of them at once
		
		private var _storageLoadCounter:uint = 0;
		
		public function Middleware()
		{
		}
		
		public function initialize ():void {
			storage_arr = new Array();
			_storageLoadCounter = 0;
		}
		
		public function updateDataPath( $dir : String ) : void {
			// updates the Locale of all storage containers
			// when something changes here, we need to change it in all of the storage containers
			for ( var i : Number = 0 ; i < storage_arr.length; i++ ) {
				storage_arr[i].updateDataPath( $dir );
			}
		}
		
		public function updateAssetPath( dir: String ) : void {
			for ( var i : Number = 0 ; i < storage_arr.length; i++ ) {
				storage_arr[i].updateAssetPath( dir );
			}
		}
		
		
		/**
		 * addStorage
		 * @param Storage : that we want to add to storage_arr @see Storage.as
		 * @return boolean value that represents if we were successful in adding the Storage
		 * 
		 * can later be used to update all Storage classes simultaneously or by definition
		 */
		public function addStorage( $storage : Storage ) : Boolean {
			// Don't add a viewer more than once.
			for (var i:Number = 0; i < storage_arr.length; i++) {
				if (storage_arr[i] == $storage) {
					// The observer is already observing, so quit.
					return false;
				}
			}
			// Put the observer into the list.
			storage_arr.push($storage);
			return true;
		}
		
		public function getStorage( $storageID : String ) : IStorage {
			for (var i:Number = 0; i < storage_arr.length; i++) {
				if ( storage_arr[i].id == $storageID ) {
					return storage_arr[i];
				}
			}
			throw new Error("Exception: Middleware.getStorage( " + $storageID + " ): == undefined");
		}
		
		private function checkAllLoaded():void {
			if ( _storageLoadCounter == storage_arr.length ) {
				//this.dispatchEvent( new Event( MiddlewearConsts.INIT ) );
			} 
		}
		
	}
}