import java.util.Scanner;
import java.io.*;
import java.sql.*;

public class Main {
    Connection c;
    Scanner s;
    Customer customer;
    // Employee employee;
    // Manager manager;

    public static void main(String[] args) {
        new Main().run();
    }

    Main() {
        this.s = new Scanner(System.in);
        this.login();
    }

    void run() {
        System.out.println("Interface list:");
        System.out.println("\t[1] Customer");
        System.out.println("\t[2] Employee");
        System.out.println("\t[3] Manager");
        System.out.println("\t[X] Exit");
        Helpers.p("Select an interface > ");
        switch (s.nextLine()) {
            case "1":
                if (this.customer == null)
                    this.customer = new Customer(this);
                this.customer.run();
                break;
            case "2":
                // new Employee(con);
                break;
            case "3":
                // new Manger(con);
                break;
            case "X":
            case "x":
                System.out.println("Gracefully exiting program.");
                this.s.close();
                try {
                    this.c.close();
                    System.exit(0);
                } catch (Exception e) {
                    System.exit(0);
                }
                break;
            default:
                System.out.println("Invalid option. Try again.");
                run();
        }
    }

    void login() {
        // System.out.println("Please input your Oracle username on Edgar1:");
        // String login = this.s.nextLine();
        // System.out.println("Please input your Oracle password on Edgar1:");
        // Console console = System.console();
        // char[] pwd = console.readPassword();

        Connection c;
        try {
            // c = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:cse241", login, new String(pwd));
            c = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:cse241", "masa20", "1234");
            c.setAutoCommit(false);
            this.c = c;
        } catch (SQLException e) {
            System.out.println("Invalid credentials. Try again.");
            login();
        } catch (Exception e) {
            System.out.println("An unknown error has occured. Try again.");
            login();
        }
    }
}
