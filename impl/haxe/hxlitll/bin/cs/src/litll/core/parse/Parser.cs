// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.parse {
	public class Parser : global::haxe.lang.HxObject {
		
		public Parser(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public Parser() {
			global::litll.core.parse.Parser.__hx_ctor_litll_core_parse_Parser(this);
		}
		
		
		public static void __hx_ctor_litll_core_parse_Parser(global::litll.core.parse.Parser __hx_this) {
		}
		
		
		public static global::litll.core.ds.Result run(string @string, global::litll.core.parse.ParserConfig config) {
			unchecked {
				if (( config == null )) {
					config = new global::litll.core.parse.ParserConfig();
				}
				
				global::litll.core.parse.ParseContext parser = new global::litll.core.parse.ParseContext(@string, config);
				try {
					{
						int _g_index = default(int);
						int _g_i = default(int);
						int _g_endIndex = default(int);
						_g_i = 0;
						_g_index = 0;
						_g_endIndex = @string.Length;
						while (( _g_index < _g_endIndex )) {
							_g_i = _g_index;
							int index = _g_index;
							string s = ((string) (@string) );
							int c = ( (((bool) (( ((uint) (index) ) < ((string) (s) ).Length )) )) ? (((int) (((string) (s) )[index]) )) : (-1) );
							_g_index += ( ( ! ((( ( 55296 <= c ) && ( c <= 56319 ) ))) ) ? (1) : (2) );
							parser.process(((int) (global::unifill._Utf16.Utf16_Impl_.codePointAt(((string) (@string) ), _g_i)) ));
						}
						
					}
					
					parser.position += 1;
					global::litll.core.LitllArray<object> data = null;
					while (true) {
						global::litll.core.parse.array.ArrayContext _this = parser.current;
						global::haxe.ds.Option _g = null;
						global::litll.core.parse.array.ArrayState _g1 = _this.state;
						switch (_g1.index) {
							case 0:
							{
								global::litll.core.parse.array.ArrayParent _g2 = _this.parent;
								switch (_g2.index) {
									case 0:
									{
										_g = global::haxe.ds.Option.Some(new global::litll.core.LitllArray<object>(_this.data, _this.tag.settle(_this.top.position)));
										break;
									}
									
									
									case 1:
									{
										{
											global::litll.core.parse.ParseContext _this1 = _this.top;
											global::litll.core.ds.SourceRange range = new global::litll.core.ds.SourceRange(_this.top.sourceMap, _this.tag.startPosition, ( _this.tag.startPosition + 1 ));
											if (( range == null )) {
												range = new global::litll.core.ds.SourceRange(_this1.sourceMap, ( _this1.position - 1 ), _this1.position);
											}
											
											_this1.errors.push(new global::litll.core.parse.ParseErrorEntry(_this1.@string, global::litll.core.parse.ParseErrorKind.UnclosedArray, range));
											if ( ! (_this1.config.persevering) ) {
												throw global::haxe.lang.HaxeException.wrap(new global::litll.core.parse.ParseError(((global::litll.core.LitllArray<object>) (global::litll.core.LitllArray<object>.__hx_cast<object>(((global::litll.core.LitllArray) ((global::litll.core.ds._Maybe.Maybe_Impl_._new<object>(new global::haxe.lang.Null<object>(null, false))).@value) ))) ), _this1.errors));
											}
											
										}
										
										_this.endArray(((global::litll.core.parse.array.ArrayContext) (_g2.@params[0]) ));
										_g = global::haxe.ds.Option.None;
										break;
									}
									
									
									case 2:
									{
										{
											global::litll.core.parse.ParseContext _this2 = _this.top;
											global::litll.core.ds.SourceRange range1 = new global::litll.core.ds.SourceRange(_this.top.sourceMap, _this.tag.startPosition, ( _this.tag.startPosition + 1 ));
											if (( range1 == null )) {
												range1 = new global::litll.core.ds.SourceRange(_this2.sourceMap, ( _this2.position - 1 ), _this2.position);
											}
											
											_this2.errors.push(new global::litll.core.parse.ParseErrorEntry(_this2.@string, global::litll.core.parse.ParseErrorKind.UnclosedArray, range1));
											if ( ! (_this2.config.persevering) ) {
												throw global::haxe.lang.HaxeException.wrap(new global::litll.core.parse.ParseError(((global::litll.core.LitllArray<object>) (global::litll.core.LitllArray<object>.__hx_cast<object>(((global::litll.core.LitllArray) ((global::litll.core.ds._Maybe.Maybe_Impl_._new<object>(new global::haxe.lang.Null<object>(null, false))).@value) ))) ), _this2.errors));
											}
											
										}
										
										_this.endInterporation(((global::litll.core.parse.@string.QuotedStringContext) (_g2.@params[0]) ), ((global::litll.core.parse.@string.QuotedStringArrayPair) (_g2.@params[1]) ));
										_g = global::haxe.ds.Option.None;
										break;
									}
									
									
								}
								
								break;
							}
							
							
							case 1:
							{
								{
									global::litll.core.parse.ParseContext _this3 = _this.top;
									global::litll.core.ds.SourceRange range2 = new global::litll.core.ds.SourceRange(_this.top.sourceMap, _this.tag.startPosition, _this.top.position);
									if (( range2 == null )) {
										range2 = new global::litll.core.ds.SourceRange(_this3.sourceMap, ( _this3.position - 1 ), _this3.position);
									}
									
									_this3.errors.push(new global::litll.core.parse.ParseErrorEntry(_this3.@string, global::litll.core.parse.ParseErrorKind.UnquotedEscapeSequence, range2));
									if ( ! (_this3.config.persevering) ) {
										throw global::haxe.lang.HaxeException.wrap(new global::litll.core.parse.ParseError(((global::litll.core.LitllArray<object>) (global::litll.core.LitllArray<object>.__hx_cast<object>(((global::litll.core.LitllArray) ((global::litll.core.ds._Maybe.Maybe_Impl_._new<object>(new global::haxe.lang.Null<object>(null, false))).@value) ))) ), _this3.errors));
									}
									
								}
								
								_this.state = global::litll.core.parse.array.ArrayState.Normal;
								_g = global::haxe.ds.Option.None;
								break;
							}
							
							
							case 2:
							{
								{
									global::litll.core.parse.@string.UnquotedStringContext stringContext = new global::litll.core.parse.@string.UnquotedStringContext(_this.top, _this, _this.popStringTag(_this.top.position));
									_this.state = global::litll.core.parse.array.ArrayState.UnquotedString(stringContext);
									stringContext.process(((int) (47) ));
								}
								
								_g = global::haxe.ds.Option.None;
								break;
							}
							
							
							case 3:
							{
								global::litll.core.parse.array.CommentContext context = ((global::litll.core.parse.array.CommentContext) (_g1.@params[0]) );
								switch (((int) (global::haxe.lang.Runtime.toInt(context.kind.index)) )) {
									case 0:
									{
										context.parent.state = global::litll.core.parse.array.ArrayState.Normal;
										break;
									}
									
									
									case 1:
									{
										context.parent.state = global::litll.core.parse.array.ArrayState.Normal;
										break;
									}
									
									
								}
								
								_g = global::haxe.ds.Option.None;
								break;
							}
							
							
							case 4:
							{
								int length = ((int) (global::haxe.lang.Runtime.toInt(_g1.@params[1])) );
								if (( length == 2 )) {
									_this.data.push(global::litll.core.Litll.Str(new global::litll.core.LitllString("", _this.popStringTag(( _this.top.position - 2 )).settle(_this.top.position))));
									_this.state = global::litll.core.parse.array.ArrayState.Normal;
								}
								else {
									_this.state = global::litll.core.parse.array.ArrayState.QuotedString(new global::litll.core.parse.@string.QuotedStringContext(_this.top, _this, global::haxe.lang.Runtime.toBool(_g1.@params[0]), length, _this.popStringTag(( _this.top.position - length ))));
								}
								
								_g = global::haxe.ds.Option.None;
								break;
							}
							
							
							case 5:
							{
								global::litll.core.parse.@string.QuotedStringContext context1 = ((global::litll.core.parse.@string.QuotedStringContext) (_g1.@params[0]) );
								{
									global::litll.core.parse.@string.QuotedStringState _g3 = context1.state;
									switch (_g3.index) {
										case 0:
										case 1:
										{
											context1.endUnclosedQuotedString(0);
											break;
										}
										
										
										case 2:
										{
											{
												context1.lastIndent = "";
												context1.currentLine.newLine = "\r";
												context1.currentString.push(context1.currentLine);
												context1.currentLine = new global::litll.core.parse.@string.QuotedStringLine(((int) (context1.top.position) ));
												context1.state = global::litll.core.parse.@string.QuotedStringState.Indent;
											}
											
											context1.endUnclosedQuotedString(0);
											break;
										}
										
										
										case 3:
										{
											int length1 = ((int) (global::haxe.lang.Runtime.toInt(_g3.@params[0])) );
											if (( length1 < context1.startQuoteCount )) {
												context1.endUnclosedQuotedString(length1);
											}
											else {
												context1.endClosedQuotedString(length1);
											}
											
											break;
										}
										
										
										case 4:
										{
											global::litll.core.parse.ParseContext _this4 = context1.top;
											global::litll.core.ds.SourceRange range3 = new global::litll.core.ds.SourceRange(context1.top.sourceMap, context1.tag.startPosition, context1.top.position);
											if (( range3 == null )) {
												range3 = new global::litll.core.ds.SourceRange(_this4.sourceMap, ( _this4.position - 1 ), _this4.position);
											}
											
											_this4.errors.push(new global::litll.core.parse.ParseErrorEntry(_this4.@string, global::litll.core.parse.ParseErrorKind.InvalidEscapeSequence, range3));
											if ( ! (_this4.config.persevering) ) {
												throw global::haxe.lang.HaxeException.wrap(new global::litll.core.parse.ParseError(((global::litll.core.LitllArray<object>) (global::litll.core.LitllArray<object>.__hx_cast<object>(((global::litll.core.LitllArray) ((global::litll.core.ds._Maybe.Maybe_Impl_._new<object>(new global::haxe.lang.Null<object>(null, false))).@value) ))) ), _this4.errors));
											}
											
											break;
										}
										
										
									}
									
								}
								
								_g = global::haxe.ds.Option.None;
								break;
							}
							
							
							case 6:
							{
								((global::litll.core.parse.@string.UnquotedStringContext) (_g1.@params[0]) ).end();
								_g = global::haxe.ds.Option.None;
								break;
							}
							
							
						}
						
						switch (_g.index) {
							case 0:
							{
								data = ((global::litll.core.LitllArray<object>) (global::litll.core.LitllArray<object>.__hx_cast<object>(((global::litll.core.LitllArray) (_g.@params[0]) ))) );
								goto label2;
							}
							
							
							case 1:
							{
								break;
							}
							
							
						}
						
					}
					
					label2: {};
					if (( parser.errors.length > 0 )) {
						return global::litll.core.ds.Result.Err(new global::litll.core.parse.ParseError(((global::litll.core.LitllArray<object>) (global::litll.core.LitllArray<object>.__hx_cast<object>(((global::litll.core.LitllArray) ((global::litll.core.ds._Maybe.Maybe_Impl_._new<object>(new global::haxe.lang.Null<object>(data, true))).@value) ))) ), parser.errors));
					}
					else {
						return global::litll.core.ds.Result.Ok(data);
					}
					
				}
				catch (global::System.Exception __temp_catchallException1){
					global::haxe.lang.Exceptions.exception = __temp_catchallException1;
					object __temp_catchall2 = __temp_catchallException1;
					if (( __temp_catchall2 is global::haxe.lang.HaxeException )) {
						__temp_catchall2 = ((global::haxe.lang.HaxeException) (__temp_catchallException1) ).obj;
					}
					
					if (( __temp_catchall2 is global::litll.core.parse.ParseError )) {
						global::litll.core.parse.ParseError error = ((global::litll.core.parse.ParseError) (__temp_catchall2) );
						{
							return global::litll.core.ds.Result.Err(error);
						}
						
					}
					else {
						throw;
					}
					
				}
				
				
				return null;
			}
		}
		
		
	}
}


