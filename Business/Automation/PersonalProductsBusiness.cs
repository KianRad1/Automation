using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class PersonalProductsBusiness : AutomationBaseBusiness<PersonalProduct>
    {
        public PersonalProduct GetByID(long userproductid)
        {
            var q = this.GetAll(1);
            q.And(PersonalProduct.Columns.ID, userproductid);

            return this.Fetch(q).FirstOrDefault();
        }
    }
}
