package com.liferay.damascus.antlr.common

import spock.lang.Specification
import spock.lang.Unroll

class DmscSrcParserExListenerTest extends Specification {

    @Unroll("Strip test")
    def "Strip test"() {
        when:
        DmscSrcParserExListener dspe = new DmscSrcParserExListener()
        def result = dspe.stripQuotations(pattern)

        then:
        result == expected

        where:
        pattern    | expected
        "\"hoge\"" | "hoge"
        '\'hoge\'' | "hoge"
        '<hoge>'   | "<hoge>"

    }
}
