// This file is generated by hxlitll.
package litll.idl.std.data.cli.clidl;
class CommonConfig {
    public var description : haxe.ds.Option<litll.core.LitllString>;
    public var subcommand : litll.idl.std.data.cli.clidl.Subcommand;
    public var arg : litll.idl.std.data.cli.clidl.CommandArgument;
    public var input : litll.idl.std.data.cli.clidl.CommandInput;
    public function new(description:haxe.ds.Option<litll.core.LitllString>, subcommand:litll.idl.std.data.cli.clidl.Subcommand, arg:litll.idl.std.data.cli.clidl.CommandArgument, input:litll.idl.std.data.cli.clidl.CommandInput) {
        this.description = description;
        this.subcommand = subcommand;
        this.arg = arg;
        this.input = input;
    }
}