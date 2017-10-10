package com.balt.core.localization {
	import flash.events.IEventDispatcher;
	
	/**
	 * Interface for LocaleManager
	 *
	 * @author adriaan scholvinck
	 * @version oct 21 2008
	 */
	public interface ILocaleManager extends IEventDispatcher {
		
		function isInitialized():Boolean;	
		function getLanguage():String;
		function getRegion():String;
		function getLocale():String;
		function setLocale( $language:String, $region:String, $persistence:Boolean = true ):Boolean;
		
	}
}