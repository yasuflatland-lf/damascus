package com.liferay.damascus.cli.json

import com.beust.jcommander.ParameterException
import com.beust.jcommander.internal.Lists
import spock.lang.Specification
import spock.lang.Unroll

import java.security.InvalidParameterException

class ApplicationTest extends Specification {

    @Unroll("Applications has hasPrivmaly Success test var1<#var1> var2<#var2> var3<#var3> ")
    def "Application has hasPrivmaly Success test"() {
        when:
        def app = new Application()
        app.fields = Lists.newArrayList()
        def field1 = new com.liferay.damascus.cli.json.fields.Long();
        field1.setprimary(var1);
        def field2 = new com.liferay.damascus.cli.json.fields.Double();
        field2.setprimary(var2);
        def field3 = new com.liferay.damascus.cli.json.fields.Text();
        field3.setprimary(var3);

        app.setTitle("This test") // for test
        app.fields.add(field1)
        app.fields.add(field2)
        app.fields.add(field3)

        def retVal = app.hasPrivmaly()

        then:
        true == app.hasPrivmaly()

        where:
        var1  | var2  | var3
        true  | false | false
        false | true  | false
        false | false | true
    }

    @Unroll("Applications has hasPrivmaly Fail test var1<#var1> var2<#var2> var3<#var3>")
    def "Application has hasPrivmaly Fail test"() {
        when:
        def app = new Application()
        app.fields = Lists.newArrayList()
        def field1 = new com.liferay.damascus.cli.json.fields.Long();
        field1.setprimary(var1);
        def field2 = new com.liferay.damascus.cli.json.fields.Double();
        field2.setprimary(var2);
        def field3 = new com.liferay.damascus.cli.json.fields.Text();
        field3.setprimary(var3);

        app.setTitle("This test") // for test
        app.fields.add(field1)
        app.fields.add(field2)
        app.fields.add(field3)

        app.hasPrivmaly()

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
