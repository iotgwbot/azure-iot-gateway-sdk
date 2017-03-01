package com.microsoft.azure.devices.gateway;

import java.io.*;
import java.net.*;
import java.util.*;

/**
 * Run "{gw.exe | gw} [options]" located in the current folder or JAR folder.
 *
 */
public class IoTGateway {
    private static final String GW_EXECUTABLE_NAME_WIN32 = "gw.exe";
    private static final String GW_EXECUTABLE_NAME_LINUX = "gw";
    private static final String LD_LIBRARY_PATH_ENV_NAME = "LD_LIBRARY_PATH";

    private static boolean needToSetLdPath = false;
    private static String executableContainerPath = null;
    private static String executablePath = null;

    public static void main( String[] args ) throws IOException, InterruptedException {
        parseAmbientEnvironment();

        List<String> gwArguments = new ArrayList<String>();
        gwArguments.add(executablePath);
        gwArguments.addAll(Arrays.asList(args));

        ProcessBuilder gwProcBuilder = new ProcessBuilder(gwArguments);
        gwProcBuilder.inheritIO();
        if (needToSetLdPath) {
            Map<String, String> environmentVars = gwProcBuilder.environment();
            environmentVars.put(LD_LIBRARY_PATH_ENV_NAME, executableContainerPath);
        }

        Process gwProc = gwProcBuilder.start();
        gwProc.waitFor();
    }

    private static void parseAmbientEnvironment() throws IOException {
        final String GW_EXECUTABLE_NAME_WIN32 = "gw.exe";
        final String GW_EXECUTABLE_NAME_LINUX = "gw";
        String gwExecutableFileName = null;

        // Try to look for the executable name (either "gw.exe" or "gw")
        if (hasResourceFileInRoot(GW_EXECUTABLE_NAME_WIN32)) {
            gwExecutableFileName = GW_EXECUTABLE_NAME_WIN32;
        } else if (hasResourceFileInRoot(GW_EXECUTABLE_NAME_LINUX)) {
            gwExecutableFileName = GW_EXECUTABLE_NAME_LINUX;
            needToSetLdPath = true;
        } else {
            throw new IOException("No gateway executable found in this jar file");
        }

        // Try to execute the gateway in current folder
        File gwInCurrentFolder = new File(gwExecutableFileName);
        if (gwInCurrentFolder.exists()) {
            executablePath = gwInCurrentFolder.getAbsolutePath();
            executableContainerPath = new File(".").getAbsolutePath();
            return;
        }

        // Try to execute the gateway in JAR folder
        URL jarFileUrl = IoTGateway.class.getProtectionDomain().getCodeSource().getLocation();
        File gwJarFile = new File(jarFileUrl.getPath());
        String gwJarContainerPath = gwJarFile.getParent();
        File gwInJarFolder = new File(gwJarContainerPath, gwExecutableFileName);
        if (gwInJarFolder.exists()) {
            executablePath = gwInJarFolder.getAbsolutePath();
            executableContainerPath = gwJarContainerPath;
            return;
        }

        throw new IOException(String.format("Could not find gateway executable (%s)", gwExecutableFileName));
    }

    private static boolean hasResourceFileInRoot(String filename) {
        String filepath = String.format("/%s", filename);
        return IoTGateway.class.getResource(filepath) != null;
    }
}
