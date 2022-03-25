public class SimplePivot <T extends Comparable<? super T>>
                                                implements Partitionable<T>
{
	
	public int partition(T[] a, int first, int last)
	{
	    int pivotIndex = last;  // simply pick pivot as rightmost element
	    T pivot = a[pivotIndex];
	    int indexFromLeft = first; 
	    int indexFromRight = last - 1; 

	    boolean done = false;
	    while (!done)
	    {
		while (a[indexFromLeft].compareTo(pivot) < 0)
		    indexFromLeft++;

		while (a[indexFromRight].compareTo(pivot) > 0 && indexFromRight > first)
		    indexFromRight--;

		if (indexFromLeft < indexFromRight)
		{
		    swap(a, indexFromLeft, indexFromRight);
		    indexFromLeft++;
		    indexFromRight--;
		}
		else 
		    done = true;
	    } // end while
	    swap(a, pivotIndex, indexFromLeft);
	    pivotIndex = indexFromLeft;
	    return pivotIndex; 
	}  // end partition

	private void swap(T [] a, int i, int j)
	{
		T temp = a[i];
		a[i] = a[j];
		a[j] = temp; 
	} // end swap

}