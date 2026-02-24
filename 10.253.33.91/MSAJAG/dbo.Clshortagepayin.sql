-- Object: PROCEDURE dbo.Clshortagepayin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Clshortagepayin    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.Clshortagepayin    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.Clshortagepayin    Script Date: 20-Mar-01 11:38:47 PM ******/

/*
control name  : ShortagePrintCtl
Use : To get party_code wise shortage  for selected settlement number and settlement type  
Written by : Kalpana
Date : 06/02/2001
*/

CREATE proc Clshortagepayin
@SettNo varchar(10),
@Setttype char(1),
@Partycode varchar(6)
/*,@Scripcd varchar(10) */
as
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,ToRecive=Qty,
 Recieved = isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and party_code = d.party_code),0)
 from deliveryClt d,Client2 C2,Client1 C1 where d.inout = 'I' and qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and sett_no like @SettNo+ '%'  and sett_type like  @Setttype+'%'  and d.party_code like  @Partycode + '%'
    /*  and d.scrip_cd like @Scripcd + '%' */
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,qty
having Qty <> isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and party_code = d.party_code),0) 
order by d.party_code

GO
