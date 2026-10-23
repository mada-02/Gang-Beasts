using System.Collections.Generic;

// Every test suite, by name (the -devtest argument).
public static class DevTestSuites
{
	private static List<DevTestSuite> all;

	public static DevTestSuite Find(string name)
	{
		if (all == null)
		{
			all = new List<DevTestSuite>();
			all.Add(SmokeTests.Suite());
		}
		foreach (DevTestSuite suite in all)
		{
			if (suite.name == name)
			{
				return suite;
			}
		}
		return null;
	}
}
