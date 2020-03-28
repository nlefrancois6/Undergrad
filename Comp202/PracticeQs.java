//Name: Noah LeFrancois
//ID: 260706235
public class PracticeQs {

	public static void main(String[] args) {
		//int[][] array = {{1,1,1},{0,0}};
		double[][] dblArray = {{1.0,3.0,4.5},{2.0,1.6}};
		double[] b = largestAverage(dblArray);
		for(int i = 0; i<b.length; i++) {
			System.out.println(b[i]);
		}
	}
	
	public static int longestSubArray(int[][] arr) {
	    int max = 0; 
		for(int i=0; i<arr.length; i++) {
	    	 int[] subArray = arr[i] ;
	    	 if(max<subArray.length) {
	    		 max=subArray.length;
	    	 }
	     }
		 return max;
	}
	
	public static boolean subArraySame(int[][] arr) {
		boolean isSame = true;
		for(int i=0; i<arr.length; i++) {
	    	 int[] subArray = arr[i] ;
	    	 int value = subArray[0];
	    	 for(int j=1; j<subArray.length; j++) {
	    		 if(value!=subArray[j]) {
	    			 isSame = false;
	    		 }
	    	 }
	     }
		return isSame;
	}
	
	public static double average(double[] arr) {
		double sum = 0;
		for(int i=0; i<arr.length; i++) {
			sum += arr[i];
		}
		return sum/arr.length;
	}
	
	public static double[] largestAverage(double[][] arr) {
		double[] maxAve = arr[0];
		for(int i=1; i<arr.length; i++) {
			if(average(arr[i])>average(maxAve)) {
				maxAve = arr[i];
			}
		}
		return maxAve;
	}
}