import mx.events.EventDispatcher;
/**
 * A class that fires 'onEnterFrame' every frame, with addListener and such
 * 
 * @author Patrick Mineault - 5etdemi.com
 */
class cinqetdemi.delay.OnEnterFrameBeacon 
{
	//AsBroadcaster functions
	public var addListener:Function;
	public var removeListener:Function;
	private var broadcastMessage:Function;
	private var _listeners:Array;
	
	//Singleton instance
	private static var inst:OnEnterFrameBeacon;
	
	/**
	 * Constructor
	 */
	private function OnEnterFrameBeacon()
	{
		//Check whether the enter frame beacon exists
		if (_root['__clibOnEnterFrameBeacon'] == null) 
		{
			//if not, create it
			var mc:MovieClip = _root.createEmptyMovieClip ("__clibOnEnterFrameBeacon", 98765);
			mc.beacon = this;
			mc.onEnterFrame = function () {
				//Broadcast a message to all listeners every frame 
				this.beacon.broadcastMessage('onTick');
			};
		}
		
		//Once AsBroadcaster is initialized, we can use broadcastMessage
		AsBroadcaster.initialize(this);
	}
	
	/**
	 * Singleton access point
	 */
	static function getInstance():OnEnterFrameBeacon
	{
		if(inst == null)
		{
			//Create singleton instance
			inst = new OnEnterFrameBeacon();
		}
		//Return the singleton instance
		return inst;
	}
}