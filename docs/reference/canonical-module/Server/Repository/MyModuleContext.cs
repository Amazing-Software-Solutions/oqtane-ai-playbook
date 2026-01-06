using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;
using Oqtane.Modules;
using Oqtane.Repository;
using Oqtane.Infrastructure;
using Oqtane.Repository.Databases.Interfaces;

namespace TheCompany.Module.MyModule.Repository
{
    public class MyModuleContext : DBContextBase, ITransientService, IMultiDatabase
    {
        public virtual DbSet<Models.MyModule> MyModule { get; set; }

        public MyModuleContext(IDBContextDependencies DBContextDependencies) : base(DBContextDependencies)
        {
            // ContextBase handles multi-tenant database connections
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<Models.MyModule>().ToTable(ActiveDatabase.RewriteName("TheCompanyMyModule"));
        }
    }
}
