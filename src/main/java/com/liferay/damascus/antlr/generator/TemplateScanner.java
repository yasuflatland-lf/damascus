package com.liferay.damascus.antlr.generator;

import com.liferay.damascus.antlr.common.UnderlineListener;
import com.liferay.damascus.antlr.template.DmscSrcLexer;
import com.liferay.damascus.antlr.template.DmscSrcParser;
import lombok.Builder;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

/**
 * Template Scanner
 * <p>
 * Scanning a target template and extract contents to swap in a source where surrounded
 * by sync tags.
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
@Builder
public class TemplateScanner {

    /**
     * Get Contents Map
     *
     * @return TemplateContext
     * @throws IOException
     */
    public TemplateContext getTargetTemplateContext() throws IOException {
        String contents = FileUtils.readFileToString(contentsFile, StandardCharsets.UTF_8);
        return getTemplateScanListener(contents).getTargetTemplateContext();
    }

    /**
     * Get Template Loader
     *
     * @param contents
     * @return TemplateScanListener
     */
    private TemplateScanListener getTemplateScanListener(String contents) {

        CharStream        input  = CharStreams.fromString(contents);
        DmscSrcLexer      lexer  = new DmscSrcLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        DmscSrcParser     parser = new DmscSrcParser(tokens);

        // Apply custom listener
        parser.removeErrorListeners(); // remove ConsoleErrorListener
        parser.addErrorListener(new UnderlineListener());

        ParseTree tree = parser.file(); // parse

        ParseTreeWalker      walker               = new ParseTreeWalker();
        TemplateScanListener templateScanListener = new TemplateScanListener();
        walker.walk(templateScanListener, tree);

        templateScanListener.printErrorIfExist();

        return templateScanListener;
    }

    @NonNull
    private File contentsFile;
}
