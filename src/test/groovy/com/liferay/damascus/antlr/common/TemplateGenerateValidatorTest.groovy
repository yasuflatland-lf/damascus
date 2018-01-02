package com.liferay.damascus.antlr.common

import com.liferay.damascus.antlr.generator.TemplateContext
import spock.lang.Specification
import spock.lang.Unroll

import java.util.concurrent.ConcurrentHashMap

class TemplateGenerateValidatorTest extends Specification {

    @Unroll("rootValidator test <#attributes> expected errors(#result_size)")
    def "rootValidator test"() {
        when:
        def tc = Spy(TemplateContext, constructorArgs: [])
        Map<String, String> rootAttributes = new ConcurrentHashMap<>();
        attributes.each { k, v ->
            rootAttributes.put(k, v);
        }
        tc.getRootAttributes() >> rootAttributes
        List<String> result = TemplateGenerateValidator.rootValidator(tc)

        then:
        result.size == result_size

        where:
        attributes                | result_size | _
        ["templateName": "dummy"] | 0           | _ //success
        ["templateName": ""]      | 1           | _ //Error
        []                        | 1           | _ //Error

    }

    @Unroll("syncValidator test")
    def "syncValidator test"() {
        when:
        def tc = Spy(TemplateContext, constructorArgs: [])
        Map<String, String> syncAttributes = new ConcurrentHashMap<>();
        attributes.each { k, v ->
            syncAttributes.put(k, v);
        }
        tc.getSyncAttributes() >> syncAttributes
        List<String> result = TemplateGenerateValidator.syncValidator(tc)

        then:
        result.size == result_size

        where:
        attributes     | result_size | _
        ["id": "hoge"] | 0           | _ // success
        ["id": ""]     | 1           | _ // Error
        []             | 1           | _ // Error
    }
}
