using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class UserBusiness : AutomationBaseBusiness<User>
    {
        public User GetByID(long userID)
        {
            var q = this.GetAll(1);
            q.And(User.Columns.ID, userID);

            return this.Fetch(q).FirstOrDefault();
        }
        public User GetByUserName(string username)
        {
            var q = this.GetAll(1);
            q.And(User.Columns.Username, username);

            return this.Fetch(q).FirstOrDefault();
        }

        public List<User> GetByRoleGroupID(long RoleGroupID)
        {
            var q = this.GetAll(300);
            q.And(User.Columns.RoleGroupID, RoleGroupID);

            return this.Fetch(q);
        }
    }

}
