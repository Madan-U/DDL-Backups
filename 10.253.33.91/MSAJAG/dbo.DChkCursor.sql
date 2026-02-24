-- Object: PROCEDURE dbo.DChkCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DChkCursor    Script Date: 3/21/01 12:50:06 PM ******/
/****** Object:  Stored Procedure dbo.DChkCursor    Script Date: 20-Mar-01 11:38:49 PM ******/
/****** Object:  Stored Procedure dbo.DChkCursor    Script Date: 2/5/01 12:06:11 PM ******/
/****** Object:  Stored Procedure dbo.DChkCursor    Script Date: 12/27/00 8:58:49 PM ******/
/****** Object:  Stored Procedure dbo.DChkCursor    Script Date: 11/30/2000 4:13:36 PM ******/
CREATE Proc DChkCursor ( @Sett_no Varchar(7),@Sett_Type Varchar(2)) as 
Declare @@Party Varchar(10),
 @@Scrip_Cd Varchar(12),
 @@Series Varchar(2),
 @@DChk Cursor,
 @@DChk1 Cursor
 
Set @@DChk = Cursor for 
 select distinct party_code , scrip_cd , series
 from certinfo where SETT_NO = '0' and sett_type =  'No'
 Order by Party_Code,Scrip_cd,Series
Open @@DChk
fetch next from @@DChk into @@Party,@@Scrip_Cd,@@Series
while @@fetch_Status = 0
begin
 Set @@DChk1 = Cursor for 
  select scrip_cd , series ,party_code 
         from deliveryclt where sett_no = @Sett_no
         and sett_type = @Sett_Type
         and party_code = @@Party
         and scrip_cd = @@Scrip_cd
         and series = @@Series
 open @@DChk1
 fetch next from @@DChk1 into @@Party,@@Scrip_Cd,@@Series
 if @@fetch_Status = 0
 begin  
  update certinfo set DELIVERED = 'D',sett_no = @Sett_no,sett_type = @Sett_Type
  where party_code = @@Party
         and scrip_cd = @@Scrip_cd
         and series = @@Series
  and SETT_NO = '0'  
  and sett_type = 'No'
 end 
 close @@DChk1
 deallocate @@DChk1
 fetch next from @@DChk into @@Party,@@Scrip_Cd,@@Series
 select @@Party,@@Scrip_Cd,@@Series
end 
close @@DChk
deallocate @@DChk

GO
