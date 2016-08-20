package sora.core.ds;

class ResultTools 
{
	public static inline function getOrThrow<OkType, ErrType>(result:Result<OkType, ErrType>):OkType
	{
		return switch (result)
		{
			case Result.Ok(data):
				data;
				
			case Result.Err(error):
				throw error;
		}
	}
}