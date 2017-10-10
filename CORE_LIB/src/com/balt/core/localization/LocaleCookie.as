
/**
 * Stores a locale in a shared object. 
 * A locale is only stored if its persistent attribute is true.
 * 
 * Separated storage of language/region and country
 * 
 * 
 * @author adriaan scholvinck
 * @version oct 21 2008
 */

package com.balt.core.localization
{
	
	import flash.events.Event;
	import flash.net.SharedObject;

	public class LocaleCookie	{
		private static var SHARED_NAME:String;
		private static var SHARED_PATH:String  = "/";
		private static var SECURE:Boolean = false;
		private static var so:SharedObject; //  class var so it can get the 'onStatus' callback
			
		public function LocaleCookie( sharedObjectName:String, sharedObjectPath:String = null) {
			SHARED_NAME = sharedObjectName;
			if ( sharedObjectPath ) SHARED_PATH = sharedObjectPath;
		}
		
		/**
		 * Gets the current locale stored in the shared object. Locales retrieved from 
		 * a shared object are persistent.
		 */
		public static function getCookie() : Object {
			so = SharedObject.getLocal( SHARED_NAME, SHARED_PATH, SECURE );
			var languageCode:String = so.data.languageCode;
			var regionCode:String = so.data.regionCode;
			var countryCode:String	= so.data.countryCode;
			return { language:languageCode, region:regionCode, country:countryCode };			
		}
		
		/**
		 * Stores the locale. Only persistent locales are actually stored.
		 * 
		 * @return whether the locale was stored or not
		 */	
		public static function setLocale( $language : String, $region : String, $persistence : Boolean = true ) : void {
			so = SharedObject.getLocal( SHARED_NAME, SHARED_PATH, SECURE );
			var result:String;
			try {
				result = so.flush( 1000 );
			} catch ( e:Event ) {
				
			}
			if ( result != null ) {
				saveLocale ( $language, $region, $persistence );
			} 
		}
		
		private static function saveLocale( $language : String, $region : String, $persistence : Boolean = true ):void	{
			if ( $persistence ) {
				so.data.languageCode = $language;
				so.data.regionCode = $region;
				so.flush();
			}
		}
		
		/**
		 * Stores the locale. Only persistent locales are actually stored.
		 * 
		 * @return whether the locale was stored or not
		 */	
		public static function setCountry( $country : String ) : void {
			so = SharedObject.getLocal( SHARED_NAME, SHARED_PATH, SECURE );
			var result:String;
			try {
				result = so.flush( 1000 );
			} catch ( e:Event ) {
				
			}
			// this means the shared object exists
			if ( result != null ) {
				saveCountry( $country );
			} 
		}
        
		private static function saveCountry( $country : String ) : void	{
			so.data.countryCode = $country;	
			so.flush();
		}
			
		public static function deleteLocale():Boolean {
			so = SharedObject.getLocal(SHARED_NAME, SHARED_PATH, SECURE);
			if ( so ) {
				so.clear();	
				return true;
			} else {
				return false;
			}
		}
		
	}
}