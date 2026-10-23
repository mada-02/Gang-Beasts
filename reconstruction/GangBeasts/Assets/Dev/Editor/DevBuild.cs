using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

// Batch-mode player build for the developer-branch tests:
//   Unity.exe -batchmode -quit -projectPath <GangBeasts> -executeMethod DevBuild.BuildPlayer
//             -devbuildout <path\GangBeastsDev.exe> [-devbuildrelease]
// Builds every enabled scene in EditorBuildSettings order (Intro first, as in the game) as a
// development player unless -devbuildrelease is given. Exits 0 on success, 1 on failure.
public static class DevBuild
{
	public static void BuildPlayer()
	{
		string output = Arg("-devbuildout");
		if (output == null)
		{
			Debug.LogError("DevBuild: -devbuildout <path to exe> is required");
			EditorApplication.Exit(1);
			return;
		}
		List<string> scenes = new List<string>();
		foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
		{
			if (scene.enabled)
			{
				scenes.Add(scene.path);
			}
		}
		BuildOptions options = HasArg("-devbuildrelease") ? BuildOptions.None : BuildOptions.Development;
		string error = BuildPipeline.BuildPlayer(scenes.ToArray(), output, BuildTarget.StandaloneWindows, options);
		if (!string.IsNullOrEmpty(error))
		{
			Debug.LogError("DevBuild failed: " + error);
			EditorApplication.Exit(1);
			return;
		}
		Debug.Log("DevBuild OK: " + output + " (" + scenes.Count + " scenes, " + options + ")");
		EditorApplication.Exit(0);
	}

	private static string Arg(string name)
	{
		string[] args = Environment.GetCommandLineArgs();
		for (int i = 0; i < args.Length - 1; i++)
		{
			if (args[i] == name)
			{
				return args[i + 1];
			}
		}
		return null;
	}

	private static bool HasArg(string name)
	{
		return Array.IndexOf(Environment.GetCommandLineArgs(), name) >= 0;
	}
}
