package lisla.idl.generator.output;

import hxext.ds.OptionTools;
import lisla.idl.generator.data.EntityOutputConfig;
import lisla.idl.generator.data.LislaToEntityOutputConfig;
import lisla.idl.generator.output.HaxeGenerateConfigFactoryContext;
import lisla.idl.generator.source.IdlFileSourceReader;
import lisla.idl.generator.source.IdlSourceReader;
import lisla.idl.library.LibraryScope;
import lisla.idl.std.entity.idl.LibraryName;
import lisla.idl.std.entity.idl.group.TypeGroupFilter;
import lisla.idl.std.entity.util.version.Version;
import lisla.idl.std.tools.idl.group.TypeGroupFilterTools;

class HaxeGenerateConfigFactory 
{
    public function new () {}
    
    public function create(context:HaxeGenerateConfigFactoryContext):HaxeGenerateConfig
    { 
        return new HaxeGenerateConfig(
            getConfigFilePath(context),
            getLibraryScope(context),
            getTargetName(context),
            getTargetVersion(context),
            getEntityOutputConfig(context),
            getLislaToEntityOutputConfig(context),
            getSourceReader(context)
        );
    }
    
    
    private function getConfigFilePath(context:HaxeGenerateConfigFactoryContext):String
    {
        return context.configFilePath;
    }
    
    private function getLibraryScope(context:HaxeGenerateConfigFactoryContext):LibraryScope
    {
        return context.libraryScope;
    }
    
    private function getTargetName(context:HaxeGenerateConfigFactoryContext):LibraryName
    {
        return context.inputConfig.target.name;
    }
    
    
    private function getTargetVersion(context:HaxeGenerateConfigFactoryContext):Version
    {
        return context.inputConfig.target.data.version;
    }
    
    private function getEntityOutputConfig(context:HaxeGenerateConfigFactoryContext):EntityOutputConfig
    {
        var filters:Array<TypeGroupFilter> = [];
        var configs = context.requiredLibraryConfigs.concat([context.inputConfig]);
        for (inputConfig in configs)
        {
            filters.push(
                TypeGroupFilterTools.create(
                    inputConfig.target.name.data, 
                    inputConfig.target.data.haxePackage.toString() + ".entity"
                )
            );
            
            for (filter in inputConfig.entity.data.filter)
            {
                filters.push(filter.data);
            }
        }
        
        var noOutput = OptionTools.isSome(context.inputConfig.entity.data.noOutput);
        return new EntityOutputConfig(noOutput, filters);
    }
    
    private function getLislaToEntityOutputConfig(context:HaxeGenerateConfigFactoryContext):LislaToEntityOutputConfig
    {
        var filters = [];
        var configs = context.requiredLibraryConfigs.concat([context.inputConfig]);
        
        for (inputConfig in configs)
        {
            filters.push(
                TypeGroupFilterTools.create(
                    inputConfig.target.name.data, 
                    inputConfig.target.data.haxePackage.toString() + ".lisla2entity"
                )
            );
            
            for (filter in inputConfig.lislaToEntity.data.filter)
            {
                filters.push(filter.data);
            }
        }
        
        var noOutput = OptionTools.isSome(context.inputConfig.lislaToEntity.data.noOutput);
        return new LislaToEntityOutputConfig(noOutput, filters);
    }
    
    private function getSourceReader(context:HaxeGenerateConfigFactoryContext):IdlSourceReader
    {
        return new IdlFileSourceReader();
    }
}
