public class MergeSort<T extends Comparable<? super T>>
                                                 implements Sorter<T>
{
	private int MIN_SIZE; // min size to recurse, use InsertionSort
	public MergeSort()
	{
	     MIN_SIZE = 3;
	}

	public void setMin(int n)
	{
		MIN_SIZE = n;
	}

	public void sort(T[] a, int size)
	{
		T[] tempArray = (T[])new Comparable<?>[size];
		mergeSort(a,tempArray,0,size-1);
		
	}

	private void mergeSort(T[] a, T[] tempArray, int first, int last)
	{
		if(last-first < MIN_SIZE)
			insertionSort(a,first,last);
		else
		{
			if (first < last)
			{  // sort each half
			  int mid = (first + last)/2;// index of midpoint
			  mergeSort(a, tempArray, first, mid);  // sort left half array[first..mid]
			  mergeSort(a, tempArray, mid + 1, last); // sort right half array[mid+1..last]

				if (a[mid].compareTo(a[mid + 1]) > 0)      // Question 2, Chapter 9
			 	 	merge(a, tempArray, first, mid, last); // merge the two halves
			//	else skip merge step
			}
		}	   
		
	}

	private void merge(T[] a, T[] tempArray, int first, int mid, int last)
	{
		int beginHalf1 = first;
		int endHalf1 = mid;
		int beginHalf2 = mid + 1;
		int endHalf2 = last;

		// while both subarrays are not empty, copy the
	   // smaller item into the temporary array
		int index = beginHalf1; // next available location in
								            // tempArray
		for (; (beginHalf1 <= endHalf1) && (beginHalf2 <= endHalf2); index++)
	   {  // Invariant: tempArray[beginHalf1..index-1] is in order
	   
	      if (a[beginHalf1].compareTo(a[beginHalf2]) <= 0)
	      {  
	      	tempArray[index] = a[beginHalf1];
	        beginHalf1++;
	      }
	      else
	      {  
	      	tempArray[index] = a[beginHalf2];
	        beginHalf2++;
	      }  // end if
	   }  // end for

	   // finish off the nonempty subarray

	   // finish off the first subarray, if necessary
	   for (; beginHalf1 <= endHalf1; beginHalf1++, index++)
	      // Invariant: tempArray[beginHalf1..index-1] is in order
	      tempArray[index] = a[beginHalf1];

	   // finish off the second subarray, if necessary
		for (; beginHalf2 <= endHalf2; beginHalf2++, index++)
	      // Invariant: tempa[beginHalf1..index-1] is in order
	      tempArray[index] = a[beginHalf2];
		
	   // copy the result back into the original array
	   for (index = first; index <= last; index++)
	      a[index] = tempArray[index];
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
	// for smaller sizes to complete sort
	// remaining code in MergeSort class not shown
	// You must complete this class – in particular the methods
	// sort() and setMin()
}