using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class UserRoleBusiness : AutomationBaseBusiness<UserRole>
    {
        public UserRole GetByUserID(long UserID)
        {
            var q = this.GetAll(1);
            q.And(UserRole.Columns.UserID, UserID);
            return this.Fetch(q).FirstOrDefault();
        }
    }
}
