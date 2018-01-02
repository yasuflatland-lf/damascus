package com.liferay.damascus.cli.test.tools

import org.apache.commons.io.FileUtils
import spock.lang.Specification

import java.nio.file.Files

class AntlrTestBase extends Specification {
    protected final ByteArrayOutputStream outContent = new ByteArrayOutputStream();
    protected final ByteArrayOutputStream errContent = new ByteArrayOutputStream();

    //TODO : replace here DamascusProps
    static protected final String TEMP_DIR = System.getProperty("java.io.tmpdir")
    static protected final String TEST_DIR = "testdir"
    //TODO : replace here DamascusProps
    static protected final String DS = File.separator

    //TODO : replace here DamascusProps
    static protected final String SRC_DIR = TEMP_DIR + DS + TEST_DIR + DS + "src"
    static protected final String TMPLATE_DIR = TEMP_DIR + DS + TEST_DIR + DS + "template"

    def setup() {
        FileUtils.deleteQuietly(new File(TEMP_DIR + TEST_DIR))
        System.setOut(new PrintStream(outContent));
        System.setErr(new PrintStream(errContent));
    }

    def cleanup() {
        System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
        System.setErr(new PrintStream(new FileOutputStream(FileDescriptor.err)));
    }
}