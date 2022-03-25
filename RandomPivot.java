import java.lang.Math;

public class RandomPivot <T extends Comparable<? super T>>
                                                implements Partitionable<T>
{
	public int partition(T[] a, int first, int last)
	{
		int pivotIndex = (int)(Math.random()*(last-first-1)) + first;
		T pivot = a[pivotIndex];
	    int indexFromLeft = first; 
	    int indexFromRight = last - 1; 
	    swap(a,pivotIndex, last);
	    pivotIndex = last;

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
	}
	private void swap(T [] a, int i, int j)
	{
		T temp = a[i];
		a[i] = a[j];
		a[j] = temp; 
	} // end swap
}