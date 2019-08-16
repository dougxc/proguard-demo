package com.demo;
public class ServiceImpl implements Service {
    public void run() {
        System.out.println("provider: " + getClass().getName());
    }
}