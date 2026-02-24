-- Object: PROCEDURE dbo.SCshortagepayinParty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SCshortagepayinParty    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.SCshortagepayinParty    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.SCshortagepayinParty    Script Date: 20-Mar-01 11:39:08 PM ******/

/*
control name  : ShortagePrintCtl
Use : To get Scip wise shortage 
Written by : Kalpana
Date : 08/02/2001
*/
CREATE proc SCshortagepayinParty 
@SettNo varchar(10),
@Setttype char(1),
@PartycodeFrom varchar(6),
@PartycodeTo varchar(6),
@Scripcd varchar(10) 
as
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,ToRecive=Qty,
 Recieved = isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and party_code = d.party_code),0)
 from deliveryClt d,Client2 C2,Client1 C1 where d.inout = 'I' and qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code 
 and sett_no like  @SettNo + '%'  and sett_type like  @Setttype + '%'  and d.party_code >= @PartycodeFrom and d.party_code <= @PartycodeTo
 and d.scrip_cd like @Scripcd + '%' 
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,qty
having Qty <> isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and party_code = d.party_code),0) 
order by Scrip_cd

GO
