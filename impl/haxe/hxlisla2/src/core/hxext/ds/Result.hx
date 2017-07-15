package hxext.ds;

enum Result<OkType, ErrorType>
{
	Ok(data:OkType);
	Error(data:ErrorType);
}
