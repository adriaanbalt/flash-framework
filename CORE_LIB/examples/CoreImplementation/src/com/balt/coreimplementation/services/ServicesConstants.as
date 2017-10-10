package com.balt.coreimplementation.services
{
	
	public class ServicesConstants
	{
		public static const ON_INIT:String = "onInit";
		public static const ON_COMPLETE:String = "onComplete";
		
		public static var ROOT_LOCATION_ID:String = "";		
		
		public static function getServices( ):IServices {
			if ( ServicesFactory._service==null || !( ServicesFactory._service is IServices ) ) {
				throw new Error("Exception: ServicesConstants.getServices(): SERVICE==undefined or not an instance of IServices");
			}
			return IServices( ServicesFactory._service );
		}
	}
}