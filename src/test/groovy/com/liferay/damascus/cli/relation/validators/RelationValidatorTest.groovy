package com.liferay.damascus.cli.relation.validators

import com.jayway.jsonpath.JsonPath
import com.jayway.jsonpath.ReadContext
import com.liferay.damascus.cli.common.CommonUtil
import com.liferay.damascus.cli.common.DamascusProps
import spock.lang.Specification
import spock.lang.Unroll

class RelationValidatorTest extends Specification {
	static def DS = DamascusProps.DS;

	@Unroll("getRelations Test <#version> <#base_json_name> <#caseName>")
	def "getRelations Test"() {
		when:
		def file_path = DS + DamascusProps.TEMPLATE_FOLDER_NAME + DS + version + DS + base_json_name;
		def json = CommonUtil.readResource(RelationValidator.class, file_path);
		RelationValidator rv = new RelationValidator();
		def validList = rv.getClassNamesFromRelations(json);
		def stat = rv.isRelationExist(json);

		then:
		if(caseName.equals("success pattern")) {
			assert validList != null
			assert validList.get(0) == "Position"
		} else {
			assert validList == []
		}
		stat == statusFlag

		where:
		version 					| base_json_name				| caseName			| statusFlag
		DamascusProps.VERSION_71	| "base_relation_success.json"	| "success pattern"	| true
		DamascusProps.VERSION_71	| "base_activity_false.json"	| "fail pattern"	| false
	}

	@Unroll("getModelWithField Test <#version> <#base_json_name> <#modelName>")
	def "getModelWithField Test"() {
		when:
		def file_path = DS + DamascusProps.TEMPLATE_FOLDER_NAME + DS + version + DS + base_json_name;
		def json = CommonUtil.readResource(RelationValidatorTest.class, file_path);
		RelationValidator rv = new RelationValidator();
		ReadContext ctx = JsonPath.parse(json);
		def list = rv.getModelWithField(ctx, modelName, fieldName);

		then:
		list.size() == retSize

		where:
		version 					| base_json_name				| modelName		| fieldName		| retSize
		DamascusProps.VERSION_71	| "base_relation_success.json"	| "Position"	| "positionId"	| 1
		DamascusProps.VERSION_71	| "base_relation_success.json"	| "Employee"	| "name"		| 1
		DamascusProps.VERSION_71	| "base_relation_success.json"	| "Position"	| "hoge"		| 0
		DamascusProps.VERSION_71	| "base_relation_success.json"	| "Employee"	| "hoge"		| 0

	}

	@Unroll("Check Test <#version> <#base_json_name>")
	def "Check Test"() {
		when:
		def file_path = DS + DamascusProps.TEMPLATE_FOLDER_NAME + DS + version + DS + base_json_name;
		def json = CommonUtil.readResource(RelationValidatorTest.class, file_path);
		RelationValidator rv = new RelationValidator();
		def stat = rv.check(json);

		then:
		stat == statusFlag

		where:
		version 					| base_json_name				| statusFlag
		DamascusProps.VERSION_71	| "base_activity_false.json"	| true
		DamascusProps.VERSION_71	| "base_relation_success.json"	| true
		DamascusProps.VERSION_71	| "base_relation_fail.json"		| false
	}
}
