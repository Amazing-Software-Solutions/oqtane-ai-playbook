using Microsoft.AspNetCore.Builder; 
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Oqtane.Infrastructure;
using TheCompany.Module.MyModule.Repository;
using TheCompany.Module.MyModule.Services;

namespace TheCompany.Module.MyModule.Startup
{
    public class ServerStartup : IServerStartup
    {
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            // not implemented
        }

        public void ConfigureMvc(IMvcBuilder mvcBuilder)
        {
            // not implemented
        }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddTransient<IMyModuleService, ServerMyModuleService>();
            services.AddDbContextFactory<MyModuleContext>(opt => { }, ServiceLifetime.Transient);
        }
    }
}
