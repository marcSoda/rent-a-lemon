import java.util.HashMap;
import java.sql.*;

class Customer {
    Main main;
    int cid = -1;

    Customer(Main main) {
        this.main = main;
    }

    void run() {
        System.out.println("\nEntered customer interface?");
        System.out.println("\t[1] Log in using your customer ID");
        System.out.println("\t[2] Create a new customer account");
        System.out.println("\t[3] Make a reservation");
        System.out.println("\t[4] Drop a reservation");
        System.out.println("\t[5] Complete a charge");
        System.out.println("\t[6] View rental history");
        System.out.println("\t[7] View reservation history");
        System.out.println("\t[8] View charge history");
        System.out.println("\t[X] Return to main menu");
        Bridge.p("What would you like to do? > ");
        switch (this.main.s.nextLine()) {
            case "1":
                this.selectCustomer();
                break;
            case "2":
                this.createCustomer();
                break;
            case "3":
                this.createReservation();
                break;
            case "4":
                this.deleteReservation();
                break;
            case "5":
                this.completeCharge();
                break;
            case "6":
                this.listRentals();
                break;
            case "7":
                this.listReservations();
                break;
            case "8":
                this.listCharges();
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

    void selectCustomer() {
        this.checkIDAlreadySelected(false);
        this.cid = Bridge.selectCustomer(this.main.s, this.main.c);
        if (this.cid == -1) return;
        System.out.println("Customer with ID of " + this.cid + " selected.\n");
    }

    void createCustomer() {
        this.checkIDAlreadySelected(false);
        System.out.println("\nCustomer Creation menu (enter X to exit): ");
        Bridge.p("\tInput your name > ");
        String name = this.main.s.nextLine();
        if (name.equalsIgnoreCase("X")) this.run();
        Bridge.p("\tInput your address > ");
        String addy = this.main.s.nextLine();
        if (addy.equalsIgnoreCase("X")) this.run();
        HashMap<String, String> dlInfo = this.createLicense();
        HashMap<String, String> mInfo = new HashMap<String, String>();
        mInfo.put("mid", "1"); // 1 is the membership ID of the default membership
        mInfo.put("gname", "Default");
        if (Bridge.binaryQuery(this.main.s, "\nDo you belong to a group that has a membership discount?"))
            mInfo = getMembershipID();
        try {
            PreparedStatement ps = SQLStrings.createCustomer(this.main.c);
            ps.setString(1, addy);
            ps.setString(2, name);
            ps.setInt(3, Integer.parseInt(dlInfo.get("lid")));
            ps.setInt(4, Integer.parseInt(mInfo.get("mid")));

            if (ps.executeUpdate() == 0) {
                System.out.println("An error has occurred: try again.");
                this.createCustomer();
                return;
            }
            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            this.cid = rs.getInt(1);

            System.out.println(
                "\nCustomer creation summary:" +
                "\n\tName:            " + name +
                "\n\tAddress:         " + addy +
                "\n\tLicense Number:  " + dlInfo.get("lid") +
                "\n\tState:           " + dlInfo.get("state") +
                "\n\tAge:             " + dlInfo.get("age") +
                "\n\tGroup Name:      " + mInfo.get("gname")
            );
            if (!Bridge.binaryQuery(this.main.s, "Are the above details correct?")) {
                return;
            }
            this.main.c.commit();
            System.out.println("Customer with ID " + this.cid + " created and selected");
            this.run();
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            this.createCustomer();
            return;
        }
    }

    HashMap<String, String> createLicense() {
        HashMap<String, String> dlInfo = new HashMap<String, String>();
        Bridge.p("\tInput your license number > ");
        dlInfo.put("dln", this.main.s.nextLine());
        if (dlInfo.get("dln").equalsIgnoreCase("X")) this.run();
        Bridge.p("\tInput your license state > ");
        dlInfo.put("state", this.main.s.nextLine());
        if (dlInfo.get("state").equalsIgnoreCase("X")) this.run();
        Bridge.p("\tInput your age > ");
        dlInfo.put("age", this.main.s.nextLine());
        if (dlInfo.get("age").equalsIgnoreCase("X")) this.run();
        for (String v : dlInfo.values()) {
            if (v.contains("'")) {
                System.out.println("Your input may not have a single quote.");
                return this.createLicense();
            }
        }
        try {
            PreparedStatement ps = SQLStrings.createLicense(this.main.c);
            ps.setString(1, dlInfo.get("dln"));
            ps.setString(2, dlInfo.get("state"));
            ps.setString(3, dlInfo.get("age"));
            if (ps.executeUpdate() == 0) {
                System.out.println("An error has occurred: try again.");
                return this.createLicense();
            }
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                dlInfo.put("lid", Integer.toString(rs.getInt(1)));
                return dlInfo;
            }
            System.out.println("An error has occurred: try again.");
            return this.createLicense();
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            return this.createLicense();
        }
    }

    HashMap<String, String> getMembershipID() {
        HashMap<String, String> mInfo = new HashMap<String, String>();
        Bridge.p("Search for the group that you belong to > ");
        String gsub = this.main.s.nextLine();
        if (gsub.equalsIgnoreCase("X")) this.run();
        if (gsub.contains("'")) {
            System.out.println("Input may not contain single quotes.");
            return this.getMembershipID();
        }

        try {
            PreparedStatement gps = SQLStrings.searchMembership(this.main.c);
            gps.setString(1, "%" + gsub + "%");
            ResultSet gres = gps.executeQuery();
            if (!gres.isBeforeFirst()) {
                System.out.println ("There are no memberships matching that name.");
                return this.getMembershipID();
            } else {
                System.out.println("\nHere is a list of matching memberships:\n");
                String fmtStr = "%-7s%-40s";
                System.out.println(String.format(fmtStr, "ID", "Name"));
                while (gres.next())
                    System.out.println(String.format(fmtStr, gres.getString(1), gres.getString(2)));
                System.out.println("\nIf you would like to search again enter 0.");
                System.out.println("If you do not have a matching membership, enter 1.");
                Bridge.p("Input Membership ID from the list > ");
                String msub = this.main.s.nextLine();
                if (msub.equals("0")) return getMembershipID();
                else if (msub.contains("'")) {
                    System.out.println("Your input may not have a single quote.");
                    return getMembershipID();
                }

                PreparedStatement mps = SQLStrings.getMembershipByID(this.main.c);
                mps.setString(1, msub);
                ResultSet result = mps.executeQuery();
                if (!result.isBeforeFirst()) {
                    System.out.println ("There are no memberships matching that ID.");
                    return this.getMembershipID();
                } else {
                    result.next();
                    mInfo.put("mid", Integer.toString(result.getInt(1)));
                    mInfo.put("gname", result.getString(2));
                    System.out.println(
                        "Selected membership with ID " + mInfo.get("mid") +
                        " of group " + mInfo.get("gname") + "\n");
                    return mInfo;
                }
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            return this.getMembershipID();
        }
    }

    void createReservation() {
        this.checkIDAlreadySelected(true);
        int lid = Bridge.selectLocation(this.main.s, this.main.c);
        int vid = Bridge.selectVehicle(lid, this.main.s, this.main.c);
        if (lid == -1 || vid == -1) {
            this.run();
            return;
        }
        try {
            PreparedStatement ps = SQLStrings.createReservation(this.main.c);
            ps.setInt(1, this.cid);
            ps.setInt(2, vid);
            if (ps.executeUpdate() == 0) {
                System.out.println("An error has occurred: try again.");
                this.createReservation();
                return;
            }
            this.main.c.commit();
            System.out.println("You have reserved vehicle " + vid + ".\nYour reservation will expire in 10 days.");
            this.run();
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            this.createReservation();
            return;
        }
    }

    void deleteReservation() {
        this.checkIDAlreadySelected(true);
        this.listReservations();
        Bridge.p("Input the reservation ID > ");
        String sub = this.main.s.nextLine();
        if (sub.equalsIgnoreCase("X")) this.run();
        if (sub.contains("'")) {
            System.out.println("Your input may not have a single quote.");
            deleteReservation();
            return;
        }
        try {
            PreparedStatement ps = SQLStrings.deleteReservation(this.main.c);
            ps.setInt(1, Integer.parseInt(sub));
            ps.setInt(2, this.cid);
            if (ps.executeUpdate() == 0) {
                System.out.println("An error has occurred: try again.");
                System.out.println("You may have entered a reservation ID that does not belong to you.");
                this.deleteReservation();
                return;
            }
            this.main.c.commit();
            System.out.println("You have deleted reservation of ID " + sub);
            this.run();
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            this.deleteReservation();
            return;
        }
    }

    void listReservations() {
        this.checkIDAlreadySelected(true);
        try {
            PreparedStatement ps = SQLStrings.listReservations(this.main.c);
            ps.setInt(1, this.cid);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("You have no reservations.");
                this.run();
                return;
            } else {
                System.out.println("\nHere is a list of your reservations:\n");
                String fmtStr = "%-7s%-15s%-15s%-15s%-15s%-15s%-15s";
                System.out.println(String.format(fmtStr, "ID", "Created", "Make", "Model", "Year", "Color", "Type"));
                while (result.next()) {
                    System.out.println(String.format(fmtStr, result.getString(1), result.getDate(2), result.getString(3), result.getString(4), result.getString(5), result.getString(6), result.getString(7)));
                }
                System.out.println();
                return;
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            return;
        }
    }

    void completeCharge() {
        this.checkIDAlreadySelected(true);
        this.listOutstandingCharges();
        Bridge.p("Input the charge ID > ");
        String sub = this.main.s.nextLine();
        if (sub.equalsIgnoreCase("X")) this.run();
        if (sub.contains("'")) {
            System.out.println("Your input may not have a single quote.");
            deleteReservation();
            return;
        }
        System.out.println("0");
        try {
            PreparedStatement ps = SQLStrings.completeCharge(this.main.c);
        System.out.println("1");
            ps.setInt(1, this.cid);
            ps.setInt(2, Integer.parseInt(sub));
        System.out.println("2");
            if (ps.executeUpdate() == 0) {
                System.out.println("An error has occurred: try again.");
                System.out.println("You may have entered a charge ID that does not belong to you.");
                this.completeCharge();
                return;
            }
        System.out.println("3");
            this.main.c.commit();
            System.out.println("We will be coming to your house to collect because we do not store payment info.");
            System.out.println("You have completed a charge of ID " + sub);
            this.run();
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            this.completeCharge();
            return;
        }
    }

    void listOutstandingCharges() {
        try {
            PreparedStatement ps = SQLStrings.listOutstandingCharges(this.main.c);
            ps.setInt(1, this.cid);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("You have no outstanding charges.");
                this.run();
                return;
            } else {
                System.out.println("\nHere is a list of your outstanding charges:\n");
                String fmtStr = "%-7s%-15s%-15s%-15s%-15s%-15s%-15s%-15s";
                System.out.println(String.format(fmtStr, "ID", "Fuel", "Dropoff", "Insurance", "Other", "Rate", "Percent Off", "Total"));
                while (result.next()) {
                    System.out.println(String.format(fmtStr, result.getString(1), result.getString(2), result.getString(3), result.getString(4), result.getString(5), result.getString(6), result.getString(7), result.getString(8)));
                }
                System.out.println();
                return;
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            return;
        }
    }

    void listRentals() {
        this.checkIDAlreadySelected(true);
        try {
            PreparedStatement ps = SQLStrings.listRentals(this.main.c);
            ps.setInt(1, this.cid);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("You have no rental history.");
                this.run();
                return;
            } else {
                System.out.println("\nHere is your rental history:\n");
                String fmtStr = "%-7s%-15s%-15s%-15s%-15s%-15s%-15s%-15s%-15s";
                System.out.println(String.format(fmtStr, "ID", "Taken", "Returned", "Rate", "Model", "Year", "Color", "Type", "City"));
                while (result.next()) {
                    System.out.println(String.format(fmtStr, result.getString(1), result.getDate(2), result.getDate(3), result.getString(4), result.getString(5), result.getString(6), result.getString(7), result.getString(8), result.getString(9)));
                }
                System.out.println();
                this.run();
                return;
            }
        } catch(Exception e) {
            System.out.println("An error has occurred.");
            this.run();
            return;
        }
    }

    void listCharges() {
        this.checkIDAlreadySelected(true);
        try {
            PreparedStatement ps = SQLStrings.listCharges(this.main.c);
            ps.setInt(1, this.cid);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("You have no charge history.");
                return;
            } else {
                System.out.println("\nHere is your charge history:\n");
                String fmtStr = "%-7s%-15s%-15s%-15s%-15s%-15s%-15s%-15s";
                System.out.println(String.format(fmtStr, "ID", "Fuel", "Dropoff", "Insurance", "Other", "Rate", "Percent Off", "Total"));
                while (result.next()) {
                    System.out.println(String.format(fmtStr, result.getString(1), result.getString(2), result.getString(3), result.getString(4), result.getString(5), result.getString(6), result.getString(7), result.getString(8)));
                }
                System.out.println();
                return;
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            return;
        }
    }

    void checkIDAlreadySelected(boolean invert) {
        if (!invert) {
            if (this.cid != -1 && !Bridge.binaryQuery(this.main.s, "A customer ID has already been selected. Would you like to overwrite it?"))
                this.run();
        } else {
            if (this.cid == -1 && Bridge.binaryQuery(this.main.s, "You have not selected a customer ID. Would you like to do that now?"))
                this.selectCustomer();
            else if (this.cid != -1)
                return;
            else {
                System.out.println("You must select a customer id before you can access this feature.");
                this.run();
            }
        }
    }
}
