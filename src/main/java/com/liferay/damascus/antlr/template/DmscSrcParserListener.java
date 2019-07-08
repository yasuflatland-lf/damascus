// Generated from DmscSrcParser.g4 by ANTLR 4.7.2
package com.liferay.damascus.antlr.template;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link DmscSrcParser}.
 */
public interface DmscSrcParserListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link DmscSrcParser#file}.
	 * @param ctx the parse tree
	 */
	void enterFile(DmscSrcParser.FileContext ctx);
	/**
	 * Exit a parse tree produced by {@link DmscSrcParser#file}.
	 * @param ctx the parse tree
	 */
	void exitFile(DmscSrcParser.FileContext ctx);
	/**
	 * Enter a parse tree produced by {@link DmscSrcParser#dmsctags}.
	 * @param ctx the parse tree
	 */
	void enterDmsctags(DmscSrcParser.DmsctagsContext ctx);
	/**
	 * Exit a parse tree produced by {@link DmscSrcParser#dmsctags}.
	 * @param ctx the parse tree
	 */
	void exitDmsctags(DmscSrcParser.DmsctagsContext ctx);
	/**
	 * Enter a parse tree produced by {@link DmscSrcParser#syncelementStart}.
	 * @param ctx the parse tree
	 */
	void enterSyncelementStart(DmscSrcParser.SyncelementStartContext ctx);
	/**
	 * Exit a parse tree produced by {@link DmscSrcParser#syncelementStart}.
	 * @param ctx the parse tree
	 */
	void exitSyncelementStart(DmscSrcParser.SyncelementStartContext ctx);
	/**
	 * Enter a parse tree produced by {@link DmscSrcParser#syncelementEnd}.
	 * @param ctx the parse tree
	 */
	void enterSyncelementEnd(DmscSrcParser.SyncelementEndContext ctx);
	/**
	 * Exit a parse tree produced by {@link DmscSrcParser#syncelementEnd}.
	 * @param ctx the parse tree
	 */
	void exitSyncelementEnd(DmscSrcParser.SyncelementEndContext ctx);
	/**
	 * Enter a parse tree produced by {@link DmscSrcParser#rootelement}.
	 * @param ctx the parse tree
	 */
	void enterRootelement(DmscSrcParser.RootelementContext ctx);
	/**
	 * Exit a parse tree produced by {@link DmscSrcParser#rootelement}.
	 * @param ctx the parse tree
	 */
	void exitRootelement(DmscSrcParser.RootelementContext ctx);
	/**
	 * Enter a parse tree produced by {@link DmscSrcParser#attribute}.
	 * @param ctx the parse tree
	 */
	void enterAttribute(DmscSrcParser.AttributeContext ctx);
	/**
	 * Exit a parse tree produced by {@link DmscSrcParser#attribute}.
	 * @param ctx the parse tree
	 */
	void exitAttribute(DmscSrcParser.AttributeContext ctx);
	/**
	 * Enter a parse tree produced by {@link DmscSrcParser#alldata}.
	 * @param ctx the parse tree
	 */
	void enterAlldata(DmscSrcParser.AlldataContext ctx);
	/**
	 * Exit a parse tree produced by {@link DmscSrcParser#alldata}.
	 * @param ctx the parse tree
	 */
	void exitAlldata(DmscSrcParser.AlldataContext ctx);
	/**
	 * Enter a parse tree produced by {@link DmscSrcParser#savedata}.
	 * @param ctx the parse tree
	 */
	void enterSavedata(DmscSrcParser.SavedataContext ctx);
	/**
	 * Exit a parse tree produced by {@link DmscSrcParser#savedata}.
	 * @param ctx the parse tree
	 */
	void exitSavedata(DmscSrcParser.SavedataContext ctx);
	/**
	 * Enter a parse tree produced by {@link DmscSrcParser#endoffile}.
	 * @param ctx the parse tree
	 */
	void enterEndoffile(DmscSrcParser.EndoffileContext ctx);
	/**
	 * Exit a parse tree produced by {@link DmscSrcParser#endoffile}.
	 * @param ctx the parse tree
	 */
	void exitEndoffile(DmscSrcParser.EndoffileContext ctx);
}