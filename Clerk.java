import java.sql.*;
import java.util.HashMap;

class Clerk {
    Main main;
    int lid = -1;

    Clerk(Main main) {
        this.main = main;
    }

    void run() {
        System.out.println("\nEntered employee interface?");
        System.out.println("\t[1] Log in with location ID");
        System.out.println("\t[2] Rent out a car");
        System.out.println("\t[3] Accept a return");
        System.out.println("\t[X] Return to main menu");
        Bridge.prompt("What would you like to do? > ");
        switch (this.main.s.nextLine()) {
            case "1":
                this.selectLocation();
                break;
            case "2":
                this.createRental();
                break;
            case "3":
                this.acceptReturn();
                break;
            case "X":
            case "x":
                this.main.run();
                return;
            default:
                Bridge.errln("Invalid option. Try again.");
        }
        this.run();
    }

    void selectLocation() {
        this.checkIDAlreadySelected(false);
        this.lid = this.main.bridge.selectLocation();
        if (this.lid == -1) return;
    }

    void createRental() {
        this.checkIDAlreadySelected(true);
        int cid = this.main.bridge.selectCustomer();
        if (cid == -1) return;
        int vid = this.main.bridge.selectVehicle(lid);
        if (vid == -1) return;
        Double rate = this.main.bridge.getDouble("Negotiate a daily rate and input it here > ");
        if (rate == null) return;
        try {
            PreparedStatement ps = SQLStrings.createRental(this.main.c);
            ps.setDouble(1, rate);
            ps.setInt(2, cid);
            ps.setInt(3, vid);
            if (ps.executeUpdate() == 0) {
                Bridge.errln("An error has occurred: try again.");
                this.createRental();
            }
            this.main.c.commit();
            System.out.println("A rental has been created for customer " + cid + " at location " + lid + " for vehicle " + vid);
            return;
        } catch(Exception e) {
            Bridge.errln("An error has occurred: try again.");
            this.createRental();
        }
    }

    void acceptReturn() {
        this.checkIDAlreadySelected(true);
        int cid = this.main.bridge.selectCustomer();
        if (cid == -1) return;
        HashMap<String, String> rental = this.getRental(cid);
        if (rental == null) return;
        //get odometer reading
        int odo = this.main.bridge.getInt("What is the current odometer readout? Round up. > ");
        if (odo == -1) return;
        //calculate fuel charge
        int gas = this.main.bridge.getInt("Input the number of gallons missing from the tank. Round up > ");
        if (gas == -1) return;
        Double fuel = Bridge.round(gas * Paramaters.ppg);
        System.out.println("Hurts' current price per gallon is $" + Paramaters.ppg + "\nTherefore the fuel charge for this rental is $" + fuel + "\n");
        //calculate dropoff charge
        Double dropoff = 0.00;
        if (!rental.get("lid").equals(Bridge.itos(this.lid))) {
            System.out.println("Since the customer did not return the vehicle to the location that you got it from, his/her dropoff charge is $" + Paramaters.dropoff + "\n");
            dropoff = Bridge.round(Paramaters.dropoff);
            if (!this.main.bridge.moveVehicle(Bridge.stoi(rental.get("lid")), this.lid, Bridge.stoi(rental.get("vid")), false)) {
                Bridge.defaultErr();
                this.acceptReturn();
            }
        }
        //calculate insurance charge
        Double num_days = Bridge.stod(rental.get("num_days"));
        if (num_days < 0) acceptReturn();
        Double insurance = 0.;
        if (num_days < 1) insurance = Paramaters.hourlyInsuranceRate * (num_days * 24);
        else if (num_days > 1 && num_days < 7) insurance = Paramaters.dailyInsuranceRate * num_days;
        else insurance = Paramaters.weeklyInsuranceRate * (num_days / 7);
        insurance = Bridge.round(insurance);
        System.out.println("The insurance charge is $" + insurance);
        //calculate other charge
        Double other = 0.;
        if (this.main.bridge.binaryQuery("Did the customer use a navigation system?"))
            other += Paramaters.gps;
        if (this.main.bridge.binaryQuery("Did the customer use a child seat?"))
            other += Paramaters.carSeat;
        if (this.main.bridge.binaryQuery("Did the customer use a the satellite radio?"))
            other += Paramaters.satellite;
        other = Bridge.round(other);
        System.out.println("The sum of miscellaneous charges is $" + other);

        try {
            PreparedStatement arps = SQLStrings.acceptReturn(this.main.c);
            arps.setInt(1, cid);
            arps.setString(2, rental.get("rid"));
            if (arps.executeUpdate() == 0) {
                Bridge.defaultErr();
                Bridge.errln("You likely entered a rental ID that does not belong to the slected customer ID");
                this.acceptReturn();
            }
            System.out.println("You have returned a rental of ID " + rental.get("rid") + "\nThis will be processed after the following charge is created.");

            PreparedStatement ccps = SQLStrings.createCharge(this.main.c);
            ccps.setDouble(1, fuel);
            ccps.setDouble(2, dropoff);
            ccps.setDouble(3, insurance);
            ccps.setDouble(4, other);
            ccps.setString(5, rental.get("rid"));
            if (ccps.executeUpdate() == 0) {
                Bridge.defaultErr();
                this.acceptReturn();
            }

            PreparedStatement uops = SQLStrings.updateOdometer(this.main.c);
            uops.setInt(1, odo);
            uops.setInt(2, cid);
            uops.setString(3, rental.get("rid"));
            uops.setString(4, rental.get("vid"));
            if (uops.executeUpdate() == 0) {
                Bridge.defaultErr();
                this.acceptReturn();
            }

            System.out.println(
                "\nCharge summary:" +
                "\n\tFuel:         $" + fuel +
                "\n\tDropoff:      $" + dropoff +
                "\n\tInsurance:    $" + insurance +
                "\n\tOther:        $" + other
            );
            if (!this.main.bridge.binaryQuery("Are the above details correct?"))
                return;
            this.main.c.commit();
            System.out.println("A charge has been added to your account.");
            System.out.println("Processing complete.");
            this.run();
        } catch(Exception e) {
            try {
                Bridge.defaultErr();
                Bridge.errln("A value that you have entered may be too large.");
                Bridge.errln("If your return was processed, it has been reverted.");
                this.main.c.rollback();
                this.acceptReturn();
            } catch(Exception se) {
                Bridge.errln("A fatal error has occurred.\nGracefully exiting.\nPlease try again.");
                System.exit(1);
            }
        }
    }

