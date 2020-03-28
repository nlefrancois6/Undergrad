import java.util.Arrays;
public class ExamGrading {
	public static void main(String[] args) {
		char[][] responses = {{'C','A','B','B','C','A'},{'A','A','B','B','B','B'},{'C','B','A','B','C','A'},{'A','B','A','B','B','B'}};
		char[] solution = {'C','A','B','B','C','C'};
		System.out.println(Arrays.deepToString(findSimilarAnswers(responses,solution,3)));
	}
	
	//Create an array containing the grade of each student in the same order as their responses in the input array
	public static double[] gradeAllStudents(char[][] responses, char[] solutions) {
		//Initialize grades array with same length as responses, aka same number of students
		double[] grades = new double[responses.length];
		//Calculate the total score of each student by adding 1 point for each correct answer
		for(int i=0; i<responses.length; i++) {
			double indSum = 0;
			for(int j=0; j<solutions.length; j++) {
				//Throw exception if the number of responses given isn't the same as the number of solutions
				if(responses[i].length != solutions.length) {
					throw new IllegalArgumentException("Responses length (" + responses[i].length + ") not equal to solutions length (" + solutions.length + ") for student at index " + i);
				}
				if(responses[i][j]==solutions[j]) {
					indSum += 1;
				}
			}
			//Calculate student grade as a percentage
			double indGrade = indSum/solutions.length;
			//grades is an array containing each student's grade in the same order as in the responses array
			grades[i] = indGrade;
		}
		return grades;
	}
	
	//Take the solutions and the responses of 2 students as input, return number of questions 
	//where both students were incorrect but gave the same answer as each other
	public static int numWrongSimilar(char[] response1, char[] response2, char[] solutions) {
		//Initialize count variable
		int count = 0;
		//Throw exception if the three input arrays are not all of equal length
		if((response1.length == response2.length && response1.length == solutions.length)==false) {
			throw new IllegalArgumentException("Arrays not all of equal length");
		}
		//Compare the students' answers to each other and to the solutions
		//If the students' answers are equal to each other but not the solution, increment the count
		for(int i=0; i<response1.length; i++) {
			if(response1[i]==response2[i] && (response1[i]!=solutions[i])) {
				count +=1;
			}
		}
		//Return number of questions on which a similar answer was detected
		return count;
	}
	
	//Take an array of students' responses, the exam solutions, an index, and a threshold value as input
	//Return number of students with whom the student at the given index shares enough similar answers to equal or exceed the threshold
	public static int numMatches(char[][] responses, char[] solutions, int index, int threshold) {
		//Initialize count variable
		int count = 0;
		//Compare the number of similar answers shared with each student (not including the student in question) to the threshold
		for(int i=0; i<responses.length; i++) {
			if(i!=index) {
				int similar = numWrongSimilar(responses[index], responses[i], solutions);
				//Increment count if the two students share enough similar answers
				if(similar>= threshold) {
					count ++;
				}
			}
		}
		//Return number of students with whom enough similar answers are shared
		return count;
	}
	
	//Take an array of students' responses, the exam solutions, and a threshold value as input
	//Return array of students with whom each student has enough similar answers to equal or exceed the threshold
	public static int[][] findSimilarAnswers(char[][] responses, char[] solutions, int threshold){
		//Initialize array of matches to have length equal to number of students in responses array
		int[][] matches = new int[responses.length][];
		//For each student, generate an array which contains the indexes of all students with enough similar answers
		for(int i=0; i<responses.length; i++) {
			int m = 0;
			int [] matchesI = new int[numMatches(responses, solutions, i, threshold)];
			for(int j=0; j<responses.length; j++) {
				if(j!=i) {
					if(numWrongSimilar(responses[i],responses[j],solutions)>=threshold) {
						matchesI[m] = j;
						m++;
					}
				}
			}
			//Take this array of matched indexes and input it as an entry for student [i]
			matches[i] = matchesI;
		}
		//Return the array containing all of the students' matches arrays
		return matches;
	}
}
