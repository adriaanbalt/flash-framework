package com.balt.coreimplementation.data.dataInterface {
	import com.balt.core.data.IStorage;

	public interface ILocationStorage extends IStorage {
		function getArray():Array;
		function getDefault():String;
	}
}