import java.sql.*;

class Clerk {
    Main main;

    Clerk(Main main) {
        this.main = main;
    }

    void run() {
        System.out.println("\nEntered employee interface?");
        System.out.println("\t[1] Rent out a car");
        System.out.println("\t[2] Accept a return");
        System.out.println("\t[X] Return to main menu");
        Bridge.p("What would you like to do? > ");
        switch (this.main.s.nextLine()) {
            case "1":
                this.createRental();
                break;
            case "X":
            case "x":
                this.main.run();
                return;
            default:
                System.out.println("Invalid option. Try again.");
        }
        this.run();
    }

    void createRental() {
        int lid = Bridge.selectLocation(this.main.s, this.main.c);
        int vid = Bridge.selectVehicle(lid, this.main.s, this.main.c);
        Bridge.p("Negotiate a rate and input it here > ");
        String rate = this.main.s.nextLine();
        if (rate.equalsIgnoreCase("X")) return;
        if (rate.contains("'")) {
            System.out.println("Your input may not have a single quote.");
            this.createRental();
            return;
        }
        int cid = Bridge.selectCustomer(this.main.s, this.main.c);
        if (cid == -1 || lid == -1 || vid == -1) {
            this.createRental();
            return;
        }
        try {
            PreparedStatement ps = SQLStrings.createRental(this.main.c);
            ps.setInt(1, Integer.parseInt(rate));
            ps.setInt(2, cid);
            ps.setInt(3, vid);
            if (ps.executeUpdate() == 0) {
                System.out.println("An error has occurred: try again.");
                this.createRental();
                return;
            }
            this.main.c.commit();
            System.out.println("A rental has been created for customer " + cid + " at location " + lid + " for vehicle " + vid);
            return;
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            this.createRental();
            return;
        }
    }
}
