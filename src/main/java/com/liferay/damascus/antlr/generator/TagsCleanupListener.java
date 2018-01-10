package com.liferay.damascus.antlr.generator;

import com.liferay.damascus.antlr.common.DmscSrcParserExListener;
import com.liferay.damascus.antlr.template.DmscSrcParser;
import lombok.Getter;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.TokenStreamRewriter;

/**
 * Clean up tags from a file
 *
 * @author Yasuyuki Takeo
 *
 */
public class TagsCleanupListener extends DmscSrcParserExListener {

    /**
     * Constructor
     *
     * @param tokens
     */
    public TagsCleanupListener(TokenStream tokens) {

        rewriter = new TokenStreamRewriter(tokens);
    }

    /**
     * Get Root Element
     *
     * @param ctx
     */
    @Override
    public void exitRootelement(DmscSrcParser.RootelementContext ctx) {
        // Replace contents
        rewriter.replace(ctx.start, ctx.stop, "");

    }

    /**
     * Get Sync Start element
     *
     * @param ctx
     */
    @Override
    public void exitSyncelementStart(DmscSrcParser.SyncelementStartContext ctx) {
        // Replace contents
        rewriter.replace(ctx.start, ctx.stop, "");
    }

    /**
     * Get Sync End element
     *
     * @param ctx
     */
    @Override
    public void exitSyncelementEnd(DmscSrcParser.SyncelementEndContext ctx) {
        // Replace contents
        rewriter.replace(ctx.start, ctx.stop, "");
    }

    @Getter
    protected TokenStreamRewriter rewriter;

}
