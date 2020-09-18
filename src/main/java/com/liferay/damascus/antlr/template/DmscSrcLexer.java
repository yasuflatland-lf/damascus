// Generated from DmscSrcLexer.g4 by ANTLR 4.8
package com.liferay.damascus.antlr.template;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class DmscSrcLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.8", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		SEA_WS=1, OPEN=2, SLASH_OPEN=3, TEXT=4, RootDecl=5, SyncDecl=6, CLOSE=7, 
		SLASH_CLOSE=8, SLASH=9, EQUALS=10, STRING=11, Name=12, S=13;
	public static final int
		CHECK_DAMASCUS_TAG=1, INSIDE_TAG=2;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE", "CHECK_DAMASCUS_TAG", "INSIDE_TAG"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"SEA_WS", "OPEN", "SLASH_OPEN", "TEXT", "RootDecl", "SyncDecl", "OTHER_TEXT", 
			"CLOSE", "SLASH_CLOSE", "SLASH", "EQUALS", "STRING", "Name", "S", "HEXDIGIT", 
			"DIGIT", "NameChar", "NameStartChar"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, null, "'<'", "'</'", null, null, null, "'>'", "'/>'", "'/'", "'='"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "SEA_WS", "OPEN", "SLASH_OPEN", "TEXT", "RootDecl", "SyncDecl", 
			"CLOSE", "SLASH_CLOSE", "SLASH", "EQUALS", "STRING", "Name", "S"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
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


	public DmscSrcLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "DmscSrcLexer.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\17\u00a0\b\1\b\1"+
		"\b\1\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4"+
		"\n\t\n\4\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t"+
		"\21\4\22\t\22\4\23\t\23\3\2\3\2\5\2,\n\2\3\2\6\2/\n\2\r\2\16\2\60\3\2"+
		"\3\2\3\3\3\3\3\3\3\3\3\4\3\4\3\4\3\4\3\4\3\5\6\5?\n\5\r\5\16\5@\3\5\3"+
		"\5\5\5E\n\5\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\5\6R\n\6\3\6\3"+
		"\6\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\5\7a\n\7\3\7\3\7\3\b\3"+
		"\b\3\b\3\b\3\b\3\t\3\t\3\t\3\t\3\n\3\n\3\n\3\n\3\n\3\13\3\13\3\f\3\f\3"+
		"\r\3\r\7\ry\n\r\f\r\16\r|\13\r\3\r\3\r\3\r\7\r\u0081\n\r\f\r\16\r\u0084"+
		"\13\r\3\r\5\r\u0087\n\r\3\16\3\16\7\16\u008b\n\16\f\16\16\16\u008e\13"+
		"\16\3\17\3\17\3\17\3\17\3\20\3\20\3\21\3\21\3\22\3\22\3\22\3\22\5\22\u009c"+
		"\n\22\3\23\5\23\u009f\n\23\2\2\24\5\3\7\4\t\5\13\6\r\7\17\b\21\2\23\t"+
		"\25\n\27\13\31\f\33\r\35\16\37\17!\2#\2%\2\'\2\5\2\3\4\f\4\2\13\13\"\""+
		"\3\2>>\4\2$$>>\4\2))>>\5\2\13\f\17\17\"\"\5\2\62;CHch\3\2\62;\4\2/\60"+
		"aa\5\2\u00b9\u00b9\u0302\u0371\u2041\u2042\n\2<<C\\c|\u2072\u2191\u2c02"+
		"\u2ff1\u3003\ud801\uf902\ufdd1\ufdf2\uffff\2\u00a7\2\5\3\2\2\2\2\7\3\2"+
		"\2\2\2\t\3\2\2\2\2\13\3\2\2\2\3\r\3\2\2\2\3\17\3\2\2\2\3\21\3\2\2\2\4"+
		"\23\3\2\2\2\4\25\3\2\2\2\4\27\3\2\2\2\4\31\3\2\2\2\4\33\3\2\2\2\4\35\3"+
		"\2\2\2\4\37\3\2\2\2\5.\3\2\2\2\7\64\3\2\2\2\t8\3\2\2\2\13D\3\2\2\2\rF"+
		"\3\2\2\2\17U\3\2\2\2\21d\3\2\2\2\23i\3\2\2\2\25m\3\2\2\2\27r\3\2\2\2\31"+
		"t\3\2\2\2\33\u0086\3\2\2\2\35\u0088\3\2\2\2\37\u008f\3\2\2\2!\u0093\3"+
		"\2\2\2#\u0095\3\2\2\2%\u009b\3\2\2\2\'\u009e\3\2\2\2)/\t\2\2\2*,\7\17"+
		"\2\2+*\3\2\2\2+,\3\2\2\2,-\3\2\2\2-/\7\f\2\2.)\3\2\2\2.+\3\2\2\2/\60\3"+
		"\2\2\2\60.\3\2\2\2\60\61\3\2\2\2\61\62\3\2\2\2\62\63\b\2\2\2\63\6\3\2"+
		"\2\2\64\65\7>\2\2\65\66\3\2\2\2\66\67\b\3\3\2\67\b\3\2\2\289\7>\2\29:"+
		"\7\61\2\2:;\3\2\2\2;<\b\4\3\2<\n\3\2\2\2=?\n\3\2\2>=\3\2\2\2?@\3\2\2\2"+
		"@>\3\2\2\2@A\3\2\2\2AE\3\2\2\2BC\7>\2\2CE\7\'\2\2D>\3\2\2\2DB\3\2\2\2"+
		"E\f\3\2\2\2FG\7f\2\2GH\7o\2\2HI\7u\2\2IJ\7e\2\2JK\7<\2\2KL\7t\2\2LM\7"+
		"q\2\2MN\7q\2\2NO\7v\2\2OQ\3\2\2\2PR\5\37\17\2QP\3\2\2\2QR\3\2\2\2RS\3"+
		"\2\2\2ST\b\6\4\2T\16\3\2\2\2UV\7f\2\2VW\7o\2\2WX\7u\2\2XY\7e\2\2YZ\7<"+
		"\2\2Z[\7u\2\2[\\\7{\2\2\\]\7p\2\2]^\7e\2\2^`\3\2\2\2_a\5\37\17\2`_\3\2"+
		"\2\2`a\3\2\2\2ab\3\2\2\2bc\b\7\4\2c\20\3\2\2\2de\13\2\2\2ef\3\2\2\2fg"+
		"\b\b\5\2gh\b\b\6\2h\22\3\2\2\2ij\7@\2\2jk\3\2\2\2kl\b\t\6\2l\24\3\2\2"+
		"\2mn\7\61\2\2no\7@\2\2op\3\2\2\2pq\b\n\6\2q\26\3\2\2\2rs\7\61\2\2s\30"+
		"\3\2\2\2tu\7?\2\2u\32\3\2\2\2vz\7$\2\2wy\n\4\2\2xw\3\2\2\2y|\3\2\2\2z"+
		"x\3\2\2\2z{\3\2\2\2{}\3\2\2\2|z\3\2\2\2}\u0087\7$\2\2~\u0082\7)\2\2\177"+
		"\u0081\n\5\2\2\u0080\177\3\2\2\2\u0081\u0084\3\2\2\2\u0082\u0080\3\2\2"+
		"\2\u0082\u0083\3\2\2\2\u0083\u0085\3\2\2\2\u0084\u0082\3\2\2\2\u0085\u0087"+
		"\7)\2\2\u0086v\3\2\2\2\u0086~\3\2\2\2\u0087\34\3\2\2\2\u0088\u008c\5\'"+
		"\23\2\u0089\u008b\5%\22\2\u008a\u0089\3\2\2\2\u008b\u008e\3\2\2\2\u008c"+
		"\u008a\3\2\2\2\u008c\u008d\3\2\2\2\u008d\36\3\2\2\2\u008e\u008c\3\2\2"+
		"\2\u008f\u0090\t\6\2\2\u0090\u0091\3\2\2\2\u0091\u0092\b\17\2\2\u0092"+
		" \3\2\2\2\u0093\u0094\t\7\2\2\u0094\"\3\2\2\2\u0095\u0096\t\b\2\2\u0096"+
		"$\3\2\2\2\u0097\u009c\5\'\23\2\u0098\u009c\t\t\2\2\u0099\u009c\5#\21\2"+
		"\u009a\u009c\t\n\2\2\u009b\u0097\3\2\2\2\u009b\u0098\3\2\2\2\u009b\u0099"+
		"\3\2\2\2\u009b\u009a\3\2\2\2\u009c&\3\2\2\2\u009d\u009f\t\13\2\2\u009e"+
		"\u009d\3\2\2\2\u009f(\3\2\2\2\22\2\3\4+.\60@DQ`z\u0082\u0086\u008c\u009b"+
		"\u009e\7\2\3\2\7\3\2\7\4\2\5\2\2\4\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}