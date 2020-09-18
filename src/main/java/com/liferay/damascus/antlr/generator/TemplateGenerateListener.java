package com.liferay.damascus.antlr.generator;

import com.liferay.damascus.antlr.common.DmscSrcParserExListener;
import com.liferay.damascus.antlr.common.TemplateGenerateValidator;
import com.liferay.damascus.antlr.template.DmscSrcParser;
import com.liferay.damascus.antlr.template.DmscSrcParser.AttributeContext;
import com.liferay.damascus.cli.common.DamascusProps;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.TokenStreamRewriter;
import org.apache.commons.lang3.StringUtils;

import java.util.List;

/**
 * Template Generate Listener
 * <p>
 * Listener for converting source files into templates.
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
public class TemplateGenerateListener extends DmscSrcParserExListener {

    /**
     * Constructor
     *
     * @param tokens
     * @param targetTemplateContext
     */
    public TemplateGenerateListener(TokenStream tokens, TemplateContext targetTemplateContext) {

        rewriter = new TokenStreamRewriter(tokens);
        sourceContext = new TemplateContextImpl();
        this.targetTemplateContext = targetTemplateContext;
        setCurrentSyncId(null);
    }

    /**
     * Get Root Element
     */
    @Override
    public void exitRootelement(DmscSrcParser.RootelementContext ctx) {

        List<AttributeContext> attributes = ctx.attribute();
        for (AttributeContext attribute : attributes) {

            String Key = stripQuotations(attribute.Name().getText());
            String value = stripQuotations(attribute.STRING().getText());

            sourceContext.setRootAttribute(Key, value);

            if(Key.equals(DamascusProps.ATTR_PICKUP)) {

                sourceContext.setPickup(true);

                // Erase pickup tag for output.
                rewriter.replace(attribute.start, attribute.stop, "");
            }
        }

        // Root tag exist flag
        sourceContext.setRootTagExist(true);

        // Validate attributes
        List<String> errors = TemplateGenerateValidator.rootValidator(sourceContext);
        if (!errors.isEmpty()) {
            setErrors(errors);
        }

    }

    /**
     * Get Sync Start element
     */
    @Override
    public void exitSyncelementStart(DmscSrcParser.SyncelementStartContext ctx) {
        List<AttributeContext> attributes = ctx.attribute();

        String currentId = getAttributeValue(attributes, DamascusProps.ATTR_ID);

        if (!currentId.equals("")) {
            if (sourceContext.isSyncIdExist(currentId)) {
                setError("ID is duplicated. The old id contents will be overwritten. Id <" + currentId + ">");
            }
            sourceContext.setSyncAttribute(currentId, "");

            setCurrentSyncId(currentId);
        }
    }

    /**
     * Get text data between sync tag
     */
    @Override
    public void exitSavedata(DmscSrcParser.SavedataContext ctx) {
        if (null == targetTemplateContext ) {
            log.debug("targetTemplateContext is null. skip.");
            return;
        }

        if (null == currentSyncId) {

            StringBuffer errorMsg = new StringBuffer();
            errorMsg.append("Skip save data because some required data are null <" + StringUtils.truncate(ctx.getText(),200) + "....>");
            log.error(errorMsg.toString());
            errors.add(errorMsg.toString());
            return;
        }

        if (!targetTemplateContext.isSyncIdExist(currentSyncId)) {
            setError("No target id contents found : Target ID <" + currentSyncId + ">");
            return;
        }

        // Replace contents
        rewriter.replace(ctx.start, ctx.stop, targetTemplateContext.getSyncAttribute(currentSyncId));

        // Reset currentSyncId
        setCurrentSyncId(null);
    }

    @Getter
    protected TokenStreamRewriter rewriter;

    @Getter
    protected TemplateContext sourceContext;

    protected TemplateContext targetTemplateContext;

    @Getter
    @Setter
    protected String currentSyncId = null;

}
