package com.balt.core.localization {
	import flash.events.IEventDispatcher;
	
	/**
	 * Interface for LocaleManager
	 *
	 * @author adriaan scholvinck
	 * @version oct 21 2008
	 */
	public interface ICountryManager extends IEventDispatcher {
		
		function isInitialized():Boolean;
		function getCountry():String;
		function setCountry(country:String):Boolean;
	}
}