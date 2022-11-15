import java.util.HashMap;
import java.io.*;
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
        System.out.println("\t[X] Return to main menu");
        Helpers.p("What would you like to do? > ");
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
                // this.createCustomer();
                break;
            case "X":
            case "x":
                this.main.run();
                break;
            default:
                System.out.println("Invalid option. Try again.");
                run();
        }
    }

    void searchCustomer() {
        Helpers.p("Input your name or a substring of your name > ");
        String sub = this.main.s.nextLine();
        if (sub.equalsIgnoreCase("X")) this.run();
        if (sub.contains("'")) {
            System.out.println("Name search substring may not contain single quotes.");
            this.searchCustomer();
            return;
        }

        try {
            PreparedStatement ps = SQLStrings.searchCustomer(this.main.c);
            ps.setString(1, "%" + sub + "%");
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("There are no customers matching that name.");
                this.searchCustomer();
                return;
            } else {
                System.out.println("\nHere is a list of matching customers:\n");
                String fmtStr = "%-7s%-40s";
                System.out.println(String.format(fmtStr, "ID", "Name"));
                while (result.next())
                    System.out.println(String.format(fmtStr, result.getString(1), result.getString(2)));
                System.out.println();
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            this.searchCustomer();
            return;
        }
    }

    void selectCustomer() {
        this.checkIDAlreadySelected(false);
        if (Helpers.binaryQuery(this.main.s, "Would you like to search for your customer ID?"))
            this.searchCustomer();
        Helpers.p("Input your customer ID > ");
        String sub = this.main.s.nextLine();
        if (sub.equalsIgnoreCase("X")) this.run();
        if (sub.contains("'")) {
            System.out.println("Your input may not have a single quote.");
            this.selectCustomer();
            return;
        }

        try {
            PreparedStatement ps = SQLStrings.selectCustomer(this.main.c);
            ps.setString(1, sub);
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("There are no customers matching that ID.");
                this.selectCustomer();
                return;
            } else {
                result.next();
                this.cid = result.getInt(1);
                System.out.println("Customer with ID of " + this.cid + " selected.\n");
                this.run();
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            this.selectCustomer();
            return;
        }
    }

    void createCustomer() {
        this.checkIDAlreadySelected(false);
        System.out.println("\nCustomer Creation menu (enter X to exit): ");
        Helpers.p("\tInput your name > ");
        String name = this.main.s.nextLine();
        if (name.equalsIgnoreCase("X")) this.run();
        Helpers.p("\tInput your address > ");
        String addy = this.main.s.nextLine();
        if (addy.equalsIgnoreCase("X")) this.run();
        HashMap<String, String> dlInfo = this.createLicense();
        HashMap<String, String> mInfo = new HashMap<String, String>();
        mInfo.put("mid", "1"); // 1 is the membership ID of the default membership
        mInfo.put("gname", "Default");
        if (Helpers.binaryQuery(this.main.s, "\nDo you belong to a group that has a membership discount?"))
            mInfo = getMembershipID();
        try {
            PreparedStatement ps = SQLStrings.createCustomer(this.main.c);
            ps.setString(1, addy);
            ps.setString(2, name);
            ps.setInt(3, Integer.parseInt(dlInfo.get("lid")));
            ps.setInt(4, Integer.parseInt(mInfo.get("mid")));
            ResultSet result = ps.executeQuery();
            if (!result.next()) {
                System.out.println("An error has occurred: try again.");
                this.createCustomer();
                return;
            }
            this.cid = result.getInt(1);

            System.out.println(
                "\nCustomer creation summary:" +
                "\n\tName:            " + name +
                "\n\tAddress:         " + addy +
                "\n\tLicense Number:  " + dlInfo.get("lid") +
                "\n\tState:           " + dlInfo.get("state") +
                "\n\tAge:             " + dlInfo.get("age") +
                "\n\tGroup Name:      " + mInfo.get("gname")
            );
            if (!Helpers.binaryQuery(this.main.s, "Are the above details correct?")) {
                this.createCustomer();
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
        Helpers.p("\tInput your license number > ");
        dlInfo.put("dln", this.main.s.nextLine());
        if (dlInfo.get("dln").equalsIgnoreCase("X")) this.run();
        Helpers.p("\tInput your license state > ");
        dlInfo.put("state", this.main.s.nextLine());
        if (dlInfo.get("state").equalsIgnoreCase("X")) this.run();
        Helpers.p("\tInput your age > ");
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
            ps.executeUpdate();
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
        Helpers.p("Search for the group that you belong to > ");
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
                Helpers.p("Input Membership ID from the list > ");
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
        if (Helpers.binaryQuery(this.main.s, "Would you like to search for your location?"))
            this.searchLocation();



    }

    void searchLocation() {
        Helpers.p("Input your location city or a substring of your location city > ");
        String sub = this.main.s.nextLine();
        if (sub.equalsIgnoreCase("X")) this.run();
        if (sub.contains("'")) {
            System.out.println("Name search substring may not contain single quotes.");
            this.searchLocation();
            return;
        }

        try {
            PreparedStatement ps = SQLStrings.searchLocation(this.main.c);
            ps.setString(1, "%" + sub + "%");
            ResultSet result = ps.executeQuery();
            if (!result.isBeforeFirst()) {
                System.out.println ("There are no locations matching that name.");
                this.searchLocation();
                return;
            } else {
                System.out.println("\nHere is a list of matching locations:\n");
                String fmtStr = "%-7s%-25s%-25s%-25s%-7s";
                System.out.println(String.format(fmtStr, "ID", "Street", "City", "State", "Zip"));
                while (result.next())
                    System.out.println(String.format(fmtStr, result.getString(1), result.getString(2), result.getString(3), result.getString(4), result.getString(5)));
                System.out.println();
            }
        } catch(Exception e) {
            System.out.println("An error has occurred: try again.");
            this.searchCustomer();
            return;
        }
    }

    void checkIDAlreadySelected(boolean invert) {
        if (!invert) {
            if (this.cid != -1 && !Helpers.binaryQuery(this.main.s, "A customer ID has already been selected. Would you like to overwrite it?"))
                this.run();
        } else {
            if (this.cid == -1 && Helpers.binaryQuery(this.main.s, "You have not selected a customer ID. Would you like to do that now?"))
                this.selectCustomer();
        }
    }
}
