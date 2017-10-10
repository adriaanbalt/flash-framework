package {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	// If necessary to extend another class, use composition instead of 
	// inheritance to dispatch event...this exercise is not shown.
	public class MySingletonClass extends EventDispatcher {
		protected static var initializing:Boolean = false;
		protected static var myInstance:MySingletonClass;

		public static const SINGLETON_ERROR_EVENT:String = "singleton_error_event";
								
		public function MySingletonClass () {
			if (!initializing) {
				//throw (new Event(Event.DEACTIVATE)); 
				throw (new Error(SINGLETON_ERROR_EVENT))
				//throw (new Event(MySingletonClass.SINGLETON_ERROR_EVENT));
				return;
			}
			initializing = false;

			// Do initialization here
		}

		public static function getInstance():MySingletonClass {
			if (!myInstance) {
				initializing = true;
				myInstance = new MySingletonClass();
			}
			return myInstance;
		}
	}
}