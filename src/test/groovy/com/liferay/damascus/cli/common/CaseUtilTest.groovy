package com.liferay.damascus.cli.common

import spock.lang.Specification
import spock.lang.Unroll

class CaseUtilTest extends Specification {

    def setup() {
    }

    @Unroll("Convert string from camel case to snake case input<#input> expectedOutput<#expectedOutput>")
    def "Convert string from camel case to snake case"() {

        when:
        String actualOutput = CaseUtil.camelCaseToSnakeCase(input)

        then:
        actualOutput == expectedOutput

        where:
        input        | expectedOutput
        'helloWorld' | 'hello_world'
        'HelloWorld' | 'hello_world'
        'URLBuilder' | 'url_builder'
        'UnknownURL' | 'unknown_url'
    }

    @Unroll("Convert string from camel case to dash case input<#input> expectedOutput<#expectedOutput>")
    def "Convert string from camel case to dash case"() {

        when:
        String actualOutput = CaseUtil.camelCaseToDashCase(input)

        then:
        actualOutput == expectedOutput

        where:
        input        | expectedOutput
        'helloWorld' | 'hello-world'
        'HelloWorld' | 'hello-world'
        'URLBuilder' | 'url-builder'
        'UnknownURL' | 'unknown-url'
    }

}
