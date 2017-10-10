package com.balt.core.location
{
	import com.balt.core.log.Log;
	import com.balt.text.TextUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * Implements a location manager. A location manager controls the centralized navigation
	 * inside the site. It also takes care of telling the history manager about the changs.
	 * 
	 * @author adriaan scholvinck
	 * 
	 */
	public class LocationManager extends EventDispatcher implements ILocationManager
	{	
		// The root location that we use to start loading things
		private var _rootLocationData			: LocationData;
		
		// The stack of locations
		private var _locationDataStack			: Array;
		
		// The location that we are changing to
		private var _newLocationData			: LocationData;
		
		// The deepest common parent location index in the location arrays of the 
		// new location and the current location
		private var _deepestCommonParentIndex	: int;
		
		// What depth are we during the location changing process. the value will
		// change from the depth of the open location all the way up to the common
		// parent location and then down to the depth of the new location. So that
		// to change from "a/b/c" to "a/d/e" the currentDepth will change through
		// the following values: 2 (hide c), 1 (hide b), 1 (show d), 2 (show e). 
		private var _currentDepth				: int;
		
		// The location that we are handling at the moment. This is usually the place
		// that a location is stored between calls and events taht we are waiting for.
		private var _currentLocation			: ILocation;
		
		// Whether the locationManager is busy in the middle of a location change.
		private var _isChanging					: Boolean;
		private var _pendingAction				: Action
		
		public function LocationManager( )
		{
			init();
		}
		
		private function init ( ) :void {
			_isChanging = false;
			_locationDataStack = new Array();
		}
		
		/*
		 * 
		 * PUBLIC METHODS
		 * 
		 */
		
		/**
		 * Change the location. The LocationManager will change to the location
		 * in the locationString corresponding to this instances depth as defined
		 * in the constructor. It is important to note that location changes might
		 * take some time to finish and that repeated calls will not execute before
		 * the current change is finished and only the last call will be executed
		 * once that happens. This does not apply to http and javascript calls which
		 * get executed at any time, even when the class is busy changing locations.
		 * 
		 * @param locationData information about the location that needs to be changed to.
		 * 
		 */
		public function changeLocation ( p_locationData: LocationData ): void {
			if ( this._rootLocationData == null ) {
				output( " Exception: LocationManager.changeLocation() member variable rootLocation is null. Please call setRootLocation first" );
			}
			handleChangeLocation ( p_locationData );
		}
		
		public function setRootLocation ( p_newRootLocation: LocationData ): void {
			
			_rootLocationData = p_newRootLocation;
			
			this.dispatchEvent( new Event( LocationManagerConstants.EVENT_ON_ROOT_LOCATION_CHANGE ) ); 
			
		}
		
		
		/**
		 * Retruns the topmost LocationData object from the stack. If there are no items on the stack
		 * the method returns the rootLocationData.
		 * 
		 */
		public function getCurrentLocationData ( ): LocationData {
			if ( this._locationDataStack.length == 0 ) {
				return this._rootLocationData;
			} else {
				return LocationData( this._locationDataStack[this._locationDataStack.length-1] );
			}
		}
		
		/*
		 *
		 * PRIVATE METHOD
		 *
		 */
		 
		/**
		 * Handles http requests. These are identified currently as any location. 
		 * @param locationData
		 * @return Boolean
		 * 
		 */
		private function handleHTTP ( locationData:LocationData ) : Boolean {
			var locationString:String = locationData.locationArray [0];
			if ( TextUtil.stringContains (locationString, "/") || TextUtil.stringContains (locationString, "\\")) {
				// If there is not stack parameter default to an new window.
				var stack:Boolean = locationData.stack;
				var request:URLRequest = new URLRequest ( locationString );

				if (stack) {
					try {
						navigateToURL(request, '_blank');
					} catch (e:Error) {
						output( "Cannot go to url: " + locationString );
					}
				} else {
					try {
						navigateToURL(request, '_parent');
					} catch (e:Error) {
						output( "Cannot go to url: " + locationString );
					}
				}
					
				return true;
			} else {
				return false;
			}
		}
		
		private function handleJavascript ( p_locationData: LocationData ) : Boolean {
			var locationString:String = p_locationData.locationArray[0];
			
			if (locationString.substr(0,11) == "javascript:") {
				var request:URLRequest = new URLRequest ( locationString );
				navigateToURL( request, '_top' );			
				return true;
			} else {
				return false;
			}
		}
		
		
		 
		private function handleChangeLocation ( p_locationData: LocationData ) : void {
			var locationData:LocationData = p_locationData;
			// Is the location a javascript url?
			if ( !handleJavascript ( locationData ) ) {
				
				// Is the location an http url?
				if ( !handleHTTP ( locationData ) ) {
					// None of the above
					// Check to see if the instance is int the middle of a change
					if ( this._isChanging ) {
						// It is in the middle of change
						
						// Test if the new location is different from the one that we are
						// currently changing to. We can test by checking if their
						// deepest common parent is less then the maximum of their lengths.
						
						var l1:int = locationData.locationArray.length;
						var l2:int = _newLocationData.locationArray.length;
						if ( l1 == l2 ) {
							var dcp:int = findDCP ( locationData.locationArray, _newLocationData.locationArray );
							if ( dcp < Math.max( l1, l2) ) {
								// Locations are different.
								
								// Store the function call
								// until we have finished changing the location. If we don't wait then
								// we might get wrong events back and mess up the process as some
								// locations might be in the middle of animations, etc
								
								// Queue the action for later excution
								_pendingAction = new Action ( this, this.handleChangeLocation, [p_locationData] );
							} else {
								// Location are the same.
								// Do nothing...
							}
						} else {
							// Location are different
							
							// Store the function call
							// until we have finished changing the location. If we don't wait then
							// we might get wrong events back and mess up the process as some
							// locations might be in the middle of animations, etc
							
							// Queue the action for later excution
							_pendingAction = new Action ( this, this.handleChangeLocation, [p_locationData] );
						}
					} else {
						
						// Not busy, so just handle the change
						handleAsLocation ( locationData );
						
					}
				}
			} 
		}
		
		private function handleAsLocation ( locationData:LocationData ):void {
			
			// We are now busy changing to another location.
			this._isChanging = true;
			
			// Check to see if the parameter passed is a locationString in the first
			// element of the locationArray. This is a common mistake and we might as
			// well correct if if identified. Also this is useful for when people have
			// link that can hold either an url or a location.
			
			// Check if the location has only one element or if the first element has a slash
			// in it, this is usually the case when people make the mistake or use it to swap
			// with urls
			if ( ( locationData.locationArray.length == 1 ) || (TextUtil.stringContains (locationData.locationArray[ 0 ], "/")) ) {
				// Split the only element and use that ( this is a safeguard for when people pass
				// only the whole location string and not an array ( i.e "product/n93" instead of 
				// ["products","n93"].
				locationData.locationArray = locationData.locationArray[0].toString().split("/");
			}
			
			// Store the new location
			this._newLocationData = locationData;
			
			// Find the deepest common parent location index on the locationArray of
			// the current location and the new location.
			var nla:Array = this._newLocationData.locationArray; // new location array.
			var cla:Array = getCurrentLocationData().locationArray; // current location array.
			
			// If we are forcing a location change, we unload all the current locations
			if ( this._newLocationData.forceChange ) {
				_deepestCommonParentIndex = -1;
			} else {
				_deepestCommonParentIndex = findDCP ( nla, cla );
			}
			
			// Check if there are any differences between the new and the old locations.
			// No difference means taht both location array have the same length and that 
			// the deepesa common parent indes is equal to this value minus one ( the same as
			// less then the length ). Thes, by inverting
			// the logic statement, if there are differences, then the deepest common parent
			// has to be lower than either one of the location lengths.
			if ( this._deepestCommonParentIndex < Math.max( nla.length, cla.length ) ) {
				// Hide all the locations that are below the deeper common location of the current location
				// and the new location.
				this.hideLocations();
			} else {
				
				this._isChanging = false;
			}
			
		}
		
		/**
		 * Compare two location and returns their deepest common parent. If the deepest common parent
		 * is -1 then the locations are different if the deepest common parent is equal to the maximum
		 * of the length of the locations then they are the same.
		 * 
		 * @param A Array location array
		 * @param B Array location array
		 * @return 
		 * 
		 */
		private function findDCP ( A:Array , B:Array ): int {
			var dcp: int;
			
			// First find the shortest locationArray length
			var sl:int = Math.min( A.length, B.length );
			
			// Traverse the arrays until a different location is found
			var i:int = 0;
			while (( A[i]==B[i])&&(i<=sl)) i++;
			dcp = i-1;
			
			return dcp;
		}
		
		/**
		 * Hide all the locations above the common parent. 
		 * 
		 */
		private function hideLocations ():void {
			
			// The current depth is the stack length
			var currentDepth:int = this._locationDataStack.length-1;
			
			// Check if there are any more locations left too, possibly, hide
			if ( currentDepth > this._deepestCommonParentIndex ) {
				// There are still locations that we could hide
				
				// Retrieve common parent location which is at the common parent index on the stack
				this._currentLocation = getCurrentLocationData().location;
				
				// Wait for the event that tells us that the location finished hiding
				this._currentLocation.addEventListener( LocationConstants.EVENT_ON_HIDE_FINISHED, onHideFinished );
				
				// Hide the location
				this._currentLocation.hide();
			} else {
				
				// We have reached the common parent location of the location we started
				// changing from and the new location. That is, we've hidden all the locations
				// that were not similar between the two locations.
				
				// End the recursion. Start showing the new locations
				
				// At this point, all locations below the deeper common location of the current and new
				// locations should have been hidden, we can now start to show all the new locations
				// that are below the common location
				this.showLocations();
			}
		}
		
		private function onHideFinished ( event: Event ) :void {
			// Stop listening to the event.
			this._currentLocation.removeEventListener( LocationConstants.EVENT_ON_HIDE_FINISHED, onHideFinished );
			
			// Remove the location from the stack
			this._locationDataStack.pop();
			
			// Keep on hiding locations. Note that this recursion will end when
			// we reach a common location to the new location or when the stack of 
			// locations is empty.
			this.hideLocations();
		}
		
		private function showLocations (): void {
			// The current depth is the stack length
			var currentDepth:int = this._locationDataStack.length;

			if ( currentDepth <= this._newLocationData.locationArray.length ) {
				
				// Retrieve common parent location which at this point should be at the top of the stack
				_currentLocation = this.getCurrentLocationData().location;
				
				// Wait for the event after the call to show()
				_currentLocation.addEventListener( LocationConstants.EVENT_ON_SHOW_FINISHED, onShowFinished );
				
				// Call the show method on the current location with the new location which is the next
				// depth on the locationArray.
				var canHandle:Boolean = _currentLocation.show( this._newLocationData.locationArray, 
										 					   currentDepth,
															   this._newLocationData.param );
				
				// If the location can handle the call then we'll wait for the on show finished event,
				// but if the location cannot handle this call when we remove the listener and stop
				// the show sequece.
				if ( ! canHandle ) {
					_currentLocation.removeEventListener( LocationConstants.EVENT_ON_SHOW_FINISHED, onShowFinished );
					
					finishedChangingLocation ();
				}
			} else {
				finishedChangingLocation ();
			}
		}
		
		/**
		 * event.target can be instance of ILocation, in which case, we use that location
		 * as the child location.
		 * 
		 * Or it can be an instance of LocationData, in which case we can:
		 * 
		 * 1 - if LocationData.location has an instance in it, that is used as the next level of the
		 * deep link. That next level is named after the last item on the LocationData.locationArray
		 * of a default name.
		 * 
		 * 2 - Or we'll assume we've reached a final destination but will use that info for the 
		 * final steps of changing location. 
		 * 
		 * @param event Event
		 * 
		 */
		private function onShowFinished ( event:Event ) :void {
			// Stop listening to the event
			this._currentLocation.removeEventListener( LocationConstants.EVENT_ON_SHOW_FINISHED, onShowFinished );
			
			// Store any parameter.
			var child:ILocation = ILocation(event.target).getChild();
			if (child != null) {
				handleChildLocation(child);
				
			} else if (child is LocationData) {
	
				// Received a LocationData
				var locationData : LocationData = LocationData(child);
				
				if (locationData.location == null){
					
					// There's no location present so just finish changing location but use the
					// data passed back
					//output("locationData.location is undefined - finish change location with new params","onShowFinished()");
					var evtLocData : LocationData = LocationData(child);
					// Copy a new metrics directive is one was passed
					if (evtLocData.track != null) getCurrentLocationData().track = evtLocData.track; 
					finishedChangingLocation();
					
				} else {
					
					// There's a location present, use that as the next level of the location change
					// and use the value on the locationArray as the label for that level
					//output("locationData.location has child location - continue deeper","onShowFinished()");
					
					if (locationData.locationArray) {
						
						locationData.locationArray = this._locationDataStack[this._locationDataStack.length-1].locationArray.concat(locationData.locationArray);
						this._newLocationData = locationData;
						
					} else {
					
						// If there is a new param on the location data, transfer that to
						// the new location data anyway so that sections can pass params
						// down to child locations.
						
						if (locationData.param) {
		                    this._newLocationData.param = locationData.param;
		                }
	                
					}
	
					handleChildLocation(locationData.location);
					
				}
			} else {
				output("child location is undefined - ending showing locations","onShowFinished()");
				finishedChangingLocation();
			}
		}
		
		/**
		 * Handles a child location received back on the ON_SHOW_FINISHED event.
		 */
		private function handleChildLocation(childLocation:ILocation):void {
			// Check if we need to go further on the location chain
			var currentDepth:int = _locationDataStack.length;
			var newDepth:int = _newLocationData.locationArray.length;
			if (currentDepth<newDepth) {
				var childLocationArray:Array = _newLocationData.locationArray.slice(0,currentDepth+1);
				var childLocationData:LocationData = new LocationData(childLocationArray,
														 			  this._newLocationData.stack,
														 			  this._newLocationData.track,
														 			  this._newLocationData.param);
														 			  
				childLocationData.location = childLocation;
				this._locationDataStack.push( childLocationData );
				output("child location=" + childLocationData,"onShowFinished()");
				this.showLocations();
			} else {
				output("reached end of location depth - ending showing locations","onShowFinished()");
				finishedChangingLocation();
			}
		}
		
		
		private function finishedChangingLocation ( ):void {
			// Dispatch the event about the change in location
			this.dispatchEvent( new Event ( LocationManagerConstants.EVENT_ON_LOCATION_CHANGE ) );
			
			// Set the flag to indicate that the instance is done changing locations
			this._isChanging = false;
			
			// Fire any pending action
			if ( this._pendingAction != null ) {
				var tempPendingAction:Action = this._pendingAction;
				this._pendingAction = null;
				tempPendingAction.execute();
				tempPendingAction = null;
			}
		}

		/**
		 * DEBUG METHODS
		 */
		private function output ( p_text:String, p_method:String = null ):void {
			if ( p_method != null ) {
				Log.debug( "LocationManger." + p_method + ": " + p_text );
			} else {
				Log.debug( "LocationManger: " + p_text );
			}
		}
		
		public function get newLocationData ():LocationData {
			return this._newLocationData;
		}
	}
}