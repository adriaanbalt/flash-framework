package com.balt.coreimplementation.nav {
	import flash.events.Event;

	/**
	 * @author adriaan scholvinck
	 */
	public interface INavigation
	{
		function init( $e : Event = null ) : void;		
		function stageResize( $e : Event = null ) : void;
		function alignment() : void;
		function update( $sectionid : Array ) : void;
	}
}