    void listNonreturnedRentals(int cid) {
        try {
            PreparedStatement ps = SQLStrings.listNonreturnedRentals(this.main.c);
            ps.setInt(1, cid);
            ResultSet r = ps.executeQuery();
            if (!r.isBeforeFirst()) {
                Bridge.errln("You have no rentals that haven't been returned.");
                this.run();
            } else {
                System.out.println("\nHere are your nonreturned rentals:\n");
                Printer.print(r);
            }
        } catch(Exception e) {
            Bridge.errln("An error has occurred.");
            this.run();
        }
    }

    HashMap<String, String> getRental(int cid) {
        listNonreturnedRentals(cid);
        int rid = this.main.bridge.getInt("Input the rental ID > ");
        if (rid == -1) return null;
        HashMap<String, String> rental = new HashMap<String, String>();
        try {
            PreparedStatement ps = SQLStrings.getRental(this.main.c);
            ps.setInt(1, cid);
            ps.setInt(2, rid);
            ResultSet r = ps.executeQuery();
            if (!r.isBeforeFirst()) {
                Bridge.errln("There are no rentals matching that ID.\nYou may have entered a rental ID that does not match a customer ID");
                return this.getRental(cid);
            } else {
                r.next();
                rental.put("rid", r.getString(1));
                rental.put("lid", r.getString(2));
                rental.put("num_days", r.getString(3));
                rental.put("vid", r.getString(4));
                return rental;
            }
        } catch(Exception e) {
            e.printStackTrace();
            Bridge.defaultErr();
            return this.getRental(cid);
        }
    }

    void checkIDAlreadySelected(boolean invert) {
        if (!invert) {
            if (this.lid != -1 && !this.main.bridge.binaryQuery("A location ID has already been selected. Would you like to overwrite it?"))
                this.run();
        } else {
            if (this.lid == -1 && this.main.bridge.binaryQuery("You have not selected a location ID. Would you like to do that now?"))
                this.selectLocation();
            else if (this.lid != -1)
                return;
            else {
                Bridge.errln("You must select a location id before you can access this feature.");
                this.run();
            }
        }
    }
}
