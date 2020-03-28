
public class Artifact {
	private double value;
	private double weight;
	public Artifact(double value, double weight){
		this.value = value;
		this.weight = weight;
		}
	public String toString(){
		return "V: " + this.value + " W : " + this.weight;
		}
	public void setValue(double value){
		value = value;
		}
	public double getRatio(){
		return value / weight;
		}
	public static Artifact compare(Artifact a, Artifact b){
		if (a.getRatio() > b.getRatio()){
			return a;
			}
		else{
			return b;
		}	
	}
}

