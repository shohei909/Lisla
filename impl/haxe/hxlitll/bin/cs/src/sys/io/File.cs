// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace sys.io {
	public class File : global::haxe.lang.HxObject {
		
		public File(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public File() {
			global::sys.io.File.__hx_ctor_sys_io_File(this);
		}
		
		
		public static void __hx_ctor_sys_io_File(global::sys.io.File __hx_this) {
		}
		
		
		public static string getContent(string path) {
			global::sys.io.FileInput f = global::sys.io.File.read(path, new global::haxe.lang.Null<bool>(false, true));
			string ret = f.readAll(default(global::haxe.lang.Null<int>)).toString();
			f.close();
			return ret;
		}
		
		
		public static global::sys.io.FileInput read(string path, global::haxe.lang.Null<bool> binary) {
			bool __temp_binary4 = ( ( ! (binary.hasValue) ) ? (true) : ((binary).@value) );
			return new global::sys.io.FileInput(((global::System.IO.FileStream) (new global::System.IO.FileStream(((string) (path) ), ((global::System.IO.FileMode) (global::System.IO.FileMode.Open) ), ((global::System.IO.FileAccess) (global::System.IO.FileAccess.Read) ), ((global::System.IO.FileShare) (global::System.IO.FileShare.ReadWrite) ))) ));
		}
		
		
	}
}


