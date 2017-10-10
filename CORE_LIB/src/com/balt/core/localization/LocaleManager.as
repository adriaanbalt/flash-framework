package com.balt.core.localization {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Handles the Language and Region of the site.
	 * 
	 * language - current active language 
	 * region - current active region 
	 * persistence - if this language/region combination should be saved into the shared object or not
	 * 
	 * @author adriaan scholvinck
	 * @version oct 21 2008
	 */
	public class LocaleManager extends EventDispatcher implements ILocaleManager {
		
		// The current locale
		private var language : String;
		private var region : String;
		private var persistence : Boolean;
		
		// Whether the locale has been properly initialized or it's just
		// using the default value.
		private var localeInitialized : Boolean;
		
		/////////////////////////
		// CONSTRUCTOR
		/////////////////////////
		public function LocaleManager( ) 
		{
			// trace ( "LocaleManager v1.0" );
			// Nothing is initialized at this point
			this.localeInitialized = false;
		}

		/////////////////////////
		// PUBLIC METHODS
		/////////////////////////
		 
		/**
		 * Gets the current language.
		 */
		public function getLanguage() : String {
			// var so : Object = LocaleCookie.getCookie();
			return ( language );
		}
		
		/**
		 * Gets the current region.
		 */
		public function getRegion() : String {
			// var so : Object = LocaleCookie.getCookie();
			return ( region );
		}
		
		/**
		 * Get the current language-region.
		 * @return  
		 * 
		 */
		public function getLocale() : String {
			return ( language + "-" + region );
		}
		
		/**
		 * Gets the current persistence on locale.
		 */
		public function getPersistence() : Boolean {
			return ( persistence );
		}
		
		/**
		 * Returns whether the instance has been initialized or not. A LocaleManager has
		 * been initialized if the value for language and region have been obtained from
		 * a source other than default values.
		 */	
		public function isInitialized() : Boolean {
			return localeInitialized;
		}
		
		/**
		 * setLocale
		 * @param language (String) = null
		 * @param region (String) = null
		 * 
		 * Sets the current locale. Current values will be used for null parameters.
		 */
		public function setLocale( $language:String, $region:String, $persistence:Boolean = true ):Boolean {
			// Get the current values for any null parameters
			var newLanguage:String = ( $language == null ) ? language : $language.toLowerCase();
			var newRegion:String = ( $region == null ) ? region : $region.toUpperCase();
			
			if ( newLanguage != null ) {
				language = newLanguage;
			}
			if ( newRegion != null ){
				region = newRegion;
			}
			persistence = $persistence;
			
			if ( language != null || region != null ){
				// we don't check persistence here because
				// that is done inside the cookie
				// this actually is important because if we do it here, we could potentially run into an infinite loop
				// if we constantly set persistence to false in the method listening to EVENT_LOCALE_ERROR
				LocaleCookie.setLocale( language, region, persistence );
				this.localeInitialized = true;
				dispatchEvent( new Event( LocaleConstants.EVENT_LOCALE_CHANGED ) );
				return true;
			} else {
				dispatchEvent( new Event( LocaleConstants.EVENT_LOCALE_ERROR ) );
				return false;
			}
		}
		
	}
}