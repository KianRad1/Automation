using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PetaPoco;

namespace Business
{
    public abstract class BaseBusiness<T>
       where T : class
    {
        public virtual string _ConnectionStringName { get; set; }

        public string _TableName = PetaPoco.TableInfo.FromPoco(typeof(T)).TableName;

        public Query GetAll(int? _topCount = null)
        {
            return new Query(this._TableName, _topCount);
        }

        public List<T> Fetch(Query q)
        {
            return new PetaPoco.Database(this._ConnectionStringName).Fetch<T>(q.q);
        }
        public List<T> Fetch<T>(string query, params object[] args)
        {
            return new PetaPoco.Database(this._ConnectionStringName).Fetch<T>(query, args);
        }
        public List<T> GetAllList()
        {
            return this.Fetch(GetAll());
        }
    }

    public abstract class AutomationBaseBusiness<T> : BaseBusiness<T>
        where T : class
    {
        public override string _ConnectionStringName { get { return "Automation"; } }
    }


}
