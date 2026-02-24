-- Object: PROCEDURE dbo.Angel_updateBlankPswd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create procedure Angel_updateBlankPswd
as

update tblPradnyausers 
set fldpassword=b.encruppswd from 
(select distinct * from intranet.ctcl.dbo.blank_pswd_2007) b 
where tblPradnyausers.fldstname=b.party_code

update tblUserControlMaster set FLDFIRSTLOGIN='Y',fldstatus=0,fldattemptcnt=0  
where FLDUSERID in
(
Select FLDAUTO from tblPradnyausers where fldstname
in
(select distinct party_code from intranet.ctcl.dbo.blank_pswd_2007) 
)

GO
