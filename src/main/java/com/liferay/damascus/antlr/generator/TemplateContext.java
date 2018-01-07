package com.liferay.damascus.antlr.generator;

import java.util.Map;

public interface TemplateContext {

	/**
	 * Set Root Attribute
	 *
	 * @param key
	 * @param value
	 */
	void setRootAttribute(String key, String value);

	/**
	 * Get Root Attribute
	 *
	 * @param key
	 * @return
	 */
	String getRootAttribute(String key);

	/**
	 * Set Sync Attribute
	 *
	 * @param key
	 * @param value
	 */
	void setSyncAttribute(String key, String value);

	/**
	 * Get Attribute value
	 *
	 * @param key
	 * @return Attribute value string
	 */
	String getSyncAttribute(String key);

	/**
	 * Check Sync ID exist
	 *
	 * @param syncId
	 * @return
	 */
	boolean isSyncIdExist(String syncId);

	Map<String, String> getRootAttributes();

	Map<String, String> getSyncAttributes();

	Map<String, String> getContentsIdMap();

	boolean isRootTagExist();

	void setContentsIdMap(Map<String, String> contentsIdMap);

	void setRootTagExist(boolean rootTagExist);

	void setPickup(boolean pickup);

	boolean isPickup();
}