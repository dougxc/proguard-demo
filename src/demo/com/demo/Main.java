package com.demo;
public class Main {
    public static void main(String[] args) {
        for (Service service : java.util.ServiceLoader.load(Main.class.getModule().getLayer(), Service.class)) {
            service.run();
        }
    }
}