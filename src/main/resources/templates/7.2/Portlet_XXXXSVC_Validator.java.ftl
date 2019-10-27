// <dmsc:root templateName="Portlet_XXXXSVC_Validator.java.ftl"  />

package ${packageName}.service.util;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.repository.model.ModelValidator;
import ${packageName}.exception.${capFirstModel}ValidateException;
import ${packageName}.model.${capFirstModel};

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

public class ${capFirstModel}Validator implements ModelValidator<${capFirstModel}> {

	@Override
	public void validate(${capFirstModel} entry) throws PortalException {

		// Field ${lowercaseModel}Id

		validateSamplesbId(entry.getSamplesbId());

		// Field title

		validateTitle(entry.getTitle());

		// Field ${lowercaseModel}BooleanStat

		validateSamplesbBooleanStat(entry.getSamplesbBooleanStat());

		// Field ${lowercaseModel}DateTime

		validateSamplesbDateTime(entry.getSamplesbDateTime());

		// Field ${lowercaseModel}DocumentLibrary

		validateSamplesbDocumentLibrary(entry.getSamplesbDocumentLibrary());

		// Field ${lowercaseModel}Double

		validateSamplesbDouble(entry.getSamplesbDouble());

		// Field ${lowercaseModel}Integer

		validateSamplesbInteger(entry.getSamplesbInteger());

		// Field ${lowercaseModel}RichText

		validateSamplesbRichText(entry.getSamplesbRichText());

		// Field ${lowercaseModel}Text

		validateSamplesbText(entry.getSamplesbText());

		if (0 < _errors.size()) {
			throw new ${capFirstModel}ValidateException(_errors);
		}
	}

	/**
	 * ${lowercaseModel}BooleanStat field Validation
	 *
	 * @param field ${lowercaseModel}BooleanStat
	 */
	protected void validateSamplesbBooleanStat(boolean field) {

		// TODO : This validation needs to be implemented. Add error message key into
		// _errors when an error occurs.

	}

	/**
	 * ${lowercaseModel}DateTime field Validation
	 *
	 * @param field ${lowercaseModel}DateTime
	 */
	protected void validateSamplesbDateTime(Date field) {

		// TODO : This validation needs to be implemented. Add error message key into
		// _errors when an error occurs.

	}

	/**
	 * ${lowercaseModel}DocumentLibrary field Validation
	 *
	 * @param field ${lowercaseModel}DocumentLibrary
	 */
	protected void validateSamplesbDocumentLibrary(String field) {

		// TODO : This validation needs to be implemented. Add error message key into
		// _errors when an error occurs.

	}

	/**
	 * ${lowercaseModel}Double field Validation
	 *
	 * @param field ${lowercaseModel}Double
	 */
	protected void validateSamplesbDouble(double field) {

		// TODO : This validation needs to be implemented. Add error message key into
		// _errors when an error occurs.

	}

	/**
	 * ${lowercaseModel}Id field Validation
	 *
	 * @param field ${lowercaseModel}Id
	 */
	protected void validateSamplesbId(long field) {

		// TODO : This validation needs to be implemented. Add error message key into
		// _errors when an error occurs.

	}

	/**
	 * ${lowercaseModel}Integer field Validation
	 *
	 * @param field ${lowercaseModel}Integer
	 */
	protected void validateSamplesbInteger(int field) {

		// TODO : This validation needs to be implemented. Add error message key into
		// _errors when an error occurs.

	}

	/**
	 * ${lowercaseModel}RichText field Validation
	 *
	 * @param field ${lowercaseModel}RichText
	 */
	protected void validateSamplesbRichText(String field) {

		// TODO : This validation needs to be implemented. Add error message key into
		// _errors when an error occurs.

	}

	/**
	 * ${lowercaseModel}Text field Validation
	 *
	 * @param field ${lowercaseModel}Text
	 */
	protected void validateSamplesbText(String field) {

		// TODO : This validation needs to be implemented. Add error message key into
		// _errors when an error occurs.

	}

	/**
	 * title field Validation
	 *
	 * @param field title
	 */
	protected void validateTitle(String field) {

		// TODO : This validation needs to be implemented. Add error message key into
		// _errors when an error occurs.

		if (!StringUtils.isNotEmpty(field)) {
			_errors.add("${lowercaseModel}-title-required");
		}
	}

	protected List<String> _errors = new ArrayList<>();

}