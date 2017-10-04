package arraytree.idl.generator.output;

import hxext.ds.OptionTools;
import arraytree.idl.generator.data.EntityOutputConfig;
import arraytree.idl.generator.data.ArrayTreeToEntityOutputConfig;
import arraytree.idl.generator.output.HaxeGenerateConfigFactoryContext;
import arraytree.idl.generator.source.IdlFileSourceReader;
import arraytree.idl.generator.source.IdlSourceReader;
import arraytree.idl.library.LibraryScope;
import arraytree.idl.std.entity.idl.LibraryName;
import arraytree.idl.std.entity.idl.group.TypeGroupFilter;
import arraytree.idl.std.entity.util.version.Version;
import arraytree.idl.std.tools.idl.group.TypeGroupFilterTools;

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
            getArrayTreeToEntityOutputConfig(context),
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
        return context.generationConfig.target.name;
    }
    
    
    private function getTargetVersion(context:HaxeGenerateConfigFactoryContext):Version
    {
        return context.generationConfig.target.data.version;
    }
    
    private function getEntityOutputConfig(context:HaxeGenerateConfigFactoryContext):EntityOutputConfig
    {
        var filters:Array<TypeGroupFilter> = [];
        var configs = context.requiredLibraryConfigs.concat([context.generationConfig]);
        for (generationConfig in configs)
        {
            filters.push(
                TypeGroupFilterTools.create(
                    generationConfig.target.name.data, 
                    generationConfig.target.data.haxePackage.toString() + ".entity"
                )
            );
            
            for (filter in generationConfig.entity.data.filter)
            {
                filters.push(filter.data);
            }
        }
        
        var noOutput = OptionTools.isSome(context.generationConfig.entity.data.noOutput);
        return new EntityOutputConfig(noOutput, filters);
    }
    
    private function getArrayTreeToEntityOutputConfig(context:HaxeGenerateConfigFactoryContext):ArrayTreeToEntityOutputConfig
    {
        var filters = [];
        var configs = context.requiredLibraryConfigs.concat([context.generationConfig]);
        
        for (generationConfig in configs)
        {
            filters.push(
                TypeGroupFilterTools.create(
                    generationConfig.target.name.data, 
                    generationConfig.target.data.haxePackage.toString() + ".arraytree2entity"
                )
            );
            
            for (filter in generationConfig.arraytreeToEntity.data.filter)
            {
                filters.push(filter.data);
            }
        }
        
        var noOutput = OptionTools.isSome(context.generationConfig.arraytreeToEntity.data.noOutput);
        return new ArrayTreeToEntityOutputConfig(noOutput, filters);
    }
    
    private function getSourceReader(context:HaxeGenerateConfigFactoryContext):IdlSourceReader
    {
        return new IdlFileSourceReader();
    }
}
