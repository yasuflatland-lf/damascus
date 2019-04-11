package com.liferay.damascus.cli.relation.validators;

import java.util.LinkedHashMap;
import java.util.List;

import com.jayway.jsonpath.JsonPath;
import com.jayway.jsonpath.ReadContext;

/**
 * Relation Validator
 *
 * @author Yasuyuki Takeo
 *
 */
public class RelationValidator {

	/**
	 * Is Relation Exist
	 *
	 * Looking up relation parameters exist in the JSON file
	 *
	 * @param json base.json
	 * @return true more then one relation exist or false
	 */
	public boolean isRelationExist(String json) {
		List<String> ret = getClassNamesFromRelations(json);
		return (1 <= ret.size());
	}

	/**
	 * Get Relations
	 *
	 * Find "validation" field and pickup class names
	 *
	 * @param json base.json
	 * @return validation JSON fields
	 */
	protected List<String> getClassNamesFromRelations(String json) {
		return JsonPath.read(json, "$..validation.className");
	}

	/**
	 * Get Model With Field
	 *
	 * @param ctxRoot
	 * @param targetModel
	 * @param targetField
	 * @return
	 */
	protected List<String> getModelWithField(ReadContext ctxRoot, String targetModel, String targetField) {
		return ctxRoot.read(
				"$..applications[?(@.model == '" + targetModel + "')].fields[?(@.name == '" + targetField + "')]");
	}

	public boolean check(String json) {
		ReadContext ctxRoot = JsonPath.parse(json);
		List<LinkedHashMap<String, String>> validations = ctxRoot.read("$..validation");

		if (validations.size() <= 0) {
			return true;
		}

		boolean retVar = true;
		for (LinkedHashMap<String, String> validation : validations) {

			// Get fields in a validation field
			String className = validation.get(CLASS_NAME);
			String fieldName = validation.get(FIELD_NAME);
			String orderByField = validation.get(ORDER_BY_FIELD);

			// Check if the models in validation fields actually exist
			List<String> fieldList = getModelWithField(ctxRoot, className, fieldName);
			List<String> orderByFieldList = getModelWithField(ctxRoot, className, orderByField);

			if (fieldList.size() <= 0 ) {
				System.out.println("Class <" + className + "> Field<" + fieldName + "> wasn't found");
				retVar = false;
			}

			if(orderByFieldList.size() <= 0) {
				System.out.println("Class <" + className + "> orderByField<" + orderByField + "> wasn't found");
				retVar = false;
			}
		}

		return retVar;
	}

	static final public String CLASS_NAME = "className";
	static final public String FIELD_NAME = "fieldName";
	static final public String ORDER_BY_FIELD = "orderByField";
}
