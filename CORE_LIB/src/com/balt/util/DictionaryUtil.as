package com.balt.util
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	/**
	 * 
	 * Utility class for flash built in Dictionary class.
	 * 
	 */
	public class DictionaryUtil
	{
		private var _dictionary:Dictionary;
		private var _map:Object;
		private var _classMap:Class;
		
		/**
		 * 
		 * @param p_mapClass
		 * @param p_useWeakReferences
		 * @usage <code>
		 * 	var du:DictionaryUtil = new DictionaryUtil ( Person );
		 *  var p:Person = new Person ( myName, myAge );
		 *  du.addItem ( p );
		 *  var p1:Person = Person( du.getItem ( "name", myName ) );
		 * </code>
		 * 
		 */
		public function DictionaryUtil( p_mapClass:Class, p_useWeakReferences:Boolean = true)
		{
			_dictionary = new Dictionary ( p_useWeakReferences );
			
			_map = {};
			_classMap = p_mapClass;
			
			// get xml descriptor of the class
			var description:XML = flash.utils.describeType( _classMap );
			var item:XML;
			
			// add the properties to the map object
			for each ( item in description..accessor) {
				_map [ item.@name ] = null;
				_map.setPropertyIsEnumerable( item.@name, true );
			}
			
			for each (item in description..variable ) {
				_map [item.@name] = null
				_map.setPropertyIsEnumerable( item.@name, true );
			}
		}
		
		/**
		 * Add an item to the dictionary increasing the key automatically; this is done
		 * because the key isn't needed in order to get an object contained in the dictionary
		 * @param p_value *
		 */
		public function addItem ( p_value:* , id:String) :void {
			
			_dictionary[id] = p_value;
			
		}
		
	   /**
        * Recover an item of the _dictionary searching for a specific value for
        * a property mapped in the map object
        * @param key String
        * @param value *
        * @return *
        */
        public function getItem(key:String, value:*) : * {
        	var item:*;
        	
            if(!_map.propertyIsEnumerable(key)){
                 
                 throw new Error("The property is not defined on the map object");
                 
             }
        
            for (var k:* in _dictionary){
                
                if((_dictionary[k] as _classMap)[key] === value){
                    
                    item = _dictionary[k];
                    break;
                    
                }
                
            }
            
            return item;
        
        }
        
        /**
         * 
         * Recover an item of the _dictionary searching by a _dictionary's key 
         * @param key String
         * @return *
         * 
         */        
        public function getItemByKey ( key:String ) : * {
        	var item:*;
        	item = _dictionary[key];
        	return item;
        }
        
        /**
        * Remove all the entries from the Dictionary
        */ 
        public function purgeAll():void{
            
            for (var key:* in _dictionary){
                
               delete _dictionary[key];
            
            }

            
        }
       
       /**
        * Delete an item from the Dictionary; the item needs to have 
        * a specific value for a specific propery mapped on the map
        * @param key *
        */
        public function remove(key:String, value:*) : void{
            
            if(!_map.propertyIsEnumerable(key)){
                 
                 throw new Error("The property is not defined on the map object");
                 
             }
            
            for (var k:* in _dictionary){
                
                if((_dictionary[k] as _classMap)[key] === value){
                    
                    delete _dictionary[k];
                    break;
                    
                }
                
            }
            
        }
        
        public function removeByKey (key:String):void {
        	delete _dictionary[key];
        }
        
        /**
         * Return the entries of the Dictionary
         * @return Array
         */ 
        public function getEntries():Array {
           
            var list:Array = new Array();

            for (var key:* in _dictionary){
                
                list.push(_dictionary[key]);
                
            }
            
            return list;
            
        }
        
        public function get dictionary():Dictionary {
        	return _dictionary;
        }

    }
}