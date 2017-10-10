package
{
	import MySingletonClass;
	
	public class SingletonTest
	{
		public function SingletonTest()
		{
			var foo:MySingletonClass;
			var foo2:MySingletonClass;
			var err:*;
			try {
				foo = new MySingletonClass();
			} catch (err:Error) {
				trace ("Error: Can't construct a singleton directly. Use getInstance()");
			}
			foo = MySingletonClass.getInstance();
			foo2 = MySingletonClass.getInstance();
			if (foo == foo2) {
				trace ("The instances are the same, as expected for a Singleton");
			} else {
				trace ("Something is wrong. Singleton instances should be the same");
			}
		}
	}
}
