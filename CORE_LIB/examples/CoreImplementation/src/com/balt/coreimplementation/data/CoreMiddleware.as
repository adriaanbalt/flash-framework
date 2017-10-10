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
 
 
package com.balt.coreimplementation.data {
	import com.balt.core.data.IMiddleware;
	import com.balt.core.data.Middleware;
	import com.balt.coreimplementation.data.dataInterface.ILocationStorage;
	import com.balt.coreimplementation.data.dataInterface.IMainStorage;
	import com.balt.coreimplementation.data.dataInterface.INavStorage;

	public class CoreMiddleware extends Middleware implements IMiddleware
	{
		private var _locationstorage : LocationStorage;
		private var _navstorage : NavStorage;
		private var _mainstorage : MainStorage;
		
		public function CoreMiddleware() {}
		
		override public function initialize() : void {
			super.initialize();
			
			// instantiates the different Storage clases we'll be using
			_locationstorage = new LocationStorage();
			_navstorage = new NavStorage();
			_mainstorage = new MainStorage();
			
			// initialize
			// add connectivity if there is any
			addStorage( _locationstorage );
			addStorage( _navstorage );
			addStorage( _mainstorage );
		}
		
		public function getLocationStorage(): ILocationStorage {
			return ILocationStorage( this._locationstorage );
		}

		public function getNavStorage(): INavStorage {
			return INavStorage( this._navstorage );
		}
		
		public function getMainStorage(): IMainStorage {
			return IMainStorage( this._mainstorage );
		}
	}
}