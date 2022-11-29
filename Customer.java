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
        System.out.println("\t[6] View reservations");
        System.out.println("\t[7] View rental history");
        System.out.println("\t[8] View charge history");
        System.out.println("\t[X] Return to main menu");
        Bridge.prompt("What would you like to do? > ");
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
                this.listReservations();
                break;
            case "7":
                this.listRentals();
                break;
            case "8":
                this.listCharges();
                break;
            case "X":
            case "x":
                this.main.run();
            default:
                Bridge.errln("Invalid option. Try again.");
        }
        this.run();
    }

    void selectCustomer() {
        this.checkIDAlreadySelected(false);
        this.cid = this.main.bridge.selectCustomer();
        if (this.cid == -1) return;
    }

    void createCustomer() {
        this.checkIDAlreadySelected(false);
        String name = this.main.bridge.getString("Input your name > ", 256);
        if (name == null) return;
        String addy = this.main.bridge.getString("Input your address > ", 256);
        if (addy == null) return;
        HashMap<String, String> dlInfo = this.createLicense();
        HashMap<String, String> mInfo = new HashMap<String, String>();
        mInfo.put("mid", "1"); // 1 is the membership ID of the default membership
        mInfo.put("gname", "Default");
        if (this.main.bridge.binaryQuery("\nDo you belong to a group that has a membership discount?"))
            mInfo = getMembershipID();
        try {
            PreparedStatement ps = SQLStrings.createCustomer(this.main.c);
            ps.setString(1, addy);
            ps.setString(2, name);
            ps.setInt(3, Integer.parseInt(dlInfo.get("lid")));
            ps.setInt(4, Integer.parseInt(mInfo.get("mid")));

            if (ps.executeUpdate() == 0) {
                Bridge.defaultErr();
                this.createCustomer();
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
            if (!this.main.bridge.binaryQuery("Are the above details correct?"))
                return;
            this.main.c.commit();
            System.out.println("Customer with ID " + this.cid + " created and selected");
            this.run();
        } catch(SQLException e) {
            Bridge.defaultErr();
            this.createCustomer();
        }
    }

    HashMap<String, String> createLicense() {
        HashMap<String, String> dlInfo = new HashMap<String, String>();
        dlInfo.put("dln", this.main.bridge.getString("Input your license number > ", 256));
        if (dlInfo.get("dln") == null) this.run();
        dlInfo.put("state", this.main.bridge.getString("Input your license state > ", 128));
        if (dlInfo.get("state") == null) this.run();
        dlInfo.put("age", Integer.toString(this.main.bridge.getInt("Input your license age > ")));
        if (dlInfo.get("age") == null) this.run();
        try {
            PreparedStatement ps = SQLStrings.createLicense(this.main.c);
            ps.setString(1, dlInfo.get("dln"));
            ps.setString(2, dlInfo.get("state"));
            ps.setString(3, dlInfo.get("age"));
            if (ps.executeUpdate() == 0) {
                Bridge.defaultErr();
                return this.createLicense();
            }
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                dlInfo.put("lid", Integer.toString(rs.getInt(1)));
                return dlInfo;
            }
            Bridge.defaultErr();
            return this.createLicense();
        } catch(SQLException e) {
            Bridge.defaultErr();
            return this.createLicense();
        }
    }

    HashMap<String, String> getMembershipID() {
        HashMap<String, String> mInfo = new HashMap<String, String>();
        String gsub = this.main.bridge.getString("Search for your company > ", 256);
        if (gsub == null) this.run();
        try {
            PreparedStatement gps = SQLStrings.searchMembership(this.main.c);
            gps.setString(1, "%" + gsub + "%");
            ResultSet gres = gps.executeQuery();
            if (!gres.isBeforeFirst()) {
                Bridge.errln("There are no memberships matching that name.");
                return this.getMembershipID();
            } else {
                System.out.println("\nHere is a list of matching memberships:\n");
                String fmtStr = "%-7s%-40s";
                Bridge.headingln(String.format(fmtStr, "ID", "Name"));
                while (gres.next())
                    System.out.println(String.format(fmtStr, gres.getString(1), gres.getString(2)));
                Bridge.promptln("If your membership is not listed, enter 1.");
                int mid = this.main.bridge.getInt("Input membership ID from the list > ");
                if (mid == -1) this.run();
                PreparedStatement mps = SQLStrings.getMembershipByID(this.main.c);
                mps.setInt(1, mid);
                ResultSet result = mps.executeQuery();
                if (!result.isBeforeFirst()) {
                    Bridge.errln("There are no memberships matching that ID.");
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
        } catch(SQLException e) {
            Bridge.defaultErr();
            return this.getMembershipID();
        }
    }

    void createReservation() {
        this.checkIDAlreadySelected(true);
        int lid = this.main.bridge.selectLocation();
        int vid = this.main.bridge.selectVehicle(lid);
        if (lid == -1 || vid == -1) {
            this.run();
        }
        try {
            PreparedStatement ps = SQLStrings.createReservation(this.main.c);
            ps.setInt(1, this.cid);
            ps.setInt(2, vid);
            if (ps.executeUpdate() == 0) {
                Bridge.defaultErr();
                this.createReservation();
            }
            this.main.c.commit();
            System.out.println("You have reserved vehicle " + vid + ".\nYour reservation will expire in 10 days.");
            this.run();
        } catch(SQLException e) {
            Bridge.defaultErr();
            this.createReservation();
        }
    }

    void deleteReservation() {
        this.checkIDAlreadySelected(true);
        this.listReservations();
        int rid = this.main.bridge.getInt("Input the reservation ID > ");
        if (rid == -1) return;
        try {
            PreparedStatement ps = SQLStrings.deleteReservation(this.main.c);
            ps.setInt(1, rid);
            ps.setInt(2, this.cid);
            if (ps.executeUpdate() == 0) {
                Bridge.defaultErr();
                Bridge.errln("You may have entered a reservation ID that does not belong to you.");
                this.deleteReservation();
            }
            this.main.c.commit();
            System.out.println("You have deleted reservation of ID " + rid);
            this.run();
        } catch(SQLException e) {
            Bridge.defaultErr();
            this.deleteReservation();
        }
    }

    void listReservations() {
        this.checkIDAlreadySelected(true);
        try {
            PreparedStatement ps = SQLStrings.listReservations(this.main.c);
            ps.setInt(1, this.cid);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                Bridge.errln("You have no reservations.");
                this.run();
            } else {
                System.out.println("\nHere is a list of your reservations:\n");
                String fmtStr = "%-7s%-15s%-15s%-15s%-15s%-15s%-15s";
                Bridge.headingln(String.format(fmtStr, "ID", "Created", "Make", "Model", "Year", "Color", "Type"));
                while (result.next()) {
                    System.out.println(String.format(fmtStr, result.getString(1), result.getDate(2), result.getString(3), result.getString(4), result.getString(5), result.getString(6), result.getString(7)));
                }
                System.out.println();
            }
        } catch(SQLException e) {
            Bridge.defaultErr();
        }
    }

    void completeCharge() {
        this.checkIDAlreadySelected(true);
        this.main.bridge.listOutstandingChargesForCustomer(this.cid);
        int chid = this.main.bridge.getInt("Input the charge ID > ");
        if (chid == -1) return;
        try {
            PreparedStatement ps = SQLStrings.completeCharge(this.main.c);
            ps.setInt(1, this.cid);
            ps.setInt(2, chid);
            if (ps.executeUpdate() == 0) {
                Bridge.defaultErr();
                Bridge.errln("You may have entered a charge ID that does not belong to you.");
                this.completeCharge();
            }
            this.main.c.commit();
            System.out.println("We will be coming to your house to collect because we do not store payment info.");
            System.out.println("You have completed a charge of ID " + chid);
        } catch(SQLException e) {
            Bridge.defaultErr();
            this.completeCharge();
        }
    }

    void listRentals() {
        this.checkIDAlreadySelected(true);
        try {
            PreparedStatement ps = SQLStrings.listRentals(this.main.c);
            ps.setInt(1, this.cid);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                Bridge.errln("You have no rental history.");
                this.run();
            } else {
                System.out.println("\nHere is your rental history:\n");
                String fmtStr = "%-7s%-15s%-15s%-15s%-15s%-15s%-15s%-15s%-15s";
                Bridge.headingln(String.format(fmtStr, "ID", "Taken", "Returned", "Rate", "Model", "Year", "Color", "Type", "City"));
                while (result.next()) {
                    System.out.println(String.format(fmtStr, result.getString(1), result.getDate(2), result.getDate(3), result.getString(4), result.getString(5), result.getString(6), result.getString(7), result.getString(8), result.getString(9)));
                }
                System.out.println();
                this.run();
            }
        } catch(SQLException e) {
            Bridge.defaultErr();
            this.run();
        }
    }

    void listCharges() {
        this.checkIDAlreadySelected(true);
        try {
            PreparedStatement ps = SQLStrings.listCharges(this.main.c);
            ps.setInt(1, this.cid);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                Bridge.errln("You have no charge history.");
                return;
            } else {
                System.out.println("\nHere is your charge history:\n");
                String fmtStr = "%-7s%-15s%-15s%-15s%-15s%-15s%-15s%-15s";
                Bridge.headingln(String.format(fmtStr, "ID", "Fuel", "Dropoff", "Insurance", "Other", "Rate", "Percent Off", "Total"));
                while (result.next()) {
                    System.out.println(String.format(fmtStr, result.getString(1), result.getString(2), result.getString(3), result.getString(4), result.getString(5), result.getString(6), result.getString(7), result.getString(8)));
                }
                System.out.println();
            }
        } catch(SQLException e) {
            Bridge.defaultErr();
        }
    }

    void checkIDAlreadySelected(boolean invert) {
        if (!invert) {
            if (this.cid != -1 && !this.main.bridge.binaryQuery("A customer ID has already been selected. Would you like to overwrite it?"))
                this.run();
        } else {
            if (this.cid == -1 && this.main.bridge.binaryQuery("You have not selected a customer ID. Would you like to do that now?"))
                this.selectCustomer();
            else if (this.cid != -1)
                return;
            else {
                Bridge.errln("You must select a customer id before you can access this feature.");
                this.run();
            }
        }
    }
}
