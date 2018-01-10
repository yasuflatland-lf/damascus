package com.liferay.damascus.antlr.generator;

import com.liferay.damascus.antlr.common.UnderlineListener;
import com.liferay.damascus.antlr.template.DmscSrcLexer;
import com.liferay.damascus.antlr.template.DmscSrcParser;
import com.liferay.damascus.cli.common.CommonUtil;
import lombok.Builder;
import lombok.NonNull;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Map;

/**
 * Template Generator
 *
 * @author Yasuyuki Takeo
 */
@Builder
public class TemplateGenerator {

    /**
     * Template Generator
     *
     * @return processed string
     * @throws IOException
     */
    public String process() throws IOException {
        String contents = FileUtils.readFileToString(contentsFile, StandardCharsets.UTF_8);
        // Always get data from a file
        return getTemplateGenerateListener(contents, targetTemplateContext).getRewriter().getText();
    }

    /**
     * Get Source Context
     *
     * @return TemplateContext
     * @throws IOException
     */
    public TemplateContext getSourceContext() throws IOException {
        String contents = FileUtils.readFileToString(contentsFile, StandardCharsets.UTF_8);
        return getTemplateGenerateListener(contents, targetTemplateContext).getSourceContext();
    }

    /**
     * Get Template Generate Listener
     *
     * @param contents
     * @param targetTemplateContext
     * @return TemplateGenerateListener
     */
    private TemplateGenerateListener getTemplateGenerateListener(String contents, TemplateContext targetTemplateContext) {

        CharStream        input  = CharStreams.fromString(contents);
        DmscSrcLexer      lexer  = new DmscSrcLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        DmscSrcParser     parser = new DmscSrcParser(tokens);

        // Apply custom listener
        parser.removeErrorListeners(); // remove ConsoleErrorListener
        parser.addErrorListener(new UnderlineListener());

        ParseTree tree = parser.file(); // parse

        ParseTreeWalker walker = new ParseTreeWalker();

        TemplateGenerateListener templateGenerateListener = new TemplateGenerateListener(tokens, targetTemplateContext);
        walker.walk(templateGenerateListener, tree);

        templateGenerateListener.printErrorIfExist();

        return templateGenerateListener;
    }

    /**
     * Replace keywords in contents
     *
     * @param contentsFile
     * @param replacements
     * @return
     * @throws IOException
     */
    public String replaceKeywords(File contentsFile, Map<String, String> replacements)
        throws IOException {
        String contents = FileUtils.readFileToString(contentsFile, StandardCharsets.UTF_8);
        return CommonUtil.replaceKeywords(contents, replacements);
    }

    /**
     * REQUIRED
     * <p>
     * Contents file path.
     */
    @NonNull
    private File contentsFile;

    @Builder.Default
    private TemplateContext targetTemplateContext = null;
}
