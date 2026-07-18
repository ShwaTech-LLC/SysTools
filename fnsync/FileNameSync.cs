// Using statements for strings, dictionaries, and file system info
using System;
using System.Collections.Generic;
using System.IO;

// ShwaTech namespace scoping to avoid collissions with other tools
namespace ShwaTech.SysTools.FnSync;

/// <summary>
/// An index of files on the file system by length (in bytes).
/// </summary>
public class SizeIndex : Dictionary<long, FileInfo>
{
	/// <summary>
	/// Creates a new file size index collection.
	/// </summary>
	public SizeIndex() : base() { }
}

/// <summary>
/// Implements file name synchronization between two paths by file size (in bytes).
/// </summary>
public class SyncHandler
{
	/// <summary>
	/// Flag indicating if actions and errors should be reported to the console
	/// </summary>
	public static bool Verbose = false;

	/// <summary>
	/// Path separator character for path rebuilding. Defaults to MacOS/Linux.
	/// </summary>
	public static char PathSeparator = '/';

	/// <summary>
	/// The index of the master files directory (used to rename the targets).
	/// </summary>
	private SizeIndex _masterIndex = new SizeIndex();

	/// <summary>
	/// The index of the target files directory (renamed to match the masters).
	/// </summary>
	private SizeIndex _targetIndex = new SizeIndex();

	/// <summary>
	/// Options for enumerating the master and target directory trees to enable recursion.
	/// </summary>
	private static EnumerationOptions EnumerationOptions = new EnumerationOptions();

	/// <summary>
	/// Static constructor for the sync handler to set the recurse subdirectories flag.
	/// </summary>
	static SyncHandler()
	{
		EnumerationOptions.RecurseSubdirectories = true;
	}

	/// <summary>
	/// Creates a new file name synchronization handler.
	/// </summary>
	public SyncHandler()
	{
	}

	/// <summary>
	/// Clears the index collections on destruction of the sync handler instance.
	/// </summary>
	~SyncHandler()
	{
		_masterIndex.Clear();
		_targetIndex.Clear();
	}

	/// <summary>
	/// Gets or sets the master path (file names to reference) of files.
	/// </summary>
	public string MasterPath { get; set; } = Directory.GetCurrentDirectory();

	/// <summary>
	/// Gets or sets the target path (file names to be changed) of files.
	/// </summary>
	public string TargetPath { get; set; } = Directory.GetCurrentDirectory();

	/// <summary>
	/// Determines whether or not both paths, master and target, exist.
	/// </summary>
	/// <returns>True if both paths exists, otherwise False.</returns>
	public bool PathsExist()
	{
		return Directory.Exists(MasterPath) && Directory.Exists(TargetPath);
	}

	/// <summary>
	/// Updates file names in the target path to match the file names in the master path.
	/// </summary>
	public void SyncNames()
	{
		// Stop if MasterPath and TargetPath are identical
		if (String.Equals(MasterPath, TargetPath, StringComparison.OrdinalIgnoreCase)) return;

		// Get the master files
		IndexFiles(ReadTree(MasterPath), ref _masterIndex);
		if (_masterIndex.Count <= 0) return;

		// Get the target files
		IndexFiles(ReadTree(TargetPath), ref _targetIndex);
		if (_targetIndex.Count <= 0) return;

		// Rename the target files
		foreach (long size in _masterIndex.Keys)
		{
			if (_targetIndex.ContainsKey(size))
			{
				SyncName(_masterIndex[size], _targetIndex[size]);
			}
		}
	}

	/// <summary>
	/// Reads a directory tree and returns all files recursively.
	/// </summary>
	/// <param name="path">The absolute path to the directory tree.</param>
	/// <returns>A file info array with all files contained in the directory tree.</returns>
	private static FileInfo[] ReadTree(string path)
	{
		try
		{
			var dir = new DirectoryInfo(path);
			return dir.GetFiles("*", EnumerationOptions);
		}
		catch { return null; }
	}

	/// <summary>
	/// Builds the index of files using the file length as the lookup key.
	/// </summary>
	/// <param name="files">An array of files in a directory tree.</param>
	/// <param name="index">An index object to be populated with the files.</param>
	private static void IndexFiles(FileInfo[] files, ref SizeIndex index)
	{
		// Stop if the files collection is empty
		if (files == null) return;
		if (files.Length <= 0) return;

		// Iterate each file and index it based on its length (in bytes) ignoring duplicates
		foreach (FileInfo file in files)
		{
			long length = file.Length;
			if (index.ContainsKey(length))
			{
				// Report the duplicate file, by size, if Verbose was specified
				if (Verbose) Console.WriteLine("Warning: {0} length identical to {1}", file.FullName, index[length].FullName);
			}
			else
			{
				index.Add(length, file);
			}
		}
	}

	/// <summary>
	/// Renames a target file to match a master file if the file names are not already identical.
	/// </summary>
	/// <param name="master">The master file.</param>
	/// <param name="target">The target file to be renamed as the master file.</param>
	private static void SyncName(FileInfo master, FileInfo target)
	{
		// No change needed if the file names are already the same
		if (String.Equals(master.Name, target.Name, StringComparison.Ordinal)) return;

		// Compose the destination path of the renamed file
		var dest = $"{target.Directory.FullName}{PathSeparator}{master.Name}";

		// Avoid faults if a file with the same name already exists
		if (File.Exists(dest))
		{
			if (Verbose) Console.WriteLine("Warning: cannot rename {0} to {1} because target exists", target.FullName, dest);
			return;
		}

		// Report the move if Verbose is enabled and rename the file
		if (Verbose) Console.WriteLine("Action: renaming {0} to {1}", target.FullName, dest);
		target.MoveTo(dest);
	}
}