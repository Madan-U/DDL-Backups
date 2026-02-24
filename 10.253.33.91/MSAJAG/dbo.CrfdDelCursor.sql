-- Object: PROCEDURE dbo.CrfdDelCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.CrfdDelCursor    Script Date: 3/21/01 12:50:05 PM ******/
/****** Object:  Stored Procedure dbo.CrfdDelCursor    Script Date: 20-Mar-01 11:38:48 PM ******/
/****** Object:  Stored Procedure dbo.CrfdDelCursor    Script Date: 2/5/01 12:06:11 PM ******/
/****** Object:  Stored Procedure dbo.CrfdDelCursor    Script Date: 12/27/00 8:58:48 PM ******/
/****** Object:  Stored Procedure dbo.CrfdDelCursor    Script Date: 11/30/2000 4:13:36 PM ******/
CREATE Proc CrfdDelCursor ( @Sett_no Varchar(7),@Sett_Type Varchar(2)) as 
Declare @@Sno Varchar(7),
 @@Stype Varchar(2),
 @@TargetParty Varchar(10),
 @@Scrip_Cd Varchar(12),
 @@Series Varchar(2),
 @@SDate Varchar(11),
 @@Sno1 Varchar(7),
 @@Stype1 Varchar(2),
 @@TargetParty1 Varchar(10),
 @@Scrip_Cd1 Varchar(12),
 @@Series1 Varchar(2),
 @@Cfwd Cursor,
 @@Cfwd1 Cursor
Set @@Cfwd = Cursor for 
 select distinct sett_no , sett_type ,targetparty , scrip_cd , series,Sdate=Left(Convert(varchar,date,109),11) 
 from certinfo where   delivered = '0' And SETT_NO <>  @Sett_No
 And sett_type <> @Sett_Type Order by Sett_no,Sett_Type,Scrip_cd,Series,TargetParty
Open @@Cfwd
fetch next from @@Cfwd into @@SNo,@@SType,@@TargetParty,@@Scrip_Cd,@@Series,@@SDate
while @@fetch_Status = 0
begin
 Set @@Cfwd1 = Cursor for 
  select sett_no , sett_type ,party_code ,scrip_cd , series 
         from deliveryclt where sett_no = @Sett_no
         and sett_type = @Sett_Type
         and party_code = @@TargetParty
         and scrip_cd = @@Scrip_cd
         and series = @@Series
 open @@Cfwd1
 fetch next from @@Cfwd1 into @@SNo1,@@SType1,@@TargetParty1,@@Scrip_Cd1,@@Series1
 if @@fetch_Status = 0
 begin
  execute DAInsertCertinfo 3 ,@@Sno,@@Stype,@@TargetParty,@@scrip_cd,@@series,'','','','',0,0,0,'0',@@SDate,0,0,0
        insert into certinfo select @Sett_no,@Sett_type,@@scrip_cd,@@series,qty,party_code,date,fromno,tono,
              reason,certno,foliono,holdername,'1',inout,'0',Sett_No,sett_Type,recieptno,0,0,DpType,PODpId,POCltNo,SlipNo
                               from certinfo where sett_no = @@sno
                              and sett_type = @@stype 
               and targetparty = @@Targetparty
                              and scrip_cd = @@scrip_cd
                              and series = @@series 
                              and date like @@SDate
 
 end 
 Close @@Cfwd1
 deallocate @@Cfwd1
 fetch next from @@Cfwd into @@SNo,@@SType,@@TargetParty,@@Scrip_Cd,@@Series,@@Sdate 
end 
Close @@Cfwd
deallocate @@Cfwd

GO
