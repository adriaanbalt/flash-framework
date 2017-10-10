/**
 * 
 * Storage.as
 * @author adriaan scholvinck
 * 
 * handles the loading of data from databases, xml, php and more
 * this handles the back end and will feed the interface it's necessary data
 * Modularized data management - this class is used only by the Middleware, which is then used by the Views
 * 
 * holds the paths that are used to load data
 * 
 * there are many different Storage classes, each one would have their own data strings relative to that specific section
 * 
 * This is an extendable class
 *
 */

package com.balt.coreimplementation.data {
	import com.balt.core.data.Storage;

	import com.balt.coreimplementation.data.dataInterface.IVideosStorage;

	public class FirstTierStorage extends Storage implements IVideosStorage {
		private var arr : Array;
		
		public function FirstTierStorage(){}
		
		public function getArray():Array{
			if ( arr == null ) {
				arr = new Array();
				if ( xml.part.length() ) {
					for each(var item:XML in xml.part){
						arr.push( items[i] );
					} 
				}
			}
			return arr; 
		}
		
	}
}