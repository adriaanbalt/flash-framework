package com.balt.core.localization
{
	import com.balt.core.log.Log;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class CountryManager extends EventDispatcher implements ICountryManager
	{
		// The current country
		private var country : String;
		
		// Whether the country has been properly initialize or is using the default value.
		private var countryInitialized : Boolean;

		/**
		 * recommend not passing arguments since the listeners aren't setup yet 
		 */
		public function CountryManager( $country : String = null )
		{
			Log.info( "CountryManager v1.0" );
			this.countryInitialized = false;
			if ( $country != null ){
				setCountry( $country );
			}
		}
		
		/////////////////////////
		// PUBLIC METHODS
		/////////////////////////
		
		/**
		 * Returns whether the instance has been initialized or not. A LocaleManager has
		 * been initialized if the value for language and region have been obtained from
		 * a source other than default values.
		 */	
		public function isInitialized():Boolean {
			return countryInitialized;
		}

		/**
		 * Gets the current country.
		 */
		public function getCountry():String {
			var so : Object = LocaleCookie.getCookie();
			return ( so.country );
		}
		
		/**
		 * setCountry
		 * @param $country (String) the country that we want to save 
		 *
		 * Sets the current country.
		 */
		public function setCountry( $country:String ):Boolean {
			if ( $country != null ) {
				country = $country;
				LocaleCookie.setCountry( $country.toUpperCase() );
				dispatchEvent(new Event(LocaleConstants.EVENT_COUNTRY_CHANGED));
			} else {
				dispatchEvent( new Event( LocaleConstants.EVENT_COUNTRY_ERROR ));	
			}
			return true;
		}
		
	}
}