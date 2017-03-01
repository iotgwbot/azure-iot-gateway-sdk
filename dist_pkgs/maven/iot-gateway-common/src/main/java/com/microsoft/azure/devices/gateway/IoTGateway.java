package com.microsoft.azure.devices.gateway;

import java.io.*;
import java.net.*;
import java.util.*;

/**
 * Run "gw.exe [options]" located in the current folder or JAR folder.
 *
 */
public class IoTGateway {
    public static void main( String[] args ) throws IOException, InterruptedException {
        String gwExecutable = getGatewayExecutable();
        if (gwExecutable == null) {
            throw new IOException("Gateway executable (gw.exe) not found");
        }

        List<String> gwArguments = new ArrayList<String>();
        gwArguments.add(gwExecutable);
        gwArguments.addAll(Arrays.asList(args));

        ProcessBuilder gwProcBuilder = new ProcessBuilder(gwArguments);
        gwProcBuilder.inheritIO();

        Process gwProc = gwProcBuilder.start();
        gwProc.waitFor();
    }

    private static String getGatewayExecutable() {
        final String GW_EXECUTABLE_NAME = "gw.exe";

        // Try to execute the gateway in current folder
        File gwInCurrentFolder = new File(GW_EXECUTABLE_NAME);
        if (gwInCurrentFolder.exists()) {
            return gwInCurrentFolder.getAbsolutePath();
        }

        // Try to execute the gateway in JAR folder
        URL jarFileUrl = IoTGateway.class.getProtectionDomain().getCodeSource().getLocation();
        File gwJarFile = new File(jarFileUrl.getPath());
        File gwInJarFolder = new File(gwJarFile.getParent(), GW_EXECUTABLE_NAME);
        if (gwInJarFolder.exists()) {
            return gwInJarFolder.getAbsolutePath();
        }

        return null;
    }
}
