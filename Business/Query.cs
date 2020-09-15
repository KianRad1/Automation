using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PetaPoco;

namespace Business
{
    public enum CompareFilter
    {
        Like = 1,
        NotLike = 2,
        Null = 3,
        NotNull = 4,
        In = 5,
        NotIn = 6,
        Equal = 7,
        NotEqual = 8,
        GreaterThan = 9,
        GreaterThanOrEqual = 10,
        LessThan = 11,
        LessThanOrEqual = 12
    }
    public class Query
    {
        private bool IsNew;
        public Sql q;

        public string SQL
        {
            get
            {
                return q.SQL;
            }
        }

        public Query()
        {
            IsNew = true;
            q = new Sql();
        }

        public Query(string TableName, int? TopCount = null)
        {
            IsNew = true;

            if (TopCount.HasValue)
            {
                q = new Sql(string.Format(" SELECT TOP {0} * FROM {1} ", TopCount, TableName));
            }
            else
            {
                q = new Sql(string.Format(" SELECT * FROM {0} ", TableName));
            }

            q.Append(" WITH ( NOLOCK ) ");
        }

        public void And(string column, object value)
        {
            if (IsNew)
            {
                IsNew = false;

                q.Where(string.Format(" @0 = {0} ", column), value);
            }
            else
            {
                q.Append(string.Format(" AND @0 = {0} ", column), value);
            }
        }

        public void And(string Column, CompareFilter comp, object value)
        {
            string cc = "";

            if (comp == CompareFilter.Like)
                cc = " LIKE ";
            else if (comp == CompareFilter.NotLike)
                cc = " NOT LIKE ";
            else if (comp == CompareFilter.Equal)
                cc = " = ";
            else if (comp == CompareFilter.NotEqual)
                cc = " <> ";
            else if (comp == CompareFilter.In)
                cc = " IN ";
            else if (comp == CompareFilter.NotIn)
                cc = " NOT IN ";
            else if (comp == CompareFilter.Null)
                cc = " NULL ";
            else if (comp == CompareFilter.NotNull)
                cc = " NOT NULL ";
            else if (comp == CompareFilter.GreaterThan)
                cc = " > ";
            else if (comp == CompareFilter.GreaterThanOrEqual)
                cc = " >= ";
            else if (comp == CompareFilter.LessThan)
                cc = " < ";
            else if (comp == CompareFilter.LessThanOrEqual)
                cc = " <= ";

            if (IsNew)
            {
                IsNew = false;

                if (value != null)
                {
                    if (comp == CompareFilter.Like || comp == CompareFilter.NotLike)
                        q.Where(Column + " " + cc + " N'%" + value.ToString() + "%'", null);
                    else if (comp == CompareFilter.In || comp == CompareFilter.NotIn)
                        q.Where(Column + " " + cc + " (@0)", value);
                    else
                        q.Where(Column + " " + cc + " @0", value);

                }
                else
                {
                    q.Where(Column + " " + cc);
                }
            }
            else
            {
                q.Append(" AND ");

                if (value != null)
                {
                    if (comp == CompareFilter.Like || comp == CompareFilter.NotLike)
                        q.Append(Column + " " + cc + " N'%" + value.ToString() + "%'", null);
                    else if (comp == CompareFilter.In || comp == CompareFilter.NotIn)
                        q.Append(Column + " " + cc + " (@0)", value);
                    else
                        q.Append(Column + " " + cc + " @0", value);

                }
                else
                {
                    q.Append(Column + " " + cc);
                }
            }

        }

        public void OrderBy(string column, string OrderType = "ASC")
        {
            q.OrderBy(string.Format(" {0} {1} ", column, OrderType));
        }
    }
}
