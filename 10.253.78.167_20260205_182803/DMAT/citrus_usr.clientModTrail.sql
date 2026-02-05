-- Object: PROCEDURE citrus_usr.clientModTrail
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

-- exec clientModTrail  ' ',' ','MAY 5 2008','may 27 2009 23:59:00'

CREATE proc [citrus_usr].[clientModTrail]
@frmAccount varchar(20),
@toAccount varchar(20),
@frmdate   DATETIME,
@toDate   DATETIME

as

SET @TODATE = DATEADD(hh,23,@TODATE)

IF @frmAccount = ''                                    
 BEGIN                                    
 SET @frmAccount = '0'                                    
 SET @toAccount = '99999999999999999'                                    
 END                                    
 IF @toAccount = ''                                    
 BEGIN                                
 SET @toAccount = @frmAccount                                    
 END     


select 
id,
crn_no,
Remarks,
dpam_sba_name,
dpam_sba_no
from client_modification_trail,dp_acct_mstr
where crn_no = dpam_crn_no
and lst_upd_dt   BETWEEN  @frmdate AND @toDate
--and dpam_sba_no between @frmAccount and @toAccount
--and dpam_sba_no between CASE WHEN @frmAccount = '' THEN  '' ELSE @frmAccount END and  CASE WHEN @toAccount= '' THEN  '' ELSE @toAccount END

-- case when wfrh.reqh_assign_to ='' then @pa_login_name else wfrh.reqh_assign_to end= @pa_login_name

GO
