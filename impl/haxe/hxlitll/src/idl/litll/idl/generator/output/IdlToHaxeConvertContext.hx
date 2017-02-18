package litll.idl.generator.output;
import hxext.ds.Result;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.error.IdlReadError;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.group.TypeGroupPath;

interface IdlToHaxeConvertContext
{
    public var source(default, null):IdlSourceProvider;
	public var dataOutputConfig(default, null):DataOutputConfig;
    public function resolveGroups(targets:Array<TypeGroupPath>):Result<Array<DataTypeInfomation>, Array<IdlReadError>>;
}