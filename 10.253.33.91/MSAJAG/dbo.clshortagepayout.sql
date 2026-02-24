-- Object: PROCEDURE dbo.clshortagepayout
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.clshortagepayout    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.clshortagepayout    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.clshortagepayout    Script Date: 20-Mar-01 11:38:47 PM ******/

/*
Control : PayoutShortageCtl
Use : To calculate Partycodewise payout of client 
Written by : Kalpana
Date : 08/02/2001
*/
CREATE procedure  clshortagepayout
@settno varchar(7),
@settype varchar(3),
@partycode varchar(6)
as
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,ToGive=Qty,
 Given = isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and TargetParty = d.party_code),0)
 from deliveryClt d,Client2 C2,Client1 C1 where d.inout = 'O' and qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
and sett_no like @settno + '%'
and sett_type like @settype + '%' and d.party_code like @partycode + '%'
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,qty
having Qty <> isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and TargetParty = d.party_code),0)
order by d.party_code

GO
