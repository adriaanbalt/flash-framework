package com.balt.core.location
{
	import flash.events.IEventDispatcher;
	
	public interface ILocation extends IEventDispatcher
	{
		function init ( data:* = null ):void;
		
		function show ( p_locationStringArray:Array, p_depth:int, p_param:* = null):Boolean;
		
		function hide ( ):void;
		
		function getChild ():ILocation;
		
	}
}