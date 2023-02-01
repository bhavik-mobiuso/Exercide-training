class Suzuki{
    static int counter;
    private Suzuki() {
        
    }
    public static Suzuki createInstance() {
        if (counter < 10) {
            System.out.println("\nInstance created"+(counter+1)+"time"); 
            counter++;
            return new Suzuki();
        }
        else {
           System.out.println("\nLimit Exceeds..."); 
           return null;
        }
    }
}
class HelloWorld {
    public static void main(String[] args) {
        for(int i=0; i<11; i++) {
            Suzuki.createInstance();
        }
    }
}