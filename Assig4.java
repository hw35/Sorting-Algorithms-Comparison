import java.util.*;

public class Assig4
{
	//private int size; private int numRuns; private boolean isSorted;
	private ArrayList<Sorter<Integer>> sorts;
	private double[] timeArr;
	//private double[] sumTime;
	private double[][] timeTable;
	private int[][] minRecResult;
	private Integer [] A;
	private static Random R = new Random();

	public void fillArray(boolean isSorted, int size)
	{
		if(isSorted)
		{
			for(int i = 1; i <= size; i++)
			{
				A[i-1] = i;
			}
		}
		else
		{
			for (int i = 0; i < size; i++)
			{
				A[i] = new Integer(R.nextInt(1000000000));
			}
		}
			
	}

	public void SortTest(int size, boolean isSorted, int minRec)
	{
	
		// Put the sorting objects into the ArrayList.  Note how each object is being
		// created.  The QuickSort<T> objects are passed implementations of the
		// Partitionable<T> interface in order to allow the 3 different ways of 
		// partitioning the data.
		

		//sumTime = new double[sorts.size()];



		//System.out.print(s);

		
		A = new Integer[size];
		
		// Iterate through all of the sorts and test each one
		for (int i = 0; i < sorts.size(); i++)
		{
			// R.setSeed(123456);  // This will enable all sorts to use the same data.  If
					// you have multiple runs with the same algorithm you should only
					// set this one time for each algorithm so that the different runs
					// will have different data.
			fillArray(isSorted, size);
			
			
			sorts.get(i).setMin(minRec);
			long start = System.nanoTime();
			sorts.get(i).sort(A, A.length);
			long stop = System.nanoTime();

			long diff = stop-start;
			double sec = (double) diff / 1000000000;

			timeArr[i] = timeArr[i]+sec;
			//sumTime[i] = sumTime[i]+sec;


		}
	}

	public Assig4(int size, boolean isSorted, int numRuns)
	{
		sorts = new ArrayList<Sorter<Integer>>();
		sorts.add(new QuickSort<Integer>(new SimplePivot<Integer>()));
		sorts.add(new QuickSort<Integer>(new MedOfThree<Integer>()));
		sorts.add(new QuickSort<Integer>(new RandomPivot<Integer>()));
		sorts.add(new MergeSort<Integer>());
		timeArr = new double[sorts.size()];
		int s = sorts.size();
		timeTable = new double[2][s];
		minRecResult = new int[2][s];

		for(int minRec = 5; minRec<=75; minRec+=10)
		{
			if(!isSorted)
				R.setSeed(123456);
			for(int j = 0; j < numRuns; j++)
			{
				SortTest(size,isSorted,minRec);
			
				
				// System.out.println("OUT ");
				// System.out.println(("is " + timeTable[0][0]));
			}
			for(int i = 0; i < sorts.size(); i++)
			{
				if(timeTable[0][i] == 0)
				{
					//System.out.println("Here 1 ");
					timeTable[0][i] = timeArr[i];
					timeTable[1][i] = timeArr[i];
					minRecResult[0][i] = minRec;
					minRecResult[1][i] = minRec;
					//System.out.println((timeTable[0][i]));

				}
				else if(timeArr[i] > timeTable[1][i])
				{
					//System.out.println("Here 2 ");
					timeTable[1][i] = timeArr[i];
					minRecResult[1][i] = minRec;
				}
				else if(timeArr[i] < timeTable[0][i])
				{
					timeTable[0][i] = timeArr[i];
					minRecResult[0][i] = minRec;
				}				
			}
			Arrays.fill(timeArr,0);	
		}
		double min = timeTable[0][0];
		int bestAlg = 0;
		for(int i = 1; i<timeTable[0].length; i++)
		{
			if(timeTable[0][i] < min)
			{
				min = timeTable[0][i];
				bestAlg = i;
			}
		}

		double max = timeTable[1][0];
		int worstAlg = 0;
		for(int i = 1; i<timeTable[0].length; i++)
		{
			if(timeTable[1][i] > max)
			{
				max = timeTable[1][i];
				worstAlg = i;
			}
		}
		//System.out.println("best alg is " + bestAlg);
		//System.out.println("worst alg is " + worstAlg);
		String[] algorithms = new String[]{"Simple Pivot QuickSort", "Median of Three QuickSort" , "Random Pivot QuickSort" , "MergeSort"};

		System.out.println("Initializing information:");
		System.out.println("\tArray size: " + size);
		System.out.println("\tNumber of runs per test: " + numRuns);
		String sorted = "";
		if(isSorted)
			sorted = "Sorted";
		else
			sorted = "Random";
		
		System.out.println("\tInitial data: " + sorted);

		System.out.println();

		System.out.println("After the tests, here is the best setup:");
		System.out.println("\tAlgorithm: " + algorithms[bestAlg]);
		System.out.println("\tData status: \t" + sorted);
		System.out.println("\tMin Recurse: \t" + minRecResult[0][bestAlg]);
		System.out.println("\tAverage: \t" + min/(double)numRuns + " sec");
		System.out.println();
		System.out.println("After the tests, here is the worst setup:");
		System.out.println("\tAlgorithm: " + algorithms[worstAlg]);
		System.out.println("\tData status: \t" + sorted);
		System.out.println("\tMin Recurse: \t" + minRecResult[1][worstAlg]);
		System.out.println("\tAverage: \t" + max/(double)numRuns + " sec");

		System.out.println();
		System.out.println("Here are the per algorithm results:");
		for(int i = 0; i < s; i++)
		{
			System.out.println("Algorithm: " + algorithms[i]);
			System.out.println("\tBest Result: ");
			System.out.println("\t\tMin Recurse: " + minRecResult[0][i]);
			System.out.println("\t\tAverage: " + timeTable[0][i]/(double)numRuns + " sec");
			System.out.println("\tWorst Result: ");
			System.out.println("\t\tMin Recurse: " + minRecResult[1][i]);
			System.out.println("\t\tAverage: " + timeTable[1][i]/(double)numRuns + " sec");
			System.out.println();

		}
		
		// for(int r = 0; r<timeTable.length; r++)
		// {
		// 	for(int c = 0; c<timeTable[0].length; c++)
		// 		System.out.print(timeTable[r][c] + " ");
		// 	System.out.println();
		// }

		// for(int r = 0; r<minRecResult.length; r++)
		// {
		// 	for(int c = 0; c<minRecResult[0].length; c++)
		// 		System.out.print(minRecResult[r][c] + " ");
		// 	System.out.println();
		// }
	}

	public static void main(String[]args)
	{
		int size = Integer.parseInt(args[0]);
		int numRuns = Integer.parseInt(args[1]);
		boolean isSorted = Boolean.parseBoolean(args[2]);
		//System.out.println(size);		
		new Assig4(size, isSorted, numRuns);



	}
}