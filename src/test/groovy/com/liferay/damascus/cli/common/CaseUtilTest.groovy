package com.liferay.damascus.cli.common

import com.beust.jcommander.internal.Maps
import com.google.common.io.Resources
import com.liferay.damascus.cli.json.DamascusBase
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.io.FileUtils
import org.apache.commons.io.filefilter.IOFileFilter
import org.apache.commons.io.filefilter.WildcardFileFilter
import org.apache.commons.lang3.StringUtils
import org.apache.commons.lang3.Validate
import org.joda.time.DateTime
import spock.lang.Specification
import spock.lang.Unroll

class CaseUtilTest extends Specification {

    def setup() {
    }

	def "Convert string from camel case to snake case"() {

        when:
        String actualOutput = CaseUtil.getInstance().camelCaseToSnakeCase(input)

        then:
        actualOutput == expectedOutput

        where:
        input              | expectedOutput        
        'helloWorld'       | 'hello_world'
        'HelloWorld'       | 'hello_world'
        'URLBuilder'       | 'url_builder'
        'UnknownURL'       | 'unknown_url'
   }
   
   	def "Convert string from camel case to dash case"() {

        when:
        String actualOutput = CaseUtil.getInstance().camelCaseToDashCase(input)

        then:
        actualOutput == expectedOutput

        where:
        input              | expectedOutput        
        'helloWorld'       | 'hello-world'
        'HelloWorld'       | 'hello-world'
        'URLBuilder'       | 'url-builder'
        'UnknownURL'       | 'unknown-url'
   }

}
