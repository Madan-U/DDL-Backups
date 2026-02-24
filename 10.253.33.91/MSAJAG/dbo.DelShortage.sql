-- Object: PROCEDURE dbo.DelShortage
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DelShortage    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DelShortage    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.DelShortage    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.DelShortage    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DelShortage    Script Date: 12/27/00 8:59:07 PM ******/

CREATE Proc DelShortage 
@settno varchar(7),
@setttype varchar(2),
@flag smallint
AS
if @flag = 1
 begin
  SELECT d.sett_no,d.sett_type,D.SCRIP_CD,D.SERIES,D.DELIVERYNO,ENTITYCODE,Deliver_Qty,
  Delivered_Qty=sum(C.qty)-isnull(( select sum(qty) from dematdelivery where sett_no = d.sett_no 
  and sett_Type = d.sett_Type and scrip_cd = d.scrip_cd and series = d.series and inout = 'I' 
  and bankcode not like 'Pay-In%'),0),shortage = deliver_qty - sum(C.qty)- isnull(( select sum(qty) 
  from dematdelivery where sett_no = d.sett_no and sett_Type = d.sett_Type and scrip_cd = d.scrip_cd 
  and series = d.series and inout = 'I' and bankcode not like 'Pay-In%'),0),d.recieptno,d.name 
  FROM DELIVERY D, CERTINFO C WHERE D.SETT_NO = @settno AND D.SETT_TYPE = @setttype 
  AND D.SETT_NO = C.SETT_NO AND D.SETT_TYPE = C.SETT_TYPE AND D.SCRIP_CD = C.SCRIP_CD AND D.SERIES = C.SERIES
  GROUP BY d.sett_no,d.sett_type,D.SCRIP_CD,D.SERIES,D.DELIVERYNO,ENTITYCODE,C.inout,d.recieptno,d.deliver_qty,d.name
  HAVING DELIVER_QTY > ( SUM(C.QTY) + isnull(( select sum(qty) from dematdelivery 
  where sett_no = d.sett_no and sett_Type = d.sett_Type and scrip_cd = d.scrip_cd 
  and series = d.series and inout = 'I' and bankcode not like 'Pay-In%'),0) )
  order by d.scrip_Cd
 end
else if @flag = 2
 begin
  SELECT sett_no,sett_type,SCRIP_CD,SERIES,DELIVERYNO,ENTITYCODE,Deliver_qty,Delivered_Qty=0,shortage=deliver_qty,recieptno,name FROM DELIVERY WHERE SCRIP_CD NOT IN
  ( SELECT DISTINCT SCRIP_CD FROM CERTINFO WHERE SETT_NO = @settno AND SETT_TYPE = @setttype )
  AND SETT_NO = @settno AND SETT_TYPE = @setttype 
  order by scrip_cd
 end
else if @flag = 3
 begin
  SELECT DISTINCT d.sett_no,d.sett_type,D.SCRIP_CD,D.SERIES,D.DELIVERYNO,ENTITYCODE,d.deliver_qty,delivered_qty = sum(c1.qty),shortage= d.deliver_qty,d.recieptno,d.name 
  FROM SCRIP1 S1,SCRIP2 S2,CERTINFO C1, delivery d  WHERE S1.CO_CODE = S2.CO_CODE 
  AND S2.SCRIP_CD = C1.SCRIP_CD AND S2.SERIES = C1.SERIES 
  AND C1.SETT_NO = @settno AND C1.SETT_TYPE = @setttype 
  AND C1.SERIES = 'EQ' AND C1.CERTNO NOT LIKE 'in%'
  AND S1.DEMAT_DATE < GETDATE() AND S1.DEMAT_DATE > 'JAN  1 1900'
  and d.sett_no = c1.sett_no and d.sett_type = c1.sett_Type and 
  d.series = c1.series and d.scrip_cd = c1.scrip_Cd
  group by d.sett_no,d.sett_type,D.SCRIP_CD,D.SERIES,D.DELIVERYNO,ENTITYCODE,d.deliver_qty,d.deliver_qty,d.recieptno,d.name 
  order by d.scrip_Cd
 end

GO
