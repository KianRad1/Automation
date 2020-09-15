using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class LevelBusiness : AutomationBaseBusiness<Level>
    {
        public Level GetByID(long levelID)
        {
            var q = this.GetAll(1);
            q.And(Level.Columns.ID, levelID);

            return this.Fetch(q).FirstOrDefault();
        }
        public Level GetByTitle(string title)
        {
            var q = this.GetAll(1);
            q.And(Level.Columns.Title, title);

            return this.Fetch(q).FirstOrDefault();
        }
        private static List<Level> _leveldata;
        public static List<Level> LevelData
        {
            get
            {
                var Biz = Business.FacadeAutomation.GetLevelBusiness();
                if (_leveldata == null)
                    _leveldata = Biz.Fetch((Biz.GetAll()));

                return _leveldata;
            }
            set
            {
                _leveldata = value;
            }
        }
        public List<Level> GetAllLevel()
        {
            try
            {
                return LevelData;
            }
            catch
            {

                throw;
            }
        }
    }
}
