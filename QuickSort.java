public class QuickSort<T extends Comparable<? super T>>
                                                implements Sorter<T>
{
	private Partitionable<T> partAlgo;
	private int MIN_SIZE;  // min size to recurse, use InsertionSort
	                       // for smaller sizes to complete sort
	public QuickSort(Partitionable<T> part)
	{
	      partAlgo = part;
	      MIN_SIZE = 3;
	}

	public void setMin(int n)
	{
		MIN_SIZE = n;
	}

	private void quick(T[] a, int first, int last)
	{
		if(last-first < MIN_SIZE)
			insertionSort(a,first,last);
		else
		{
			int pivotIndex = partAlgo.partition(a, first, last);
			//System.out.println("pivot index is " + pivotIndex);	
			quick(a,first,pivotIndex-1);
			quick(a, pivotIndex+1, last);
		}
	}

	private void insertionSort(T[] a, int first, int last)
	{
		int unsorted, index;
		
		for (unsorted = first + 1; unsorted <= last; unsorted++)
		{   // Assertion: a[first] <= a[first + 1] <= ... <= a[unsorted - 1]
		
			T firstUnsorted = a[unsorted];
			
			insertInOrder(firstUnsorted, a, first, unsorted - 1);
		}
	}

	private void insertInOrder(T element, T[] a, int begin, int end)
	{
		int index;
		
		for (index = end; (index >= begin) && (element.compareTo(a[index]) < 0); index--)
		{
			a[index + 1] = a[index]; // make room
		} // end for
		
		// Assertion: a[index + 1] is available
		a[index + 1] = element; 
	}

	public void sort(T[] a, int size)
	{
		quick(a,0,size-1);	
	}
}
// remaining code in QuickSort class not shown
// You must complete this class – in particular the methods
// sort() and setMin()  You will use partAlgo for partition
// within the sort() method.