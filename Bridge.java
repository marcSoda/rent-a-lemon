import java.util.Scanner;
import java.util.ArrayList;
import java.sql.*;

//For global functions
class Bridge {
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

    //returns -1 to go back to customer menu
    static int selectCustomer(Scanner s, Connection c) {
        if (Bridge.binaryQuery(s, "Would you like to search for your customer ID?"))
            searchCustomer(s, c);
        Bridge.p("Input your customer ID > ");
        String sub = s.nextLine();
        if (sub.equalsIgnoreCase("X")) return -1;
        if (sub.contains("'")) {
            System.out.println("Your input may not have a single quote.");
            return selectCustomer(s, c);
        }

        try {
            PreparedStatement ps = SQLStrings.selectCustomer(c);
            ps.setString(1, sub);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("There are no customers matching that ID.");
                return selectCustomer(s, c);
            } else {
                result.next();
                return result.getInt(1);
            }
        } catch(Exception e) {
            e.printStackTrace();
            System.out.println("An error has occurred: try again.");
            return selectCustomer(s, c);
        }
    }

    //return false when x hit
    static boolean searchCustomer(Scanner s, Connection c) {
        Bridge.p("Input your name or a substring of your name > ");
        String sub = s.nextLine();
        if (sub.equalsIgnoreCase("X")) return false;
        if (sub.contains("'")) {
            System.out.println("Name search substring may not contain single quotes.");
            return searchCustomer(s, c);
        }

        try {
            PreparedStatement ps = SQLStrings.searchCustomer(c);
            ps.setString(1, "%" + sub + "%");
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("There are no customers matching that name.");
                return searchCustomer(s, c);
            } else {
                System.out.println("\nHere is a list of matching customers:\n");
                String fmtStr = "%-7s%-40s";
                System.out.println(String.format(fmtStr, "ID", "Name"));
                while (result.next())
                    System.out.println(String.format(fmtStr, result.getString(1), result.getString(2)));
                System.out.println();
                return true;
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            return searchCustomer(s, c);
        }
    }

    //used by customer and clerk
    //returns -1 when X hit, there are no vehicles, or lid is -1
    static int selectVehicle(int lid, Scanner s, Connection c) {
        if (lid == -1) return -1;
        ArrayList<Integer> vids = listVehicles(lid, c);
        if (vids == null) return -1; //if vids is null, then there are no vehicles at the selected location
        Bridge.p("Input the vehicle ID > ");
        String sub = s.nextLine();
        if (sub.equalsIgnoreCase("X")) return -1;
        if (sub.contains("'")) {
            System.out.println("Your input may not have a single quote.");
            return selectVehicle(lid, s, c);
        }

        //ensure that the selected vehicle is in the returned list of vehicles at the selected location
        if (!vids.contains(Integer.parseInt(sub))) {
            System.out.println("The vehicle that you have selected is not at the location that you selected.");
            return selectVehicle(lid, s, c);
        }

        try {
            PreparedStatement ps = SQLStrings.selectVehicle(c);
            ps.setString(1, sub);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("There are no vehicles matching that ID.");
                return selectVehicle(lid, s, c);
            } else {
                result.next();
                int vid = result.getInt(1);
                System.out.println("Vehicle with ID of " + vid + " selected.\n");
                return vid;
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            return selectVehicle(lid, s, c);
        }
    }

    //used by customer and clerk
    static ArrayList<Integer> listVehicles(int lid, Connection c) {
        try {
            PreparedStatement ps = SQLStrings.listVehicles(c);
            ps.setInt(1, lid);
            ResultSet result = ps.executeQuery();
            ArrayList<Integer> vids = new ArrayList<Integer>();
            if (!result.isBeforeFirst()) {
                System.out.println ("There are no vehicles at this location.");
                return null;
            } else {
                System.out.println("\nHere is a list of available vehicles at that location:\n");
                String fmtStr = "%-7s%-15s%-15s%-15s%-15s%-15s";
                System.out.println(String.format(fmtStr, "ID", "Make", "Model", "Year", "Color", "Type"));
                while (result.next()) {
                    vids.add(result.getInt(1));
                    System.out.println(String.format(fmtStr, result.getString(1), result.getString(2), result.getString(3), result.getString(4), result.getString(5), result.getString(6)));
                }
                System.out.println();
                return vids;
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            return null;
        }
    }

    //returns -1 if X was hit
    static int selectLocation(Scanner s, Connection c) {
        if (Bridge.binaryQuery(s, "Would you like to search for your location?"))
            if (!searchLocation(s, c)) return -1;
        Bridge.p("Input your location ID > ");
        String sub = s.nextLine();
        if (sub.equalsIgnoreCase("X")) return -1;
        if (sub.contains("'")) {
            System.out.println("Your input may not have a single quote.");
            return selectLocation(s, c);
        }
        try {
            PreparedStatement ps = SQLStrings.selectLocation(c);
            ps.setString(1, sub);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("There are no locations matching that ID.");
                return selectLocation(s, c);
            } else {
                result.next();
                int lid = result.getInt(1);
                System.out.println("Location with ID of " + lid + " selected.\n");
                return lid;
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            return selectLocation(s, c);
        }
    }

    //returns false when X hit
    static boolean searchLocation(Scanner s, Connection c) {
        Bridge.p("Input your location city or a substring of your location city > ");
        String sub = s.nextLine();
        if (sub.equalsIgnoreCase("X")) return false;
        if (sub.contains("'")) {
            System.out.println("Name search substring may not contain single quotes.");
            return searchLocation(s, c);
        }
        try {
            PreparedStatement ps = SQLStrings.searchLocation(c);
            ps.setString(1, "%" + sub + "%");
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("There are no locations matching that name.");
                return searchLocation(s, c);
            } else {
                System.out.println("\nHere is a list of matching locations:\n");
                String fmtStr = "%-7s%-25s%-25s%-25s%-7s";
                System.out.println(String.format(fmtStr, "ID", "Street", "City", "State", "Zip"));
                while (result.next())
                    System.out.println(String.format(fmtStr, result.getString(1), result.getString(2), result.getString(3), result.getString(4), result.getString(5)));
                System.out.println();
                return true;
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            return searchLocation(s, c);
        }
    }
}
