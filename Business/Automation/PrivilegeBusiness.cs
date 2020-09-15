using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;
using Utilities;

namespace Business.Automation
{
    public class PrivilegeBusiness : AutomationBaseBusiness<Privilege>
    {
        
        public List<Privilege> GetAll_Cache()
        {
            var q = Business.FacadeAutomation.GetPrivilegeBusiness().GetAll();
            return this.Fetch(q);
        }

        private static List<Privilege> _privileges;
        private static DateTime ResetTimeCache = DateTime.Now;

        public PrivilegeBusiness()
        {
            if (_privileges == null || _privileges.Count == 0)
                _privileges = this.GetAllList();
        }
        public List<Privilege> Privileges
        {
            get
            {
                if (_privileges == null || _privileges.Count == 0 || DateTime.Now.Subtract(ResetTimeCache).Minutes > 10)
                {
                    _privileges = this.GetAllList();
                    ResetTimeCache = DateTime.Now;
                }
                return _privileges;
            }
            set
            {
                _privileges = value;
            }
        }

        public void ResetPrivileges()
        {
            _privileges = null;
            ResetTimeCache = DateTime.Now;
        }

        public Privilege GetByGid(string gid)
        {
            var q = this.GetAll(1);
            q.And(Privilege.Columns.gid, gid.ToGuid());

            return this.Fetch(q).FirstOrDefault();
        }

        public Privilege GetByGrefAndTitle(Guid? Gref, string Title)
        {
            var q = this.GetAll(1);
            q.And(Privilege.Columns.gref, Gref);
            q.And(Privilege.Columns.Title, Title);

            return this.Fetch(q).FirstOrDefault();
        }
    }
}
