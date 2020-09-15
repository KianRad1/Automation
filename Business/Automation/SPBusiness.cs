using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Automation
{
    public class SPBusiness : AutomationBaseBusiness<dynamic>
    {
        public void SP_DeleteOldTypeDetails (int TypeID)
        {
            try
            {
                new PetaPoco.Database(this._ConnectionStringName).Execute(";EXEC SP_DeleteOldTypeDetails @@TypeID = @0", TypeID);
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public void SP_DeleteOldPrivilege(long RoleID)
        {
            try
            {
                new PetaPoco.Database(this._ConnectionStringName).Execute(";EXEC SP_DeleteOldPrivilege @@RoleID = @0", RoleID);
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        public void SP_DeleteOldRoles (long UserID)
        {
            try
            {
                new PetaPoco.Database(this._ConnectionStringName).Execute(";EXEC SP_DeleteOldRoles @@UserID = @0", UserID);
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        public List<PetaPocoDataLayer.Models.Other.RequestInfos> SP_GetUserRequesTypes (long UserLevelID, long UserRoleGroupID)
        {
            try
            {
                var result = this.Fetch<PetaPocoDataLayer.Models.Other.RequestInfos>(";EXEC dbo.SP_GetUserRequesTypes @@UserLevelID = @0 ,@@UserRoleGroupID = @1", UserLevelID, UserRoleGroupID);

                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}
