using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class RoleGroupBusiness : AutomationBaseBusiness<RoleGroup>
    {
        public RoleGroup GetByRoleGroupID(long RoleGroupID)
        {
            var q = this.GetAll(1);
            q.And(Role.Columns.ID, RoleGroupID);
            return this.Fetch(q).FirstOrDefault();
        }
    }
}
