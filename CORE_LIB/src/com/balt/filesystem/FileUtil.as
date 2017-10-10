// A collection of utilities for dealing with paths and files, and which depends on AIR.
// @author: bruce epstein
//
// Supported in AIR only
//
package com.balt.filesystem
{
	import com.balt.log.Log;
	import com.balt.text.TextUtil;
	import com.balt.util.PathUtil;
	
	import flash.filesystem.File;		// Supported in AIR only
	
	public class FileUtil extends PathUtil
	{
		
		public function FileUtil()
		{
			Log.traceMsg ("No real point in constructing the FileUtil class, as all the methods are static", Log.WARN);
		}
		
		// Ensure a folder exists.
		// Example:
		//  var myFolder:File   = ensureDirectoryExists(File.applicationStorageDirectory.resolvePath("media)",	"subfoldername");		
		public static function ensureDirectoryExists (baseFile:File, plusFolder:String):File {
			if (!baseFile) baseFile = File.applicationStorageDirectory;
			var dirToCheck:File = new File(baseFile.nativePath + File.separator + PathUtil.cleansePath(plusFolder));
			
			Log.traceMsg("ensureDirectoryExists: " + dirToCheck.nativePath, Log.VERBOSE);
			
		  	if (!dirToCheck.exists) {
		  		try {
					dirToCheck.createDirectory();
		  		} catch (err:Error) {
		  			Log.traceMsg("CATCH: ERROR: Can't create " + dirToCheck.nativePath, Log.ERROR, "DM9");
		  			return dirToCheck; // Won't really help....
		  		}
			}
			return dirToCheck;
		}

	
		// Extract the folder from a path (strip off the filename following the last path separator)
		public static function extractFolder(inPath:String, fileSep:String = null, includeTrailingSep:Boolean = true, trySlash:Boolean = true):String {
			if (!fileSep) {
				fileSep = File.separator;
			} 
			
			return PathUtil.extractFolder (inPath, fileSep, includeTrailingSep, trySlash);
		}
	}
}