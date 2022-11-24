import java.sql.*;

class SQLStrings {
    static PreparedStatement searchCustomer(Connection c) throws SQLException {
        return c.prepareStatement(
            "SELECT customer_id, name " +
            "FROM customer " +
            "WHERE name LIKE ? " +
            "ORDER BY name"
        );
    }

    static PreparedStatement selectCustomer(Connection c) throws SQLException {
        return c.prepareStatement(
            "SELECT customer_id " +
            "FROM customer " +
            "WHERE customer_id = ?"
        );
    }

    static PreparedStatement createLicense(Connection c) throws SQLException {
        return c.prepareStatement(
            "INSERT INTO license (license_id, license_number, state, age) " +
            "VALUES (DEFAULT, ?, ?, ?)",
            new String[] { "license_id" }
        );
    }

    static PreparedStatement createCustomer(Connection c) throws SQLException {
        return c.prepareStatement(
            "INSERT INTO customer (address, name, license_id, membership_id) " +
            "VALUES (?, ?, ?, ?)",
            new String[] { "customer_id" }
        );
    }

    static PreparedStatement searchMembership(Connection c) throws SQLException {
        return c.prepareStatement(
            "SELECT membership_id, group_name " +
            "FROM membership " +
            "WHERE group_name LIKE ?" +
            "ORDER BY group_name"
        );
    }

    static PreparedStatement getMembershipByID(Connection c) throws SQLException {
        return c.prepareStatement(
            "SELECT membership_id, group_name " +
            "FROM membership " +
            "WHERE membership_id = ?"
        );
    }

    static PreparedStatement searchLocation(Connection c) throws SQLException {
        return c.prepareStatement(
            "SELECT location_id, street, city, state, zip " +
            "FROM location " +
            "WHERE city LIKE ?" +
            "ORDER BY city"
        );
    }

    static PreparedStatement selectLocation(Connection c) throws SQLException {
        return c.prepareStatement(
            "SELECT location_id " +
            "FROM location " +
            "WHERE location_id = ?"
        );
    }

    static PreparedStatement listVehicles(Connection c) throws SQLException {
        return c.prepareStatement(
            "select v.vehicle_id, v.make, v.model, v.year, v.color, v.type, v.location_id " +
            "from vehicle v " +
            "where v.location_id = ? " +
            "and v.vehicle_id not in " +
                "(select vehicle_id from vehicle " +
                "natural join reservation " +
                "where created between sysdate - 10 and sysdate) " +
            "and v.vehicle_id not in " +
                "(select vehicle_id from vehicle " +
                "natural join rental " +
                "where returned is null) " +
            "order by v.vehicle_id"
        );
    }

    static PreparedStatement selectVehicle(Connection c) throws SQLException {
        return c.prepareStatement(
            "SELECT vehicle_id " +
            "FROM vehicle " +
            "WHERE vehicle_id = ?"
        );
    }

    static PreparedStatement createReservation(Connection c) throws SQLException {
        return c.prepareStatement(
            "INSERT INTO reservation (created, customer_id, vehicle_id) " +
            "VALUES (sysdate, ?, ?)"
        );
    }

    static PreparedStatement deleteReservation(Connection c) throws SQLException {
        return c.prepareStatement(
            "DELETE FROM reservation " +
            "WHERE reservation_id = ? AND customer_id = ?"
        );
    }

    static PreparedStatement listReservations(Connection c) throws SQLException {
        return c.prepareStatement(
            "SELECT reservation_id, created, make, model, year, color, type " +
            "FROM reservation NATURAL JOIN vehicle " +
            "WHERE customer_id = ? " +
            "ORDER BY created"
        );
    }

    static PreparedStatement listOutstandingCharges(Connection c) throws SQLException {
        return c.prepareStatement(
            "select charge_id, fuel, dropoff, insurance, other, rate, percent_off, " +
            "    round(((fuel + dropoff + insurance + other + rate) * (percent_off / 100)),2) " +
            "    as total from charge " +
            "natural join rental " +
            "natural join customer " +
            "natural join membership " +
            "natural join discount " +
            "where customer_id = ? " +
            "    and complete = 0 " +
            "order by charge_id"
        );
    }

    static PreparedStatement completeCharge(Connection c) throws SQLException {
        return c.prepareStatement(
            "UPDATE charge " +
            "SET complete=1 " +
            "where charge_id in ( " +
            "    select charge_id from charge " +
            "   natural join rental " +
            "    natural join customer " +
            "    where customer_id = ? " +
            "       and complete = 0 " +
            "       and charge_id = ? " +
            ")"
        );
    }

    static PreparedStatement listRentals (Connection c) throws SQLException {
        return c.prepareStatement(
            "select rental_id, taken, returned, rate, model, year, color, type, city, " +
            "state from rental " +
            "natural join customer " +
            "natural join vehicle " +
            "natural join location " +
            "where customer_id = ? " +
            "order by taken"
        );
    }

    static PreparedStatement listCharges(Connection c) throws SQLException {
        return c.prepareStatement(
            "select charge_id, fuel, dropoff, insurance, other, rate, percent_off, " +
            "    round(((fuel + dropoff + insurance + other + rate) * (percent_off / 100)),2) " +
            "    as total from charge " +
            "natural join rental " +
            "natural join customer " +
            "natural join membership " +
            "natural join discount " +
            "where customer_id = ? " +
            "order by charge_id"
        );
    }

    static PreparedStatement createRental(Connection c) throws SQLException {
        return c.prepareStatement(
            "INSERT INTO rental (taken, returned, rate, customer_id, vehicle_id) " +
            "VALUES (sysdate, null, ?, ?, ?)"
        );
    }
}
