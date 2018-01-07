package com.liferay.damascus.cli.test.tools

import com.liferay.damascus.cli.common.DamascusProps
import org.apache.commons.io.FileUtils
import spock.lang.Specification

class AntlrTestBase extends Specification {
    protected final ByteArrayOutputStream outContent = new ByteArrayOutputStream();
    protected final ByteArrayOutputStream errContent = new ByteArrayOutputStream();

    static protected final String TEST_DIR = "AntlrTestBaseTest"
    static protected final String DS = DamascusProps.DS

    static protected
    final String SRC_DIR = TestUtils.getTempPath() + TEST_DIR + DS + "src"
    static protected
    final String TMPLATE_DIR = TestUtils.getTempPath() + TEST_DIR + DS + "template"

    def setup() {
        FileUtils.deleteQuietly(new File(TestUtils.getTempPath() + TEST_DIR))
        System.setOut(new PrintStream(outContent));
        System.setErr(new PrintStream(errContent));
    }

    def cleanup() {
        System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
        System.setErr(new PrintStream(new FileOutputStream(FileDescriptor.err)));
    }
}