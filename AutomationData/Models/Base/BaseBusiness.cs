using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutomationData.Models.Base
{
    public abstract class BaseBusiness<TTableEntity>
       where TTableEntity : class
    {
        PetaPoco.Internal.PocoData pd = PetaPoco.Internal.PocoData.ForType(typeof(TTableEntity));
        public abstract string connectionstringname { get; }
        public string TableName { get { return pd.TableInfo.TableName; } }

        public BaseBusiness()
        {
        }

        public void Insert(List<TTableEntity> Entities)
        {
            try
            {
                //var db = new PetaPoco.Database(connectionstringname);
                new PetaPoco.Database(connectionstringname).BulkInsert(Entities);
                //foreach (var item in Entities)
                //{
                //    db.Insert(item);
                //}
            }
            catch
            {
                throw;
            }
        }

        public virtual void Update(List<TTableEntity> Entities)
        {
            try
            {
                //var db = new PetaPoco.Database(connectionstringname);
                new PetaPoco.Database(connectionstringname).BulkUpdate(Entities);
                //foreach (var item in Entities)
                //{
                //    db.Update(item);
                //}
            }
            catch
            {
                throw;
            }
        }

        public virtual void Execute(string query, params object[] args)
        {
            new PetaPoco.Database(connectionstringname).Execute(query, args);
        }

        public virtual List<T> Execute<T>(string query, params object[] args)
        {
            return new PetaPoco.Database(connectionstringname).Fetch<T>(query, args);
        }

        public virtual List<TTableEntity> Fetch(AutomationData.Models.Base.Query query, int OneTimeCommandTimeOut = 0)
        {
            try
            {
                var db = new PetaPoco.Database(connectionstringname);

                if (OneTimeCommandTimeOut != 0)
                    db.OneTimeCommandTimeout = OneTimeCommandTimeOut;

                return db.Fetch<TTableEntity>(query.q);
            }
            catch
            {

                throw;
            }
        }

        public virtual List<T> Fetch<T>(AutomationData.Models.Base.Query query)
        {
            try
            {
                return new PetaPoco.Database(connectionstringname).Fetch<T>(query.q);
            }
            catch
            {

                throw;
            }
        }

        public virtual TTableEntity First(AutomationData.Models.Base.Query query)
        {
            try
            {
                return new PetaPoco.Database(connectionstringname).First<TTableEntity>(query.q);
            }
            catch
            {

                throw;
            }
        }

        public virtual List<TTableEntity> Fetch(string query, params object[] args)
        {
            try
            {
                return new PetaPoco.Database(connectionstringname).Fetch<TTableEntity>(query, args);
            }
            catch
            {

                throw;
            }
        }

        public List<T> Fetch<T>(string query, params object[] args)
        {
            return new PetaPoco.Database(connectionstringname).Fetch<T>(query, args);
        }

        public virtual void Insert(TTableEntity entity)
        {
            try
            {
                new PetaPoco.Database(connectionstringname).Insert(entity);
            }
            catch
            {

                throw;
            }
        }

        public virtual void Insert(TTableEntity entity, string userName)
        {
            try
            {
                new PetaPoco.Database(connectionstringname).Insert(entity);
            }
            catch
            {

                throw;
            }
        }

        public virtual void Update(TTableEntity entity)
        {
            try
            {
                new PetaPoco.Database(connectionstringname).Update(entity);
            }
            catch
            {

                throw;
            }
        }

        public virtual void Update(TTableEntity entity, string userName)
        {
            try
            {
                new PetaPoco.Database(connectionstringname).Update(entity);
            }
            catch
            {

                throw;
            }
        }

        public virtual void Delete(TTableEntity entity)
        {
            try
            {
                new PetaPoco.Database(connectionstringname).Delete(entity);
            }
            catch
            {

                throw;
            }
        }

        public void Delete(string ColumnName, List<object> values)
        {
            try
            {
                var query = "delete from " + TableName + " where " + ColumnName + " in (";
                for (int i = 0; i < values.Count; i++)
                {
                    query += "@" + i.ToString() + ",";
                }

                query = query.Remove(query.Length - 1) + ")";

                var args = new object[values.Count];
                for (int i = 0; i < values.Count; i++)
                {
                    args[i] = values[i].ToString();
                }

                this.Execute(query, args);
            }
            catch
            {

                throw;
            }

        }

        public AutomationData.Models.Base.Query GetAll(int? topcount = null)
        {
            return new AutomationData.Models.Base.Query(TableName, true, topcount);
        }

        public AutomationData.Models.Base.Query GetDistinct(params string[] args)
        {
            var query = new Query();
            var cols = "*";
            if (args.Count() != 0)
                cols = string.Join(",", args);
            query.q = new PetaPoco.Sql(string.Format("SELECT DISTINCT {0} FROM {1} WITH(NOLOCK)", cols, this.TableName));
            return query;

        }

        public Query GetCount()
        {
            var query = new Query();
            query.q = new PetaPoco.Sql(string.Format("SELECT COUNT(1) FROM {0} WITH(NOLOCK)", this.TableName));
            return query;
        }

        public Query GetMax(string columnName)
        {
            var query = new Query();
            query.q = new PetaPoco.Sql(string.Format("SELECT Max({0}) FROM {1} WITH(NOLOCK)", columnName, this.TableName));
            return query;
        }

        public Query GetSum(string column)
        {
            var query = new Query();
            query.q = new PetaPoco.Sql(string.Format("SELECT ISNULL(Sum({0}),0) FROM {1} WITH(NOLOCK)", column, this.TableName));
            return query;
        }

        public long Count(Query query)
        {
            return new PetaPoco.Database(connectionstringname).First<long>(query.q);
        }

        public T First<T>(Query query)
        {
            return new PetaPoco.Database(connectionstringname).First<T>(query.q);
        }

        public List<TTableEntity> GetAll_List()
        {
            return this.Fetch<TTableEntity>(this.GetAll());
        }
    }

    public abstract class B2SThirdpartyBaseBusiness<TTableEntity> : BaseBusiness<TTableEntity>
        where TTableEntity : class
    {
        public override string connectionstringname { get { return "B2SThirdparty"; } }
    }


}
