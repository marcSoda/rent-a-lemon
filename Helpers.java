import java.util.Scanner;

class Helpers {
    static String ansiGreen = "\u001B[32m";
    static String ansiRst = "\u001B[0m";

    static void pl(String prompt) {
        System.out.println(ansiGreen + prompt + ansiRst);
    }

    static void p(String prompt) {
        System.out.print(ansiGreen + prompt + ansiRst);
    }

    static boolean binaryQuery(Scanner s, String prompt) {
        p(prompt + " Y/N > ");
        String resp = s.nextLine();
        if (resp.equalsIgnoreCase("Y")) return true;
        else if (resp.equalsIgnoreCase("N")) return false;
        else {
            System.out.println("Invalid response.");
            return binaryQuery(s, prompt);
        }
    }
}
