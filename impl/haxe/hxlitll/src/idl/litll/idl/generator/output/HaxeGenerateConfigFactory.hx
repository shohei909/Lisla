package litll.idl.generator.output;

import litll.idl.generator.data.EntityOutputConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;
import litll.idl.generator.output.HaxeGenerateConfigFactoryContext;
import litll.idl.generator.source.IdlFileSourceReader;
import litll.idl.generator.source.IdlSourceReader;
import litll.idl.library.LibraryScope;
import litll.idl.std.data.idl.LibraryName;
import litll.idl.std.data.idl.group.TypeGroupFilter;
import litll.idl.std.data.util.version.Version;
import litll.idl.std.tools.idl.group.TypeGroupFilterTools;

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
            getLitllToEntityOutputConfig(context),
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
                    inputConfig.target.data.haxePackage.toString() + ".data" // TODO: entity
                )
            );
            
            for (filter in inputConfig.entity.data.filter)
            {
                filters.push(filter.data);
            }
        }
        
        return new EntityOutputConfig(filters);
    }
    
    private function getLitllToEntityOutputConfig(context:HaxeGenerateConfigFactoryContext):LitllToEntityOutputConfig
    {
        var filters = [];
        var configs = context.requiredLibraryConfigs.concat([context.inputConfig]);
        
        for (inputConfig in configs)
        {
            filters.push(
                TypeGroupFilterTools.create(
                    inputConfig.target.name.data, 
                    inputConfig.target.data.haxePackage.toString() + ".litll2entity"
                )
            );
            
            // TODO:
        }
        
        return new LitllToEntityOutputConfig(filters);
    }
    
    private function getSourceReader(context:HaxeGenerateConfigFactoryContext):IdlSourceReader
    {
        return new IdlFileSourceReader();
    }
}
