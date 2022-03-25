// CS 0445 Spring 2021
// Assignment 4
// Your QuickSort and MergeSort classes should work correctly with this program
// without any changes.  Your output should exactly match that shown in the
// sample output file.  Read over the additional comments below to see how your
// sorting classes must be set up.  You can also get some hints about your main
// program (Assig4.java) implementation from this program.

import java.util.*;
public class SortTest
{
	public static Random R = new Random();
	
	// Sorter Data will be an ArrayList of Sorter<Integer> objects.
	private ArrayList<Sorter<Integer>> sorts;
	// Data to sort will be an array of Integer
	private Integer [] A;	
	private int size;
	
	// Fill array with random data
	public void fillArray()
	{
		for (int i = 0; i < A.length; i++)
		{
			// Values will be 0 <= X < 1 billion
			A[i] = new Integer(R.nextInt(1000000000));
		}
	}

	public void showArray()
	{
		for (int i = 0; i < A.length; i++)
		{
			System.out.print(A[i] + " ");
		}
		System.out.println("\n");
	}

	public SortTest(String sz)
	{
		size = Integer.parseInt(sz);
		
		// Put the sorting objects into the ArrayList.  Note how each object is being
		// created.  The QuickSort<T> objects are passed implementations of the
		// Partitionable<T> interface in order to allow the 3 different ways of 
		// partitioning the data.
		sorts = new ArrayList<Sorter<Integer>>();
		sorts.add(new QuickSort<Integer>(new SimplePivot<Integer>()));
		sorts.add(new QuickSort<Integer>(new MedOfThree<Integer>()));
		sorts.add(new QuickSort<Integer>(new RandomPivot<Integer>()));
		sorts.add(new MergeSort<Integer>());
		
		A = new Integer[size];
		
		// Iterate through all of the sorts and test each one
		for (int i = 0; i < sorts.size(); i++)
		{
			R.setSeed(123456);  // This will enable all sorts to use the same data.  If
					// you have multiple runs with the same algorithm you should only
					// set this one time for each algorithm so that the different runs
					// will have different data.
			fillArray();
			System.out.print("Initial data: ");
			showArray();
			// Get the current Sorter<T> object, set the min and sort the data
			sorts.get(i).setMin(5);
			sorts.get(i).sort(A, A.length);
			System.out.print("Sorted data: ");
			showArray();
			System.out.println();
		}
	}
					
	public static void main(String [] args)
	{
		new SortTest(args[0]);
	}
}
