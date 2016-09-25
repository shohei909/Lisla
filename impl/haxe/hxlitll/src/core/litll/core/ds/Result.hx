package litll.core.ds;

enum Result<OkType, ErrType>
{
	Ok(data:OkType);
	Err(data:ErrType);
}
