using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class RoleBusiness : AutomationBaseBusiness<Role>
    {
        public Role GetByRoleID(int RoleID)
        {
            var q = this.GetAll(1);
            q.And(Role.Columns.ID, RoleID);
            return this.Fetch(q).FirstOrDefault();
        }
    }
}
