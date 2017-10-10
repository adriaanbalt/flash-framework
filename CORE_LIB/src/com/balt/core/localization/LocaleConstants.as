/**
 * Constants for the LocaleManager class and CountryManager class.
 * 
 * May also be used with a larger class that operates differently
 * 
 * @author adriaan scholvinck
 * @version oct 21 2008
 */
package com.balt.core.localization
{
	public class LocaleConstants {
		
		// change events
		public static var EVENT_LOCALE_CHANGED:String = "onLocaleChanged";
		public static var EVENT_COUNTRY_CHANGED:String = "onCountryChanged";
		
		// error events
		public static var EVENT_LOCALE_ERROR : String = "onLocaleError";
		public static var EVENT_COUNTRY_ERROR : String = "onCountryError";
		
		// defaults
		public static var DEFAULT_LANGUAGE :String = "en";
		public static var DEFAULT_REGION : String = "R0";
		public static var DEFAULT_COUNTRY :String = "US";
		
	}
}