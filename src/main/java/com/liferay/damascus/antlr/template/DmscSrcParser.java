// Generated from DmscSrcParser.g4 by ANTLR 4.7.1
package com.liferay.damascus.antlr.template;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class DmscSrcParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.7.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		SEA_WS=1, OPEN=2, SLASH_OPEN=3, TEXT=4, RootDecl=5, SyncDecl=6, CLOSE=7, 
		SLASH_CLOSE=8, SLASH=9, EQUALS=10, STRING=11, Name=12, S=13;
	public static final int
		RULE_file = 0, RULE_dmsctags = 1, RULE_syncelementStart = 2, RULE_syncelementEnd = 3, 
		RULE_rootelement = 4, RULE_attribute = 5, RULE_alldata = 6, RULE_savedata = 7, 
		RULE_endoffile = 8;
	public static final String[] ruleNames = {
		"file", "dmsctags", "syncelementStart", "syncelementEnd", "rootelement", 
		"attribute", "alldata", "savedata", "endoffile"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, "'<'", "'</'", null, null, null, "'>'", "'/>'", "'/'", "'='"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, "SEA_WS", "OPEN", "SLASH_OPEN", "TEXT", "RootDecl", "SyncDecl", 
		"CLOSE", "SLASH_CLOSE", "SLASH", "EQUALS", "STRING", "Name", "S"
	};
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "DmscSrcParser.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }


		protected boolean rootState = false;
		protected int rootCnt = 0;
		protected boolean betweenSyncTag = false;	
		protected int syncCnt = 0;

	public DmscSrcParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class FileContext extends ParserRuleContext {
		public List<AlldataContext> alldata() {
			return getRuleContexts(AlldataContext.class);
		}
		public AlldataContext alldata(int i) {
			return getRuleContext(AlldataContext.class,i);
		}
		public EndoffileContext endoffile() {
			return getRuleContext(EndoffileContext.class,0);
		}
		public List<DmsctagsContext> dmsctags() {
			return getRuleContexts(DmsctagsContext.class);
		}
		public DmsctagsContext dmsctags(int i) {
			return getRuleContext(DmsctagsContext.class,i);
		}
		public List<SyncelementStartContext> syncelementStart() {
			return getRuleContexts(SyncelementStartContext.class);
		}
		public SyncelementStartContext syncelementStart(int i) {
			return getRuleContext(SyncelementStartContext.class,i);
		}
		public List<SavedataContext> savedata() {
			return getRuleContexts(SavedataContext.class);
		}
		public SavedataContext savedata(int i) {
			return getRuleContext(SavedataContext.class,i);
		}
		public FileContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_file; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).enterFile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).exitFile(this);
		}
	}

	public final FileContext file() throws RecognitionException {
		FileContext _localctx = new FileContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_file);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(18);
			alldata();
			setState(27);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==OPEN || _la==SLASH_OPEN) {
				{
				setState(25);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,0,_ctx) ) {
				case 1:
					{
					setState(19);
					dmsctags();
					setState(20);
					alldata();
					}
					break;
				case 2:
					{
					setState(22);
					syncelementStart();
					setState(23);
					savedata();
					}
					break;
				}
				}
				setState(29);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(30);
			endoffile();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DmsctagsContext extends ParserRuleContext {
		public SyncelementEndContext syncelementEnd() {
			return getRuleContext(SyncelementEndContext.class,0);
		}
		public RootelementContext rootelement() {
			return getRuleContext(RootelementContext.class,0);
		}
		public DmsctagsContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_dmsctags; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).enterDmsctags(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).exitDmsctags(this);
		}
	}

	public final DmsctagsContext dmsctags() throws RecognitionException {
		DmsctagsContext _localctx = new DmsctagsContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_dmsctags);
		try {
			setState(34);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case SLASH_OPEN:
				enterOuterAlt(_localctx, 1);
				{
				setState(32);
				syncelementEnd();
				}
				break;
			case OPEN:
				enterOuterAlt(_localctx, 2);
				{
				setState(33);
				rootelement();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SyncelementStartContext extends ParserRuleContext {
		public TerminalNode OPEN() { return getToken(DmscSrcParser.OPEN, 0); }
		public TerminalNode SyncDecl() { return getToken(DmscSrcParser.SyncDecl, 0); }
		public TerminalNode CLOSE() { return getToken(DmscSrcParser.CLOSE, 0); }
		public List<AttributeContext> attribute() {
			return getRuleContexts(AttributeContext.class);
		}
		public AttributeContext attribute(int i) {
			return getRuleContext(AttributeContext.class,i);
		}
		public SyncelementStartContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_syncelementStart; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).enterSyncelementStart(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).exitSyncelementStart(this);
		}
	}

	public final SyncelementStartContext syncelementStart() throws RecognitionException {
		SyncelementStartContext _localctx = new SyncelementStartContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_syncelementStart);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(36);
			match(OPEN);
			setState(37);
			match(SyncDecl);
			setState(41);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==Name) {
				{
				{
				setState(38);
				attribute();
				}
				}
				setState(43);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(44);
			match(CLOSE);

					if(!rootState) {
						notifyErrorListeners("dmsc:root must be decleared first.");
					}
					syncCnt++;
					betweenSyncTag = true;
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SyncelementEndContext extends ParserRuleContext {
		public TerminalNode SLASH_OPEN() { return getToken(DmscSrcParser.SLASH_OPEN, 0); }
		public TerminalNode SyncDecl() { return getToken(DmscSrcParser.SyncDecl, 0); }
		public TerminalNode CLOSE() { return getToken(DmscSrcParser.CLOSE, 0); }
		public SyncelementEndContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_syncelementEnd; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).enterSyncelementEnd(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).exitSyncelementEnd(this);
		}
	}

	public final SyncelementEndContext syncelementEnd() throws RecognitionException {
		SyncelementEndContext _localctx = new SyncelementEndContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_syncelementEnd);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(47);
			match(SLASH_OPEN);
			setState(48);
			match(SyncDecl);
			setState(49);
			match(CLOSE);

					if(!betweenSyncTag) {
						notifyErrorListeners("dmsc:sync start tag is missing.");
					}
					betweenSyncTag = false;
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class RootelementContext extends ParserRuleContext {
		public TerminalNode OPEN() { return getToken(DmscSrcParser.OPEN, 0); }
		public TerminalNode RootDecl() { return getToken(DmscSrcParser.RootDecl, 0); }
		public TerminalNode SLASH_CLOSE() { return getToken(DmscSrcParser.SLASH_CLOSE, 0); }
		public List<AttributeContext> attribute() {
			return getRuleContexts(AttributeContext.class);
		}
		public AttributeContext attribute(int i) {
			return getRuleContext(AttributeContext.class,i);
		}
		public RootelementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_rootelement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).enterRootelement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).exitRootelement(this);
		}
	}

	public final RootelementContext rootelement() throws RecognitionException {
		RootelementContext _localctx = new RootelementContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_rootelement);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(52);
			match(OPEN);
			setState(53);
			match(RootDecl);
			setState(57);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==Name) {
				{
				{
				setState(54);
				attribute();
				}
				}
				setState(59);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(60);
			match(SLASH_CLOSE);

					if(1 <= rootCnt) {
						notifyErrorListeners("dmsc:root is only allowed once to use in a file");
					}
					rootCnt++;
					rootState = true;
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AttributeContext extends ParserRuleContext {
		public TerminalNode Name() { return getToken(DmscSrcParser.Name, 0); }
		public TerminalNode STRING() { return getToken(DmscSrcParser.STRING, 0); }
		public AttributeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_attribute; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).enterAttribute(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).exitAttribute(this);
		}
	}

	public final AttributeContext attribute() throws RecognitionException {
		AttributeContext _localctx = new AttributeContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_attribute);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(63);
			match(Name);
			setState(64);
			match(EQUALS);
			setState(65);
			match(STRING);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AlldataContext extends ParserRuleContext {
		public AlldataContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_alldata; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).enterAlldata(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).exitAlldata(this);
		}
	}

	public final AlldataContext alldata() throws RecognitionException {
		AlldataContext _localctx = new AlldataContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_alldata);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(70);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
			while ( _alt!=1 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1+1 ) {
					{
					{
					setState(67);
					matchWildcard();
					}
					} 
				}
				setState(72);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SavedataContext extends ParserRuleContext {
		public SavedataContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_savedata; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).enterSavedata(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).exitSavedata(this);
		}
	}

	public final SavedataContext savedata() throws RecognitionException {
		SavedataContext _localctx = new SavedataContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_savedata);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(76);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,6,_ctx);
			while ( _alt!=1 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1+1 ) {
					{
					{
					setState(73);
					matchWildcard();
					}
					} 
				}
				setState(78);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,6,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class EndoffileContext extends ParserRuleContext {
		public TerminalNode EOF() { return getToken(DmscSrcParser.EOF, 0); }
		public EndoffileContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_endoffile; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).enterEndoffile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof DmscSrcParserListener ) ((DmscSrcParserListener)listener).exitEndoffile(this);
		}
	}

	public final EndoffileContext endoffile() throws RecognitionException {
		EndoffileContext _localctx = new EndoffileContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_endoffile);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(79);
			match(EOF);

					if(0 < syncCnt && betweenSyncTag) {
						notifyErrorListeners("dmsc:sync is not closed.");
					}		
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\17U\4\2\t\2\4\3\t"+
		"\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\3\2\3\2\3\2"+
		"\3\2\3\2\3\2\3\2\7\2\34\n\2\f\2\16\2\37\13\2\3\2\3\2\3\3\3\3\5\3%\n\3"+
		"\3\4\3\4\3\4\7\4*\n\4\f\4\16\4-\13\4\3\4\3\4\3\4\3\5\3\5\3\5\3\5\3\5\3"+
		"\6\3\6\3\6\7\6:\n\6\f\6\16\6=\13\6\3\6\3\6\3\6\3\7\3\7\3\7\3\7\3\b\7\b"+
		"G\n\b\f\b\16\bJ\13\b\3\t\7\tM\n\t\f\t\16\tP\13\t\3\n\3\n\3\n\3\n\4HN\2"+
		"\13\2\4\6\b\n\f\16\20\22\2\2\2R\2\24\3\2\2\2\4$\3\2\2\2\6&\3\2\2\2\b\61"+
		"\3\2\2\2\n\66\3\2\2\2\fA\3\2\2\2\16H\3\2\2\2\20N\3\2\2\2\22Q\3\2\2\2\24"+
		"\35\5\16\b\2\25\26\5\4\3\2\26\27\5\16\b\2\27\34\3\2\2\2\30\31\5\6\4\2"+
		"\31\32\5\20\t\2\32\34\3\2\2\2\33\25\3\2\2\2\33\30\3\2\2\2\34\37\3\2\2"+
		"\2\35\33\3\2\2\2\35\36\3\2\2\2\36 \3\2\2\2\37\35\3\2\2\2 !\5\22\n\2!\3"+
		"\3\2\2\2\"%\5\b\5\2#%\5\n\6\2$\"\3\2\2\2$#\3\2\2\2%\5\3\2\2\2&\'\7\4\2"+
		"\2\'+\7\b\2\2(*\5\f\7\2)(\3\2\2\2*-\3\2\2\2+)\3\2\2\2+,\3\2\2\2,.\3\2"+
		"\2\2-+\3\2\2\2./\7\t\2\2/\60\b\4\1\2\60\7\3\2\2\2\61\62\7\5\2\2\62\63"+
		"\7\b\2\2\63\64\7\t\2\2\64\65\b\5\1\2\65\t\3\2\2\2\66\67\7\4\2\2\67;\7"+
		"\7\2\28:\5\f\7\298\3\2\2\2:=\3\2\2\2;9\3\2\2\2;<\3\2\2\2<>\3\2\2\2=;\3"+
		"\2\2\2>?\7\n\2\2?@\b\6\1\2@\13\3\2\2\2AB\7\16\2\2BC\7\f\2\2CD\7\r\2\2"+
		"D\r\3\2\2\2EG\13\2\2\2FE\3\2\2\2GJ\3\2\2\2HI\3\2\2\2HF\3\2\2\2I\17\3\2"+
		"\2\2JH\3\2\2\2KM\13\2\2\2LK\3\2\2\2MP\3\2\2\2NO\3\2\2\2NL\3\2\2\2O\21"+
		"\3\2\2\2PN\3\2\2\2QR\7\2\2\3RS\b\n\1\2S\23\3\2\2\2\t\33\35$+;HN";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}