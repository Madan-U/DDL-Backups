-- Object: PROCEDURE dbo.Scshortagepayout
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Scshortagepayout    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.Scshortagepayout    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.Scshortagepayout    Script Date: 20-Mar-01 11:39:08 PM ******/

/*
Control : PayoutShortageCtl
Use : To calculate scripwise payout of party of given settlement no,   settlement  type
Written by : Kalpana
Date : 08/02/2001
*/
CREATE procedure  Scshortagepayout
@settno varchar(7),
@settype varchar(3),
@Scripcd varchar(10) 
as
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,ToGive=Qty,
 Given = isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and TargetParty = d.party_code),0)
 from deliveryClt d,Client2 C2,Client1 C1 where d.inout = 'O' and qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
and sett_no like @settno + '%'
and sett_type like @settype + '%'  and d.scrip_cd like @Scripcd + '%' 
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,qty
having Qty <> isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and TargetParty = d.party_code),0)
order by d.scrip_cd

GO
