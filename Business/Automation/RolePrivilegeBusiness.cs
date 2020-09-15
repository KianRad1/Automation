using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class RolePrivilegeBusiness : AutomationBaseBusiness<RolePrivilege>
    {
        public List<RolePrivilege> GetByRoleID(long RoleID)
        {
            var q = this.GetAll(300);
            q.And(RolePrivilege.Columns.RoleId, RoleID);
            var a =  this.Fetch(q).ToList();
            return a;
        }

    }
}
