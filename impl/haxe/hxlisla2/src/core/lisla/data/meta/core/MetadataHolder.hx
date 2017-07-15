package lisla.data.meta.core;
import lisla.data.meta.core.Metadata;

interface MetadataHolder 
{
    public var metadata(default, never):Metadata;
}
