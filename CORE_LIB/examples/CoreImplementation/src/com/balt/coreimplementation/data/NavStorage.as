package com.balt.coreimplementation.data {
	import com.balt.core.data.Storage;

	import com.balt.coreimplementation.data.dataInterface.INavStorage;

	public class NavStorage extends Storage implements INavStorage {
		
		private var arr : Array;
		
		public function NavStorage()
		{}
		
		public function getNav():Array{
			if ( arr == null ) {
				arr = new Array();
				if ( xml.navigation.tab.length() ) {
					for each(var item:XML in xml.navigation.tab){
						arr.push( item );
					} 
				}
			}
			return arr; 
		}
	}
}