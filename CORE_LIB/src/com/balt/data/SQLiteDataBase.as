/*
	SQLiteDataBase.as

	@author: bruce epstein
	
*/ 
package com.balt.data
{
	import com.balt.filesystem.FileUtil;
	import com.balt.log.Log;
	import com.balt.text.TextUtil;
	
	import flash.data.SQLColumnSchema;
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.errors.SQLError;
	
	public class SQLiteDataBase extends EventDispatcher
	{
		private var _connection:SQLConnection;
		private var _sqlQuery:SQLStatement;
		
		public static const TYPE_VARCHAR:String 	= "VARCHAR";  // Same as "TEXT" in most cases?
		public static const TYPE_INTEGER:String 	= "INTEGER";  
		public static const TYPE_BOOLEAN:String 	= "INTEGER"; // No support for BOOLEAN type in SQLite Manager?
		public static const TYPE_DATETIME:String 	= "DATETIME";
		
		public static const ROW_ID_ERROR:int = 0; // A row id of zero indicates an error
		
		public function SQLiteDataBase() {
			// empty constructor
		}
		
		
		// SQLite DB for an AIR project would ordinarily be stored in something like:
		// For Vista:
		//   C:\users\USERNAME\AppData\Roaming\com.domainserving_air_app.com\xxxx\Local Store
		// where xxxx is tied to the certificate used to sign the application
		// For XP:
		//   C:\Documents and Settings\EpsteinB\Application Data\CMLAdBoardAIR\Local Store\db\cml.sqlite
		//  
		
		public function open (sqliteDB:File, createMissingFile:Boolean=false):void
		{
			Log.traceMsg("Opening database " + sqliteDB.nativePath, Log.DEBUG);
			sqlQuery = new SQLStatement();
			connection = new SQLConnection();
			connection.addEventListener(SQLEvent.OPEN, openDBsuccessHandler);
		 	connection.addEventListener(SQLErrorEvent.ERROR, openDBerrorHandler);
		 	// Possible options are SQLmode.READ, SQLMode.UPDATE (Write), and SQLmode.CREATE (create if absent)
			if (sqliteDB.exists) {
				// Open an existing DB for writing
				try {
					connection.open(sqliteDB, SQLMode.UPDATE);
				} catch (err:SQLError) {
					Log.traceMsg("Error. Check if file " + TextUtil.quotes(sqliteDB.nativePath) +
								 " is already existing as a directory!: " + err.message, Log.ERROR);
				
				} catch (err2:Error) {
					Log.traceMsg("Error opening " + TextUtil.quotes(sqliteDB.nativePath) + err2.message, Log.ERROR);
				}
			} else {
				Log.traceMsg ("SQLite file at " + TextUtil.quotes(sqliteDB.nativePath) + " doesn't exist.", Log.ALERT);
				if (createMissingFile) {
					// Create it if it doesn't exist
					try {
						var thisFolder:String = FileUtil.extractFolder (sqliteDB.nativePath); 
						FileUtil.ensureDirectoryExists(new File(thisFolder), "");
						Log.traceMsg ("Trying to create SQLite file at " + sqliteDB.nativePath, Log.WARN);
						connection.open(sqliteDB, SQLMode.CREATE);
					} catch (err:Error) {
						Log.traceMsg("Catch: Unable to open or create SQLite DB. Expect the application to fail: " + err.message, Log.ALERT);
					}
				}
			}
		}
		
		private function openDBsuccessHandler (evt:SQLEvent):void
		{
			Log.traceMsg("Successfully opened db: " +  evt.type, Log.DEBUG);
			dispatchEvent (new Event(Event.COMPLETE));
		}
		
		private function openDBerrorHandler( evt:SQLErrorEvent ):void
		{
			Log.traceMsg("DataBase Load Error: " +  evt.type, Log.ERROR);
			dispatchEvent (new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		/**
		 * Execute an SQL statement on the SQLite database opened via open() method.
		 * The operation is carried out in synchronous mode - if an error occurs, an Exception will be thrown.
		**/
		public function executeSQL(query:*) : SQLResult
		{
			sqlQuery.text = query;
			sqlQuery.sqlConnection = connection;
			try {
				sqlQuery.execute();
			} catch (err:Error) {
				Log.traceMsg("Catch: ERROR ****** executeSQL failed for some reason: '" + query + "'", Log.ERROR);
				Log.traceMsg("Catch: Reason is: '" + err.message + "'", Log.ERROR);
			}
			return sqlQuery.getResult();
		}
		
		/**
		 * Get all records in a particular table.
		 * The operation is carried out in synchronous mode - if an error occurs, an Exception will be thrown.
 		**/
		public function getTable(name:String):Array
		{
			return sqlDataOrEmptyArray("SELECT * FROM " + name);
		}
		
		/**
		 * Return all records in a table whose 'id' value matches a particular value
		 * The operation is carried out in synchronous mode - if an error occurs, an Exception will be thrown.
 		**/
		public function getItemById(table:String, id:uint):Object {
			var resultData:Array = sqlDataOrEmptyArray("SELECT * FROM " + table + " WHERE " + table + ".id=" + id)
			if (resultData.length) {
				return resultData[0];
			} else {
				return null;
			}
		}
		
		
		// Delete an item from the specified table with no warning!
		// FIXME - provide an optional warning/confirmation.
		public function deleteItem(table:String, id:int) : SQLResult
		{
			Log.traceMsg ("Deleting matching record for id " + id + " from table " + table, Log.WARN);
			Log.traceMsg ("Deleting: " + String(getItemById (table, id)));
			return executeSQL("DELETE FROM " + table + " WHERE id=" + id);
		}
		
		
		// Select items from a table with the specified key value
		public function getItemsWithColumn(table:String, key:String, value:*):Array 
		{
			if (value is String) {
				value = TextUtil.quotes(value);
			}
			return sqlDataOrEmptyArray("SELECT * FROM " + table + " WHERE " + table + "." + key + "=" + value);
		}
		
		
		// Replace a particular column value for a given record id in the specified table.
		public function updateColumnInTableWithId( table:String, column:String, value:*, row_id:int ):SQLResult
		{
			return executeSQL("UPDATE " + table + " SET " + column + "=" + TextUtil.quotes(value) + " WHERE id=" + row_id);			
		}
		    	
		
		// Retrieve the db schema for all tables
		public function getAllSchema ():SQLSchemaResult {
			connection.loadSchema(SQLTableSchema, null);
			return connection.getSchemaResult();
		}
		
		
		// Retrieve the db schema for a particular table
		public function getSchemaForTable (table:String):SQLSchemaResult {
			connection.loadSchema(SQLTableSchema, table);
			return connection.getSchemaResult();
		}


		// Check if a table exists
		public function tableExists (table:String):Boolean {
			var tableSchema:SQLSchemaResult;
			
			try {
				tableSchema = getSchemaForTable(table);
				var readTable:SQLTableSchema = getFirstTableFromSchema(tableSchema);
				if (readTable.name == table) {
					return true;
				} else {
					//Log.traceMsg("Unexpected table name in tableExists: " + readTable.name);
					return false;
				}
			} catch (err:Error) {
				// FIXME - could be more sophisticated about this
				Log.traceMsg("Catch: Error in tableExists: " + table, Log.ALERT_DEBUG); 
				return false;
			}
			return true;
		}
		
		
		public function getFirstTableFromSchema (tableSchema:SQLSchemaResult):SQLTableSchema {
			return tableSchema.tables[0] as SQLTableSchema;
		}
		
		
		// Add a new table.
		// FIXME - should it check if table exists before trying to add it? Or is that caught as an error?
		public function addTable (tableName:String, columSpec:String): Boolean {
			var commandTxt:String;
			var resultSQL:SQLResult;
			var resultData:Array;
			commandTxt = "CREATE TABLE " + tableName + columSpec;
			resultSQL = executeSQL(commandTxt);
			if (resultSQL.complete) {
				Log.traceMsg("addTable: Added table " + tableName + " successfully", Log.DEBUG);
				return true;
			} else {
				Log.traceMsg("addTable: Failed to add table " + tableName + ":" + 
								resultSQL.complete, Log.DEBUG);
				return false;
			}
		}
		
		
		// Returns array of SQLColumnSchema, from which columns can be discerned
		public function getColumnsFromTable (tableName:String):Array {
			if (!tableExists(tableName)) {
				return []; // empty array if table doens't exist
			} else {
				return getFirstTableFromSchema(getSchemaForTable(tableName)).columns;
			}
		}
		
		
		// Check whether a column exists in the specified table. 
		// FIXME - what happens if the table doesn't exist?
		public function columnExistsInTable (tableName:String, columnName:String):Boolean {
			var columnsArray:Array
			var thisColumn:SQLColumnSchema;

			columnsArray = getColumnsFromTable(tableName);
			for each (thisColumn in columnsArray) {
				if (thisColumn.name == columnName) {
					Log.traceMsg("columnExistsInTable: column " + columnName + 
									" found in table " +  tableName, Log.INFO);
					return true;
				}
			}
			Log.traceMsg("columnExistsInTable: column " + columnName + 
							" NOT found in table " + tableName, Log.WARN);
			return false;
		}
		
		
		// Add a column to a table.
		// FIXME - what happens is the column already exists? - you should use ensureColumnInTable()
		public function addColumnToTable (tableName:String, columnName:String, dataType:String): Boolean {
			var commandTxt:String;
			var resultSQL:SQLResult;
			var resultData:Array;
		
			commandTxt = "ALTER TABLE " + tableName + " ADD " + columnName + " " + dataType;
			resultSQL = executeSQL(commandTxt);
			if (resultSQL.complete) {
				Log.traceMsg("addColumnToTable: Added field " + columnName +  
							" to table " + tableName + " successfully", Log.DEBUG);
				return true;
			} else {
				Log.traceMsg("addColumnToTable: Failed to add field " + columnName +  " to table " + 
								tableName + ":" + resultSQL.complete, Log.DEBUG);
				return false;
			}
		}
		
		
		
		// Add the specified table if it doesn't exist
		// Examples for creating tables (shows you how to specify colunmSpec)
		// id is an alias for "row_id". See http://www.sqlite.org/lang_createtable.html
		// ensureTable("myTableName", 
		// "(id INTEGER PRIMARY KEY ASC, used_id INTEGER, icon_id VARCHAR, icon_set VARCHAR, cal_date DATETIME)");
		//
		// ensureTable(TABLE_MESSAGE_ICONS, 
		// "(id INTEGER PRIMARY KEY ASC, message_id INTEGER, icon_id VARCHAR, icon_set VARCHAR, x_loc INTEGER, y_loc INTEGER)");
	
		public function ensureTable (tableName:String, columnSpec:String):Boolean {
			var success:Boolean;
			if (!tableExists(tableName)) {
				success = addTable(tableName, columnSpec);
				if (success) {
					Log.traceMsg("SQLiteDataBase.ensureTable: Successfully added fields " + columnSpec +  " to table " + 
								tableName, Log.INFO)
				} else {
					Log.traceMsg("SQLiteDataBase.ensureTable: Couldn't add fields " + columnSpec +  " to table " + 
								tableName + " so problems may occur", Log.ALERT);
				}
				return success;
			} else {
				Log.traceMsg("SQLiteDataBase.ensureTable: table " + tableName + " already exists", Log.INFO);
				return true;
			}	
		}
		
		
		// Add the specified column to the specified table if it doesn't exist.
		// Here are some examples:
		// ensureColumnInTable("existingTableName", "columnNameToAddIfNeeded, TYPE_VARCHAR);
		// dataType can be TYPE_INTEGER, TYPE_BOOLEAN, TYPE_VARCHAR, or TYPE_DATETIME (others supported by SQLite?)	
		public function ensureColumnInTable (tableName:String, columnName:String, dataType:String):Boolean {
			var success:Boolean;
			if (!columnExistsInTable(tableName, columnName)) {
				success = addColumnToTable(tableName, columnName, dataType);
				if (success) {
					Log.traceMsg("SQLiteDataBase.ensureColumnInTable: Successfully added field " + columnName +  " to table " + 
								tableName, Log.INFO)
				} else {
					Log.traceMsg("SQLiteDataBase.ensureColumnInTable: Couldn't add field " + columnName +  " to table " + 
								tableName + " so problems may occur", Log.ALERT);
				}
				return success;
			} else {
				Log.traceMsg("DataBase.SQLiteDataBase: column " + columnName + " already exists in table " + tableName, Log.INFO);
				return true;
			}	
		}
		
		
		/**
		 * Closes the database connection.
		 * Call this method before removing the instance.
		 * The connection can't be re-opened - just create a new reference instead.
		**/
		public function close():void
		{
			if (connection.connected) {
				connection.close();
			}
		}
		
		
		// Convenience functions
		
		// Returns the .data property of the executed SQL statement,
		// or returns an empty array if no records were found.
		public function sqlDataOrEmptyArray(commandTxt:String):Array {
			var resultData:Array;
			var resultSQL:SQLResult;
			resultSQL = executeSQL(commandTxt);
			if (resultSQL) {
				resultData = resultSQL.data;
			}
			// Return an empty array if no results were found.
			if (resultData == null) {
				resultData = [];
			}
			return resultData;
		}
		
		
		protected function selectAllFromTable (tableName:String):String {
			return ("SELECT * FROM " + tableName + " "); 
		}
		

		// Return the string in quotes
		protected function q (inString:*):String {
			return TextUtil.quotes(inString);
		}
		
		// Return the string in quotes, followed by a comma - useful for concatenating string
		protected function qc (inString:*):String {
			return (q(inString) + ",");
		}
		
		// Useful for recording dates and times
		protected function now ():String {
			return "DATETIME('NOW')";
		}
		
		// Setters and getters
		public function set connection (val:SQLConnection):void {
			_connection = val;
		}
		
		public function get connection ():SQLConnection {
			return _connection;
		}
		
		public function set sqlQuery (val:SQLStatement):void {
			_sqlQuery = val;
		}
		
		public function get sqlQuery ():SQLStatement {
			return _sqlQuery;
		}
	}
	
}