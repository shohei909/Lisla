// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.parse.@string {
	public class UnquotedStringContext : global::haxe.lang.HxObject {
		
		public UnquotedStringContext(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public UnquotedStringContext(global::litll.core.parse.ParseContext top, global::litll.core.parse.array.ArrayContext parent, global::litll.core.parse.tag.UnsettledStringTag tag) {
			global::litll.core.parse.@string.UnquotedStringContext.__hx_ctor_litll_core_parse_string_UnquotedStringContext(this, top, parent, tag);
		}
		
		
		public static void __hx_ctor_litll_core_parse_string_UnquotedStringContext(global::litll.core.parse.@string.UnquotedStringContext __hx_this, global::litll.core.parse.ParseContext top, global::litll.core.parse.array.ArrayContext parent, global::litll.core.parse.tag.UnsettledStringTag tag) {
			__hx_this.parent = parent;
			__hx_this.top = top;
			__hx_this.@string = "";
			__hx_this.isSlash = false;
			__hx_this.tag = tag;
		}
		
		
		public global::litll.core.parse.ParseContext top;
		
		public global::litll.core.parse.array.ArrayContext parent;
		
		public string @string;
		
		public bool isSlash;
		
		public global::litll.core.parse.tag.UnsettledStringTag tag;
		
		public virtual void process(int codePoint) {
			unchecked {
				bool _g = this.isSlash;
				switch (((int) (codePoint) )) {
					case 9:
					case 10:
					case 13:
					case 32:
					case 34:
					case 39:
					case 91:
					case 93:
					{
						{
							bool __temp_switch1 = (_g);
							if (( __temp_switch1 == false )) {
								this.end();
								this.parent.process(codePoint);
							}
							else if (( __temp_switch1 == true )) {
								{
									global::litll.core.parse.@string.UnquotedStringContext __temp_dynop1 = this;
									__temp_dynop1.@string = global::haxe.lang.Runtime.concat(__temp_dynop1.@string, "/");
								}
								
								this.isSlash = false;
								this.process(codePoint);
							}
							
						}
						
						break;
					}
					
					
					case 47:
					{
						{
							bool __temp_switch2 = (_g);
							if (( __temp_switch2 == false )) {
								this.isSlash = true;
							}
							else if (( __temp_switch2 == true )) {
								this.isSlash = false;
								this.end();
								this.parent.state = global::litll.core.parse.array.ArrayState.Slash(2);
							}
							
						}
						
						break;
					}
					
					
					case 92:
					{
						{
							bool __temp_switch3 = (_g);
							if (( __temp_switch3 == false )) {
								global::litll.core.parse.ParseContext _this = this.top;
								global::litll.core.ds.SourceRange range = new global::litll.core.ds.SourceRange(this.top.sourceMap, this.tag.startPosition, this.top.position);
								if (( range == null )) {
									range = new global::litll.core.ds.SourceRange(_this.sourceMap, ( _this.position - 1 ), _this.position);
								}
								
								_this.errors.push(new global::litll.core.parse.ParseErrorEntry(_this.@string, global::litll.core.parse.ParseErrorKind.UnquotedEscapeSequence, range));
								if ( ! (_this.config.persevering) ) {
									throw global::haxe.lang.HaxeException.wrap(new global::litll.core.parse.ParseError(((global::litll.core.LitllArray<object>) (global::litll.core.LitllArray<object>.__hx_cast<object>(((global::litll.core.LitllArray) ((global::litll.core.ds._Maybe.Maybe_Impl_._new<object>(new global::haxe.lang.Null<object>(null, false))).@value) ))) ), _this.errors));
								}
								
							}
							else if (( __temp_switch3 == true )) {
								{
									global::litll.core.parse.@string.UnquotedStringContext __temp_dynop2 = this;
									__temp_dynop2.@string = global::haxe.lang.Runtime.concat(__temp_dynop2.@string, "/");
								}
								
								this.isSlash = false;
								this.process(codePoint);
							}
							
						}
						
						break;
					}
					
					
					default:
					{
						{
							bool __temp_switch4 = (_g);
							if (( __temp_switch4 == false )) {
								bool tmp = default(bool);
								switch (((int) (codePoint) )) {
									case 11:
									case 12:
									case 133:
									case 160:
									case 5760:
									case 8192:
									case 8193:
									case 8194:
									case 8195:
									case 8196:
									case 8197:
									case 8198:
									case 8199:
									case 8200:
									case 8201:
									case 8202:
									case 8232:
									case 8233:
									case 8239:
									case 8287:
									case 12288:
									{
										tmp = true;
										break;
									}
									
									
									default:
									{
										tmp = false;
										break;
									}
									
								}
								
								if (tmp) {
									this.end();
									this.parent.process(codePoint);
								}
								else {
									global::litll.core.parse.@string.UnquotedStringContext __temp_dynop3 = this;
									__temp_dynop3.@string = global::haxe.lang.Runtime.concat(__temp_dynop3.@string, ((string) (( (( ((int) (codePoint) ) <= 65535 )) ? (((string) (new string(((char) (((int) (codePoint) )) ), 1)) )) : (((string) (global::haxe.lang.Runtime.concat(new string(((char) (( (( ((int) (codePoint) ) >> 10 )) + 55232 )) ), 1), new string(((char) (( ( ((int) (codePoint) ) & 1023 ) | 56320 )) ), 1))) )) )) ));
								}
								
							}
							else if (( __temp_switch4 == true )) {
								{
									global::litll.core.parse.@string.UnquotedStringContext __temp_dynop4 = this;
									__temp_dynop4.@string = global::haxe.lang.Runtime.concat(__temp_dynop4.@string, "/");
								}
								
								this.isSlash = false;
								this.process(codePoint);
							}
							
						}
						
						break;
					}
					
				}
				
			}
		}
		
		
		public virtual void end() {
			if (this.isSlash) {
				{
					global::litll.core.parse.@string.UnquotedStringContext __temp_dynop1 = this;
					__temp_dynop1.@string = global::haxe.lang.Runtime.concat(__temp_dynop1.@string, "/");
				}
				
				this.isSlash = false;
			}
			
			this.parent.pushString(new global::litll.core.LitllString(this.@string, this.tag.settle(this.top.position)));
		}
		
		
		public override object __hx_setField(string field, int hash, object @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 5790298:
					{
						this.tag = ((global::litll.core.parse.tag.UnsettledStringTag) (@value) );
						return @value;
					}
					
					
					case 457663475:
					{
						this.isSlash = global::haxe.lang.Runtime.toBool(@value);
						return @value;
					}
					
					
					case 288368849:
					{
						this.@string = global::haxe.lang.Runtime.toString(@value);
						return @value;
					}
					
					
					case 1836975402:
					{
						this.parent = ((global::litll.core.parse.array.ArrayContext) (@value) );
						return @value;
					}
					
					
					case 5793429:
					{
						this.top = ((global::litll.core.parse.ParseContext) (@value) );
						return @value;
					}
					
					
					default:
					{
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 5047259:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "end", 5047259)) );
					}
					
					
					case 1900716655:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "process", 1900716655)) );
					}
					
					
					case 5790298:
					{
						return this.tag;
					}
					
					
					case 457663475:
					{
						return this.isSlash;
					}
					
					
					case 288368849:
					{
						return this.@string;
					}
					
					
					case 1836975402:
					{
						return this.parent;
					}
					
					
					case 5793429:
					{
						return this.top;
					}
					
					
					default:
					{
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override object __hx_invokeField(string field, int hash, global::Array dynargs) {
			unchecked {
				switch (hash) {
					case 5047259:
					{
						this.end();
						break;
					}
					
					
					case 1900716655:
					{
						this.process(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ));
						break;
					}
					
					
					default:
					{
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				return null;
			}
		}
		
		
		public override void __hx_getFields(global::Array<object> baseArr) {
			baseArr.push("tag");
			baseArr.push("isSlash");
			baseArr.push("string");
			baseArr.push("parent");
			baseArr.push("top");
			base.__hx_getFields(baseArr);
		}
		
		
	}
}


