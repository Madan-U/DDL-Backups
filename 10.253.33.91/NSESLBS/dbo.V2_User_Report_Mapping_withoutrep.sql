-- Object: PROCEDURE dbo.V2_User_Report_Mapping_withoutrep
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

create Proc V2_User_Report_Mapping_withoutrep    
@fldstat varchar(15)            
    
AS    
    
Select distinct      
      u.fldusername,    
      fldname = u.fldfirstname +  ' ' + u.fldmiddlename + ' ' + u.fldlastname,    
      u.fldstname,    
      a.fldstatus,     
      c.fldcategoryname     
    /*  r.fldreportname,     
      r.fldpath,     
      g.fldgrpname,     
      m.fldmenuname,    
      Branch_Cd = isnull(branch_cd,''),     
      Trader = isnull(trader,a.fldstatus + ' Login'),     
      Client_Name = isnull(long_name,a.fldstatus + ' Login')     */
From     
      TblAdmin a (nolock),    
      TblCategory c (nolock),    
      tblreports r (nolock),     
      tblreportgrp g (nolock),     
      tblmenuhead m (nolock),     
      tblcatmenu cm (nolock),       
      TblPradnyaUsers u  (nolock)    
      left outer join     
      (    
            Select     
                  Party_Code,     
                  Branch_Cd,    
                  Trader,    
                  Long_Name    
            From    
                  Client1 C1 (nolock),    
                  Client2 C2 (nolock)    
            Where    
                  C1.Cl_COde = C2.Cl_Code    
      ) cl    
      on    
      (cl.party_code = u.fldstname)    
Where     
      u.fldadminauto = a.fldauto_admin    
      And u.fldcategory = c.fldcategorycode     
      And r.fldreportgrp =g.fldreportgrp      
      and r.fldmenugrp = m.fldmenucode      
      and r.fldreportcode = cm.fldreportcode      
      and cm.fldcategorycode like '%,' + u.fldcategory + ',%'   
      and a.fldstatus=@fldstat  
Order By     
      u.fldusername
   --   g.fldgrpname,     
 --     m.fldmenuname,    
--      r.fldreportname

GO
