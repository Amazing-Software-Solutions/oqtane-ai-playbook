using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Oqtane.Models;

namespace TheCompany.Module.MyModule.Models
{
    [Table("TheCompanyMyModule")]
    public class MyModule : ModelBase
    {
        [Key]
        public int MyModuleId { get; set; }
        public int ModuleId { get; set; }
        public string Name { get; set; }
    }
}
