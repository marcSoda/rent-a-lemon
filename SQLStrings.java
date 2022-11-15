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

}
