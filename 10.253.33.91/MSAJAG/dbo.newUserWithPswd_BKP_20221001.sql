-- Object: PROCEDURE dbo.newUserWithPswd_BKP_20221001
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure [dbo].[newUserWithPswd_BKP_20221001] 
(
@sbcd as varchar(10),
@pswd as varchar(10),
@flName as varchar(50),
@ctgry as int,
@admn as int
)    
as    
/*declare @sbcd as varchar(10),@pswd as varchar(10),@flName as varchar(50),@ctgry as int,@admn as int    
    
set @sbcd='aa'    
set @pswd='aa'    
set @flName='ab ac'    
set @ctgry=14    
set @admn=9*/    
    
declare @fldat as int,@p as int    
    
select @p=count(*) from tblPradnyausers with (nolock) where fldusername=@sbcd    
if(@p=0)     
begin    
    
 insert into tblPradnyausers     
 (Fldusername,Fldpassword,Fldfirstname,Fldlastname,Fldcategory,Fldadminauto,Fldstname,Pwd_Expiry_Date )    
 values     
 (@sbcd,@pswd,(substring(ltrim(rtrim(@flName)),0,charindex(' ',ltrim(rtrim(@flName))))),    
 substring(ltrim(rtrim(@flName)),charindex(' ',ltrim(rtrim(@flName))),25),    
 @ctgry,@admn,@sbcd,(getdate()+10))    
    
 Select @fldat=FLDAUTO from tblPradnyaUsers  where fldUsername = @sbcd    
    
 insert into tblUserControlMaster Values (@fldat,10,10,0,0,0,'F','127.0.0.1',20,'Y',0,0)    
    
 Insert into TBLUSERCONTROLMASTER     
 select a.FLDAUTO, b.FLDPWDEXPIRY, b.FLDMAXATTEMPT,0,0,0,b.FLDACCESSLVL,'',b.FLDTIMEOUT,b.FLDFIRSTLOGIN,b.FLDFORCELOGOUT,''     
 FROM TBLPRADNYAUSERS A left OUTER JOIN TBLUSERCONTROLMASTER X     
 ON (A.FLDAUTO = X.FLDUSERID) , TBLUSERCONTROLGLOBALS B     
 WHERE B.FLDCATEGORYID = A.FLDCATEGORY AND ISNULL(X.FLDUSERID,0) = 0    
    
end

GO
