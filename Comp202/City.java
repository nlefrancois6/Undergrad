public class City {




    private String name;
    private Building[][] buildings;

    public City(String name, Building[][] buildings){
        this.name = name;
        this.buildings = buildings;

        //can raise exceptions for null inner arrays/buildings here
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void calculateTaxes(){

        for (int i=0; i < buildings.length; i++){
            Building[] inner = buildings[i];
            //check for null for inner arrays
            if (inner == null){
                //don't break or crash the program here
                //otherwise, no taxes will be collected!
                continue;
            }

            for (int j=0; j < inner.length; j++) {

                Building b = inner[j];
                if (b == null){
                    //don't need to use continue, but it's convenient
                    continue;
                }

                b.calculateTaxes();
            }
        }
    }

    //private - doesn't need to be accessed outside the class
    //static - doesn't need to access non-static data
    private static double collectTaxes(Building[] bArr){

        double sum = 0;
        for (int i=0; i < bArr.length; i++){

            Building b = bArr[i];

            if (b != null) {
                sum += b.collectUnpaidTaxes();
            }
        }
        return sum;
    }

    //overloaded method
    public double collectTaxes(){

        double sum = 0;
        for (int i=0; i < this.buildings.length; i++){

            Building[] bArr = this.buildings[i];

            if (bArr != null) {
                sum += collectTaxes(bArr);
            }
        }
        return sum;
    }
}
