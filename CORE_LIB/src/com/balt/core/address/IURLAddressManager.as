package com.balt.core.address
{
	import flash.events.IEventDispatcher;
	
	public interface IURLAddressManager extends IEventDispatcher
	{
		function setCurrentLocation( location:String ):void;
		
		function getCurrentLocation ( ) : Array;
		
		function setTitle ( $string : String ) : void;
		
		function getTitle ( ) : String;
		
		function setValue ( $string : String ) : void;
		
		function getValue ( ) : String;
	}
}