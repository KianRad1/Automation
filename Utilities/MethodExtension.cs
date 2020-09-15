using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public static class MethodExtension
    {
        public static string ToNullablePersianDateTime(this DateTime? dt)
        {
            try
            {
                if (dt.HasValue)
                {
                    var DT = dt.Value;
                    PersianCalendar persianCalendar = new PersianCalendar();
                    string year = persianCalendar.GetYear(DT).ToString();
                    string month = persianCalendar.GetMonth(DT).ToString().PadLeft(2, '0');
                    string day = persianCalendar.GetDayOfMonth(DT).ToString().PadLeft(2, '0');
                    string hour = persianCalendar.GetHour(DT).ToString().PadLeft(2, '0');
                    string min = persianCalendar.GetMinute(DT).ToString().PadLeft(2, '0');
                    string sec = persianCalendar.GetSecond(DT).ToString().PadLeft(2, '0');
                    return String.Format("{0}/{1}/{2} {3}:{4}:{5}", year, month, day, hour, min, sec);
                }
                return string.Empty;
            }
            catch
            {

                throw;
            }
        }
        public static bool IsNull(this string s)
        {
            try
            {
                return string.IsNullOrEmpty(s);
            }
            catch
            {

                throw;
            }
        }
        public static string ToStringx(this object s)
        {
            try
            {
                if (s == null)
                    return string.Empty;

                return s.ToString().ToNormal();
            }
            catch
            {
                return string.Empty;
            }
        }
        public static string ToNormal(this string s)
        {
            try
            {

                return s.Replace("ي", "ی").Replace("ة", "ه").Replace("ۀ", "ه").Replace("ؤ", "و").Replace("ك", "ک");//.ToNormalNumber();
                //۱۲۳۴۵۶۷۸۹۰
            }
            catch
            {
                return s;
            }
        }
        public static string ToNullablePersianDate(this DateTime? dt)
        {
            try
            {
                if (dt.HasValue)
                {
                    var DT = dt.Value;
                    PersianCalendar persianCalendar = new PersianCalendar();
                    string year = persianCalendar.GetYear(DT).ToString();
                    string month = persianCalendar.GetMonth(DT).ToString().PadLeft(2, '0');
                    string day = persianCalendar.GetDayOfMonth(DT).ToString().PadLeft(2, '0');
                    return String.Format("{0}-{1}-{2}", year, month, day);
                }
                return string.Empty;
            }
            catch
            {

                throw;
            }


        }
        public static string ToNullablePersianDateforJson(this DateTime? dt)
        {
            try
            {
                if (dt.HasValue)
                {
                    var DT = dt.Value;
                    PersianCalendar persianCalendar = new PersianCalendar();
                    string year = persianCalendar.GetYear(DT).ToString();
                    string month = persianCalendar.GetMonth(DT).ToString().PadLeft(2, '0');
                    string day = persianCalendar.GetDayOfMonth(DT).ToString().PadLeft(2, '0');
                    return String.Format("{0}/{1}/{2}", year, month, day);
                }
                return string.Empty;
            }
            catch
            {

                throw;
            }
        }
        public static long ToLong(this object s)
        {
            try
            {
                return Convert.ToInt64(s);
            }
            catch
            {
                return 0;
            }
        }
        public static int ToInt(this object o)
        {
            try
            {
                return Convert.ToInt32(o);
            }
            catch (Exception)
            {
                return 0;
            }
        }
        public static bool ToBoolean(this object b)
        {
            try
            {
                return Convert.ToBoolean(b);
            }
            catch (Exception)
            {
                return false;
            }
        }
        public static bool IsNullOrEmpty<T>(this IEnumerable<T> source)
        {
            try
            {
                if (source == null || !source.Any())
                    return true;
                return false;
            }
            catch
            {

                throw;
            }
        }

        public static long? ToNullableLong(this object s)
        {
            try
            {
                return Convert.ToInt64(s);
            }
            catch
            {
                return null;
            }
        }
        public static Guid ToGuid(this object o)
        {
            try
            {
                return Guid.Parse(o.ToString());
            }
            catch
            {
                return Guid.Empty;
            }
        }

        public static Guid? ToNullableGuid(this object o)
        {
            try
            {
                return Guid.Parse(o.ToString());
            }
            catch
            {
                return null;
            }
        }

        public static string ToSHA256(this string s)
        {
            // Create a SHA256   
            using (SHA256 sha256Hash = SHA256.Create())
            {
                // ComputeHash - returns byte array  
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(s));

                // Convert byte array to a string   
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }

        }

    }
}
