package com.liferay.damascus.cli.json

import com.beust.jcommander.ParameterException
import com.beust.jcommander.internal.Lists
import spock.lang.Specification
import spock.lang.Unroll

import java.security.InvalidParameterException

class ApplicationTest extends Specification {

    @Unroll("Applications has hasPrimary Success test var1<#var1> var2<#var2> var3<#var3> ")
    def "Application has hasPrimary Success test"() {
        when:
        def app = new Application()
        app.fields = Lists.newArrayList()
        def field1 = new com.liferay.damascus.cli.json.fields.Long();
        field1.setPrimary(var1);
        def field2 = new com.liferay.damascus.cli.json.fields.Double();
        field2.setPrimary(var2);
        def field3 = new com.liferay.damascus.cli.json.fields.Text();
        field3.setPrimary(var3);

        app.setTitle("This test") // for test
        app.fields.add(field1)
        app.fields.add(field2)
        app.fields.add(field3)

        def retVal = app.hasPrimary()

        then:
        true == app.hasPrimary()

        where:
        var1  | var2  | var3
        true  | false | false
        false | true  | false
        false | false | true
    }

    @Unroll("Applications has hasPrimary Fail test var1<#var1> var2<#var2> var3<#var3>")
    def "Application has hasPrimary Fail test"() {
        when:
        def app = new Application()
        app.fields = Lists.newArrayList()
        def field1 = new com.liferay.damascus.cli.json.fields.Long();
        field1.setPrimary(var1);
        def field2 = new com.liferay.damascus.cli.json.fields.Double();
        field2.setPrimary(var2);
        def field3 = new com.liferay.damascus.cli.json.fields.Text();
        field3.setPrimary(var3);

        app.setTitle("This test") // for test
        app.fields.add(field1)
        app.fields.add(field2)
        app.fields.add(field3)

        app.hasPrimary()

        then:
        thrown(InvalidParameterException)

        where:
        var1  | var2  | var3
        true  | true  | false
        false | true  | true
        true  | true  | true
        false | false | false
    }
}
