package com.liferay.damascus.cli

import spock.lang.Specification
import spock.lang.Unroll

class DamascusTest extends Specification {
    def String EOL =
        System.getProperty("line.separator");
    def PrintStream console;
    def ByteArrayOutputStream bytes;

    /**
     * Set up for console application
     * @return
     */
    def setup() {
        bytes = new ByteArrayOutputStream();
        console = System.out;
        System.setOut(new PrintStream(bytes));
    }

    def cleanup() {
        System.setOut(console);
    }

    def "Smoke test for main"() {
        when:
        Damascus.main()

        then:
        "" != bytes.toString()
    }

    @Unroll("help Test arvg1<#argv1>")
    def "help Test"() {
        when:
        String[] args = [argv1]
        Damascus.main(args)

        then:
        "" != bytes.toString()

        where:
        argv1    | _
        "--help" | _
        "-h"     | _
    }

}