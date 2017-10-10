package com.balt.coreimplementation.data.dataInterface {
	import com.balt.core.data.IStorage;

	public interface INavStorage extends IStorage {
		function getNav():Array;
	}
}