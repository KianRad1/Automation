using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class VwUserPrivilegeRoleBusiness : AutomationBaseBusiness<VwUserPrivilegeRole>
    {
        private static List<VwUserPrivilegeRole> _userPrivilegeRoles;
        private static DateTime ResetTimeCache = DateTime.Now;
        public VwUserPrivilegeRoleBusiness()
        {
            if (_userPrivilegeRoles == null || _userPrivilegeRoles.Count == 0)
                _userPrivilegeRoles = this.GetAllList();
        }

        public List<VwUserPrivilegeRole> PrivilegeRoles
        {
            get
            {
                if (_userPrivilegeRoles == null || _userPrivilegeRoles.Count == 0 || DateTime.Now.Subtract(ResetTimeCache).Minutes > 10)
                {
                    _userPrivilegeRoles = this.GetAllList();
                    ResetTimeCache = DateTime.Now;
                }
                return _userPrivilegeRoles; 
            }
            set
            { 
                _userPrivilegeRoles = value;    
            }
        }

        public void ResetUserRolePrivileges()
        {
            _userPrivilegeRoles = null;
            ResetTimeCache = DateTime.Now;
        }

        public List<VwUserPrivilegeRole> GetByUserID(long UserID)
        {
            var q = this.GetAll();
            q.And(VwUserPrivilegeRole.Columns.UserID, UserID);
            q.And(VwUserPrivilegeRole.Columns.IsActive, true);

            return this.Fetch(q);
        }

        public VwUserPrivilegeRole GetByUserIDAndGid(long UserID, Guid Gid)
        {
            var q = this.GetAll(1);
            q.And(VwUserPrivilegeRole.Columns.UserID, UserID);
            q.And(VwUserPrivilegeRole.Columns.gid, Gid);
            //q.And(VwUserPrivilegeRole.Columns.IsActive, true);

            return this.Fetch(q).FirstOrDefault();
        }

    }
}
