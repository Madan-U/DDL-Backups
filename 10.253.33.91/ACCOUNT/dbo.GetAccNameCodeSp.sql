-- Object: PROCEDURE dbo.GetAccNameCodeSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GetAccNameCodeSp    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.GetAccNameCodeSp    Script Date: 11/28/2001 12:23:43 PM ******/

/****** Object:  Stored Procedure dbo.GetAccNameCodeSp    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.GetAccNameCodeSp    Script Date: 09/21/2001 2:39:21 AM ******/

/****** Object:  Stored Procedure dbo.GetAccNameCodeSp    Script Date: 09/13/2001 6:54:12 AM ******/

/****** Object:  Stored Procedure dbo.GetAccNameCodeSp    Script Date: 08/13/2001 6:16:40 AM ******/


/****** Object:  Stored Procedure dbo.GetAccNameCodeSp    Script Date: 7/1/01 2:19:42 PM ******/

/****** Object:  Stored Procedure dbo.GetAccNameCodeSp    Script Date: 06/28/2001 5:44:43 PM ******/





/****** Object:  Stored Procedure dbo.GetAccNameCodeSp    Script Date: 20-Mar-01 11:43:33 PM ******/

/*This procedure is used to get the cltcode and account name from acmast */
CREATE proc GetAccNameCodeSp 
@accat as char(10),
@Cltcode as varchar(10),
@flag as tinyint
as
if @flag = 1 
begin
	select distinct l.cltcode,l.acname from acmast a,ledger l 
	where accat= @accat 
	and l.cltcode = a.cltcode
	and l.vtyp <> 18
	order by l.acname ,l..cltcode 
end 
if @flag =2
begin
	select distinct l.cltcode,l.acname from acmast  a,ledger l
	where l.cltcode = a.cltcode
	and accat= @accat 
	and l.cltcode = @Cltcode
end 

if @flag =3
begin
	select distinct l.cltcode,l.acname from acmast a,ledger l 
	where accat= @accat 
	and l.cltcode = a.cltcode
	order by l.acname ,l..cltcode 
end

GO
