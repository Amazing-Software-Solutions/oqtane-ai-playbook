using Microsoft.Extensions.DependencyInjection;
using System.Linq;
using Oqtane.Services;
using TheCompany.Module.MyModule.Services;

namespace TheCompany.Module.MyModule.Startup
{
    public class ClientStartup : IClientStartup
    {
        public void ConfigureServices(IServiceCollection services)
        {
            if (!services.Any(s => s.ServiceType == typeof(IMyModuleService)))
            {
                services.AddScoped<IMyModuleService, MyModuleService>();
            }
        }
    }
}
