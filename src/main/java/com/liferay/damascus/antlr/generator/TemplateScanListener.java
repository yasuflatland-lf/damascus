package com.liferay.damascus.antlr.generator;

import com.liferay.damascus.antlr.common.DmscSrcParserExListener;
import com.liferay.damascus.antlr.template.DmscSrcParser;
import com.liferay.damascus.antlr.template.DmscSrcParser.AttributeContext;
import com.liferay.damascus.cli.common.DamascusProps;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.util.List;

/**
 * Template Scan Listener
 * <p>
 * Scanning a target template file to correct replace contents for template process
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
public class TemplateScanListener extends DmscSrcParserExListener {

    /**
     * Constructor
     */
    public TemplateScanListener() {

        targetTemplateContext = new TemplateContextImpl();
    }

    /**
     * Get Sync Start element
     */
    @Override
    public void exitSyncelementStart(DmscSrcParser.SyncelementStartContext ctx) {
        List<AttributeContext> attributes = ctx.attribute();

        String currentId = getAttributeValue(attributes, DamascusProps.ATTR_ID);

        if (!currentId.equals("")) {
            if (targetTemplateContext.isSyncIdExist(currentId)) {
                setError("ID is duplicated. The old id contents will be overwritten. Id <" + currentId + ">");
            }
            targetTemplateContext.setSyncAttribute(currentId, "");

            setCurrentSyncId(currentId);
        }

    }

    @Override
    public void exitSyncelementEnd(DmscSrcParser.SyncelementEndContext ctx) {
        currentSyncId = "";
    }

    /**
     * Get text data between sync tag
     */
    @Override
    public void exitSavedata(DmscSrcParser.SavedataContext ctx) {
        if (null == currentSyncId) {
            setError("Skip save data because some required data are null <" + StringUtils.truncate(ctx.getText(),100) + ">");
            return;
        }

        if (!targetTemplateContext.isSyncIdExist(currentSyncId)) {
            setError("No target id contents found : Target ID <" + currentSyncId + ">");
            return;
        }

        if (log.isDebugEnabled()) {
            log.debug("ID <" + currentSyncId + ">");
            log.debug("Text <<< " + ctx.getText() + ">>>");
        }

        targetTemplateContext.setSyncAttribute(currentSyncId, ctx.getText());
        setCurrentSyncId(null);
    }

    @Getter
    @Setter
    protected String currentSyncId = null;

    @Getter
    protected TemplateContext targetTemplateContext;
}
