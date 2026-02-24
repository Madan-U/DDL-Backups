-- Object: PROCEDURE dbo.Angel_updCliPswd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure [dbo].[Angel_updCliPswd]
(
    @username as varchar(15),
    @pswd as varchar(15)
)
as
begin
    declare @fld1 as int,@fldadm as int
    select @fld1=fldauto,@fldadm=fldadminauto 
    from tblPradnyausers (nolock) 
    where fldusername=@username

    update tblPradnyausers set fldpassword =@pswd 
    where fldauto =@fld1 and fldadminauto = fldadminauto

    INSERT INTO TBLUSERCONTROLMASTER_JRNL 
    SELECT FLDAUTO,FLDUSERID,FLDPWDEXPIRY,FLDMAXATTEMPT,FLDATTEMPTCNT,FLDSTATUS,FLDLOGINFLAG,FLDACCESSLVL,FLDIPADD,FLDTIMEOUT,FLDFIRSTLOGIN,
    FLDFORCELOGOUT,'10',GETDATE(),FLD_MAC_ID FROM TBLUSERCONTROLMASTER 
    WHERE FLDUSERID = @fld1
    
    if not exists (Select emp_no from intranet.risk.dbo.emp_info a(nolock)
    where emp_no=@username and Status<>'A')
    begin
        update TBLUSERCONTROLMASTER set FLDPWDEXPIRY = 30, FLDMAXATTEMPT = 5, FLDSTATUS = 0,
        --FLDATTEMPTCNT = (CASE WHEN (0 = 1 AND 0 = 0) THEN 0 ELSE FLDATTEMPTCNT END),
        FLDATTEMPTCNT = 0,
        FLDFIRSTLOGIN = 'Y', FLDFORCELOGOUT = 0 WHERE FLDUSERID = @fld1
    end
end

GO
