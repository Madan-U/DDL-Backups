-- Object: PROCEDURE dbo.Clientdelshortage
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Clientdelshortage    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.Clientdelshortage    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.Clientdelshortage    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.Clientdelshortage    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.Clientdelshortage    Script Date: 12/27/00 8:58:47 PM ******/

CREATE Proc Clientdelshortage
@settno varchar(7),
@setttype varchar(2),
@flag smallint
AS
if @flag= 1
 begin
  select d1.sett_no,d1.sett_type,D1.SCRIP_CD,D1.SERIES,D1.party_code,deliver_qty = d1.qty,delivered_qty = 0,shortage = d1.qty from deliveryclt d1 where sett_no = '2000031' and sett_Type = 'n'
  and inout = 'i' and party_code not in ( select C.Party_code from certinfo c, deliveryClt D where c.sett_no =@settno and c.sett_Type = @setttype
  and c.inout = 'i' and d.sett_no = c.sett_no and d.sett_type = c.sett_type and d.scrip_cd = c.scrip_cd and d.party_code = c.party_code and d.series = c.series and d1.scrip_Cd = d.scrip_cd)
  group by d1.sett_no,d1.sett_type,D1.SCRIP_CD,D1.SERIES,D1.party_code,d1.qty
  order by d1.scrip_cd
 end
else if @flag = 2
 begin
  SELECT sett_no,sett_type,SCRIP_CD,SERIES,Party_code,deliver_qty = qty,delivered_qty = 0,shortage=qty FROM DELIVERYclt WHERE SCRIP_CD NOT IN
  ( SELECT DISTINCT SCRIP_CD FROM CERTINFO WHERE SETT_NO = @settno AND SETT_TYPE = @setttype AND INOUT = 'I')
  AND SETT_NO = '2000031' AND SETT_TYPE = 'N' AND INOUT = 'I'
  order by scrip_cd
 end
else if @flag = 3
 begin 
  SELECT  d.sett_no,d.sett_type,D.SCRIP_CD,D.SERIES,D.party_code,deliver_qty = d.qty,delivered_qty = sum(c1.qty),shortage= d.qty
  FROM SCRIP1 S1,SCRIP2 S2,CERTINFO C1, deliveryclt d  WHERE S1.CO_CODE = S2.CO_CODE 
  AND S2.SCRIP_CD = C1.SCRIP_CD AND S2.SERIES = C1.SERIES 
  AND C1.SETT_NO = @settno AND C1.SETT_TYPE = @setttype 
  AND C1.SERIES = 'EQ' AND C1.CERTNO NOT LIKE 'in%'
  AND S1.DEMAT_DATE < GETDATE() AND S1.DEMAT_DATE > 'JAN  1 1900'
  and d.sett_no = c1.sett_no and d.sett_type = c1.sett_Type and 
  d.series = c1.series and d.scrip_cd = c1.scrip_Cd
  group by d.sett_no,d.sett_type,D.SCRIP_CD,D.SERIES,D.party_code,d.qty
  order by d.scrip_cd
 end

GO
