-- Object: PROCEDURE dbo.editbranch
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.editbranch    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.editbranch    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.editbranch    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.editbranch    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.editbranch    Script Date: 12/27/00 8:58:49 PM ******/

/****** Object:  Stored Procedure dbo.editbranch    Script Date: 12/18/99 8:24:09 AM ******/
create procedure editbranch @fBranchCd varchar(3),@fshortname varchar(20),@flongname varchar(50),@faddress1 varchar(25),@faddress2 varchar(25),@fcity varchar(20),@fstate varchar(15),@fnation varchar(15),@fzip varchar(15),@fphone1 varchar(15),@fphone2 varchar(15),@ffax varchar(15),@femail varchar(50),@chkRemote bit,@chkSecurityNet bit,@ChkMoneyNet bit,@fExciseReg varchar(30),@fContactPerson varchar(30) As 
update branches 
set
branch_cd = @fbranchcd,
short_name= @fshortname,
long_name=@flongname,
address1=@faddress1,
address2=@faddress2,
state = @fstate,
nation=@fnation,
zip = @fzip,
Phone1=@fphone1,
Phone2=@fphone2,
Fax=@ffax,
Email=@femail,
Remote=@chkremote,
Security_Net=@chksecuritynet,
Money_Net=@chkmoneynet,
Excise_Reg=@fExciseReg,
Contact_Person =@fContactPerson
where branch_cd = @fbranchcd

GO
