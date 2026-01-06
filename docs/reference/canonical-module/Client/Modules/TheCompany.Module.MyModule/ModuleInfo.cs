using Oqtane.Models;
using Oqtane.Modules;

namespace TheCompany.Module.MyModule
{
    public class ModuleInfo : IModule
    {
        public ModuleDefinition ModuleDefinition => new ModuleDefinition
        {
            Name = "MyModule",
            Description = "The Company MyModule module",
            Version = "1.0.0",
            ServerManagerType = "TheCompany.Module.MyModule.Manager.MyModuleManager, TheCompany.Module.MyModule.Server.Oqtane",
            ReleaseVersions = "1.0.0",
            Dependencies = "TheCompany.Module.MyModule.Shared.Oqtane",
            PackageName = "TheCompany.Module.MyModule" 
        };
    }
}
