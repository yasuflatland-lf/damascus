package com.liferay.damascus.antlr.generator;

import com.liferay.damascus.antlr.common.UnderlineListener;
import com.liferay.damascus.antlr.template.DmscSrcLexer;
import com.liferay.damascus.antlr.template.DmscSrcParser;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.IOException;

/**
 * Cleanup tags
 * <p>
 * Scanning a target template and extract contents to swap in a source where surrounded
 * by sync tags.
 *
 * @author Yasuyuki Takeo
 */
public class TagsCleanup {

    /**
     * Tags cleaned up text
     *
     * @return processed string
     * @throws IOException
     */
    static public String process(String contents) throws IOException {
        CharStream        input  = CharStreams.fromString(contents);
        DmscSrcLexer      lexer  = new DmscSrcLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        DmscSrcParser     parser = new DmscSrcParser(tokens);

        // Apply custom listener
        parser.removeErrorListeners(); // remove ConsoleErrorListener
        parser.addErrorListener(new UnderlineListener());

        ParseTree tree = parser.file(); // parse

        ParseTreeWalker     walker      = new ParseTreeWalker();
        TagsCleanupListener tagsCleanup = new TagsCleanupListener(tokens);
        walker.walk(tagsCleanup, tree);

        tagsCleanup.printErrorIfExist();

        // Always get data from a file
        return tagsCleanup.getRewriter().getText();
    }

}
