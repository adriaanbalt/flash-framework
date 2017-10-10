package com.balt.core.data.dataInterface {
	import com.balt.core.data.IStorage;

	public interface IMainStorage extends IStorage {
		function getArray():Array;
		function getDefault():String;
	}
}