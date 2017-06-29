package com.liferay.damascus.cli.common;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.datatype.joda.JodaModule;
import com.liferay.project.templates.internal.util.Validator;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.security.InvalidParameterException;

/**
 * JSON Utility
 *
 * @author Yasuyuki Takeo
 */
public class JsonUtil {

    /**
     * Get JSON Mapped object from Resource
     *
     * @param path         path to the json file (under resource folder inside of this jar)
     * @param clazz        class to map the json file
     * @param classContext class context where the target resources are belonging to
     * @param <T>          Mapped class
     * @return
     * @throws JsonParseException
     * @throws JsonMappingException
     * @throws IOException
     */
    public static <T> T getObjectFromResource(
        String path, final Class<T> clazz, Class<?> classContext)
        throws JsonParseException, JsonMappingException, IOException {

        String jsonString = CommonUtil.readResource(classContext, path);

        return toObject(jsonString, clazz);
    }

    /**
     * Get JSON Mapped object
     *
     * @param path  path to the json file
     * @param clazz class to map the json file
     * @param <T>   Mapped class
     * @return Mapped Json object
     * @throws JsonParseException
     * @throws JsonMappingException
     * @throws IOException
     */
    public static <T> T getObject(
        String path, final Class<T> clazz)
        throws JsonParseException, JsonMappingException, IOException {

        String jsonString = FileUtils.readFileToString(new File(path), "utf-8");

        return toObject(jsonString, clazz);
    }

    /**
     * Map json to the actual object
     *
     * @param jsonString json strings to map to the object
     * @param clazz      class
     * @param <T>        Mapped class
     * @return
     * @throws JsonParseException
     * @throws JsonMappingException
     * @throws IOException
     */
    public static <T> T toObject(final String jsonString, final Class<T> clazz)
        throws JsonParseException, JsonMappingException, IOException {

        ObjectMapper mapper = new ObjectMapper();

        //just ignore unknown properties in json
        //mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        mapper.registerModule(new JodaModule());

        if (Validator.isNull(jsonString)) {
            throw new InvalidParameterException("jsonString is null.");
        }

        return mapper.readValue(jsonString, clazz);
    }

    /**
     * Write JSON file
     *
     * @param fullPath including target file name. e.g. /path/to/thisfile.txt
     * @param obj      Object to be serialized.
     * @param <T>
     * @throws IOException
     * @throws URISyntaxException
     */
    public static <T> void writer(String fullPath, T obj) throws IOException, URISyntaxException {
        //ObjectMapper mapper = new ObjectMapper();
        ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
        ow.writeValue(new File(fullPath), obj);
    }
}
