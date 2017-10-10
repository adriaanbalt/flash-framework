package com.balt.core.location
{
	import flash.events.IEventDispatcher;
	
	/**
	 * Interface for LocationManager.
	 *  
	 * @author adriaan scholvinck
	 */	
	public interface ILocationManager extends IEventDispatcher 
	{
		
		function changeLocation ( p_locationData: LocationData ): void;
		
		function setRootLocation ( p_newRootLocation: LocationData ): void;
		
		function getCurrentLocationData ( ): LocationData;

	}
}