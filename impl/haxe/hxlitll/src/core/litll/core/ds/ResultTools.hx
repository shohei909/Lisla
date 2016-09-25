package litll.core.ds;

class ResultTools 
{
	public static inline function getOrThrow<OkType, ErrType>(result:Result<OkType, ErrType>, ?errorFunc:ErrType->Dynamic):OkType
	{
		return switch (result)
		{
			case Result.Ok(data):
				data;
				
			case Result.Err(error):
				throw if (errorFunc == null)
				{
					error;
				}
				else
				{
					errorFunc(error);
				}
		}
	}
	
	public static inline function map<OkType1, OkType2, ErrType>(result:Result<OkType1, ErrType>, func:OkType1->OkType2):Result<OkType2, ErrType>
	{
		return switch (result)
		{
			case Result.Ok(data):
				Result.Ok(func(data));
				
			case Result.Err(error):
				Result.Err(error);
		}
	}
}
