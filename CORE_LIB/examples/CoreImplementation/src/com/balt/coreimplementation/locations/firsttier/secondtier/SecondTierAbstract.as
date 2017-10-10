package com.balt.coreimplementation.locations.firsttier.secondtier
{
	import com.balt.core.location.Location;

	public class SecondTierAbstract extends Location {
		 
		protected var dataObj : Object;
		
		public function SecondTierAbstract( $dataObj : Object )
		{
			dataObj = $dataObj;
		}
	}
}
