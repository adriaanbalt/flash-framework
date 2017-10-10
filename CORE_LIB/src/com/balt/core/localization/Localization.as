package com.balt.core.localization {
	import com.balt.core.log.Log;
	
	import flash.display.Sprite;
	import flash.events.Event;	

	public class Localization extends Sprite
	{
		public function Localization( )
		{
		}
		
		
		public function clearLocale():Boolean { 
			return LocaleCookie.deleteLocale();
		}
		public function grab():void  {
			Log.info( "Localization.grab()" );
			
			// DEBUG: we don't want to use the shared object
			clearLocale();
			
			var cur_language : String;
			var cur_region : String;
			var cur_persistence : String;
			var cur_country : String;
			
			// check flashvars
			if (( flashvars.la != undefined) && ( flashvars.re != undefined ) && ( flashvars.co != undefined ) ) {
				//trace("LocaleManager.grabLocale() grab flashvars" );
				cur_language = flashvars.la;
				cur_region = flashvars.re;
				cur_country = flashvars.co;
			}

			// there are no flashvars
			// check shared object
			if (!localeInitialized) {
				//trace("LocaleManager.grabLocale(): grab cookie" );
				cur_language = LocaleCookie.getLocale().getLanguage();
				cur_region = LocaleCookie.getLocale().getRegion();
				cur_persistence = LocaleCookie.getLocale().getPersistence();
				cur_country = LocaleCookie.getLocale().getCountry();
			}
			
			// there is no shared object
			// Check if there are defaults
			if (!localeInitialized) {
				//trace("LocaleManager.grabLocale(): grab defaults" );
				// these are empty inside LocaleConstants if you do not want a default language and region
				cur_language = LocaleConstants.DEFAULT_LANGUAGE;
				cur_region = LocaleConstants.DEFAULT_REGION;
				cur_country = LocaleConstants.DEFAULT_COUNTRY;
			}
			
			// Check if we could initialize the locale from the flash vars, shared object, or defaults
			if (!localeInitialized) {
				//trace("LocaleManager.grabLocale(): error");
				dispatchEvent( new Event( LocaleConstants.EVENT_LOCALE_ERROR ));
				return;
			}
			
			// we must have the locale now correctly
			if ( isInitialized() ) {
				setLocale( cur_language, cur_region, cur_persistence );
				dispatchEvent( new Event( LocaleConstants.EVENT_LOCALE_LOADED ));
			}
			
		}
		
		/**
		 * 
		 * TODO: detemine which of these grab methods is the correct one.
		 */
		/* public function grab():void {
			trace ( "  CountryManager.grab()" );
			//trace("LocaleManager.grabCountry(): flashvars.co=" + flashvars.co);
			
			var country : String = "";
			
			// The country has not been initialized, so we need to do the work.
			//trace("LocaleManager.grabCountry(): grabbing country");
			// Check if any country was passed as a parameter.
			
			var tLocale : Locale;
			
			if (( flashvars.co != null ) && ( flashvars.co != "undefined")) {
				
				// A country was passed as a parameter, so we use that
				//trace("LocaleManager.grabCountry(): a country was passed in the parameter. flashvars.co="+flashvars.co);
				countryInitialized = isValidCountry( flashvars.co ); // TODO check to make sure that it is okay
				trace("CountryManager.grabLocale() grab flashvars" );
				if ( countryInitialized ) {
					country = flashvars.co;
				}
			}
			
			// There is no country in the parameters, so look for a country in
			// the shared object.
			if ( !countryInitialized ){
				tLocale = LocaleCookie.getLocale();	// shared object locale
				countryInitialized = isValidCountry( tLocale.getCountry() );
				trace("CountryManager.grabLocale() grab cookie" );
				if ( countryInitialized ){
					country = tLocale.getCountry();
				}
			}
			
//			if ( !countryInitialized ){
//				var cd : CountryDetector = new CountryDetector(data.countryDetectionService);
//				cd.addEventListener(CountryDetector.EVENT_ON_DETECTED, onCountryDetected);
//				cd.addEventListener(CountryDetector.EVENT_ON_ERROR, onCountryDetectionError);
//				cd.detectCountry();
				// need to figure out a way to decide if the country is initialized
//			}
			
			// go by default
			if ( !countryInitialized ) {
				countryInitialized = isValidCountry( LocaleConstants.DEFAULT_COUNTRY );
				trace("CountryManager.grabLocale() grab defaults" );
				if ( countryInitialized ){
					country = LocaleConstants.DEFAULT_COUNTRY;
				}
			}
			
			// send event
			if ( !countryInitialized ) {
				trace("CountryManager.grabLocale() error" );
				dispatchEvent( new Event( LocaleConstants.EVENT_COUNTRY_ERROR ));
				return;
			}
			
			if ( isInitialized() ){
				locale.setCountry( country );
				dispatchEvent( new Event( LocaleConstants.EVENT_COUNTRY_LOADED ));
			}
				
		} */
		
		
		/////////////////////////
		// PRIVATE METHODS
		/////////////////////////
		
		private function onCountryDetected(event:Event):void {
			// Store the country selection
			locale.setCountry(CountryDetector(event.target).code);
		}
		
		private function onCountryDetectionError(event:Event):void {
			// Use the default country
//			locale.setCountry(LocaleConstants.DEFAULT_COUNTRY);
			Log.error( "onCountryDetectionError()" );
			dispatchEvent( new Event( LocaleConstants.EVENT_COUNTRY_ERROR ));
		}
		

	}
}