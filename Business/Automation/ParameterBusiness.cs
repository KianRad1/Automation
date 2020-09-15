using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class ParameterBusiness : AutomationBaseBusiness<Parameter>
    {
        public Parameter GetById(long pid)
        {
            var q = this.GetAll(1);
            q.And(Parameter.Columns.ID, pid);

            return this.Fetch(q).FirstOrDefault();
        }
    }
}
