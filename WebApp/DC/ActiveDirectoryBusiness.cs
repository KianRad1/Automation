using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Utilities;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;

namespace WebApp.DC
{
    public class ActiveDirectoryBusiness
    {
        public static bool CheckUserFromDC
        {
            get
            {
                var checkUserFromDC = System.Configuration.ConfigurationManager.AppSettings.Get("CheckUserFromDC").ToStringx();
                if (checkUserFromDC.IsNull())
                    return false;
                return checkUserFromDC.ToBoolean();
            }
        }

        private string DomainName
        {
            get
            {
                var domainName = System.Configuration.ConfigurationManager.AppSettings.Get("DomainName").ToStringx();
                if (domainName.IsNull())
                    return "";
                return domainName;
            }
        }

        public bool IsAuthenticateUser(string Username, string Password)
        {
            using (var context = new PrincipalContext(ContextType.Domain, DomainName))
            {

                return context.ValidateCredentials(Username, Password);
            }
        }
        public List<string> GetDomainUsers()
        {
            var UserNameList = new List<string>();
            using (var context = new PrincipalContext(ContextType.Domain, DomainName, "administrator", "!nt3ch13979ol.$RFV"))
            {
                var prcontext = new PrincipalContext(ContextType.Domain, DomainName, "administrator", "!nt3ch13979ol.$RFV");
                UserPrincipal searchFilter = new UserPrincipal(prcontext) { Enabled = true };
                using (var searcher = new PrincipalSearcher(searchFilter))
                {
                    foreach (var result in searcher.FindAll())
                    {
                        UserNameList.Add(result.SamAccountName);
                    }
                }
            }
            return UserNameList;
        }
    }
}