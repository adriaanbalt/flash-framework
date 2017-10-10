package com.balt.coreimplementation.data {
	import com.balt.core.data.Storage;
	import com.balt.coreimplementation.data.dataInterface.ILocationStorage;

	public class LocationStorage extends Storage implements ILocationStorage {

		public var id : String = "main";
		
		private var arr : Array;
		
		public function LocationStorage()
		{}
		
		public function getArray():Array{
			if ( arr == null ) {
				arr = new Array();
				if ( xml.part.length() ) {
					for each(var item:XML in xml.part){
						arr.push( item );
					} 
				}
			}
			return arr; 
		}
		
		public function getDefault() : String {
			return xml.sectionToStart.toString();
		}
		
	}
}