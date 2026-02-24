-- Object: PROCEDURE dbo.NseDelCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.NseDelCursor    Script Date: 4/27/01 5:41:06 PM ******/

/****** Object:  Stored Procedure dbo.NseDelCursor    Script Date: 3/17/01 9:55:54 PM ******/

/****** Object:  Stored Procedure dbo.NseDelCursor    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.NseDelCursor    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.NseDelCursor    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.NseDelCursor    Script Date: 12/27/00 8:59:08 PM ******/


/****** Object:  Stored Procedure dbo.NseDelCursor    Script Date: 11/30/2000 4:13:36 PM ******/
CREATE Proc NseDelCursor (@Sett_No Varchar(7),@Sett_Type Varchar(2)) As
Declare @@ScripCd Varchar(12),
	@@Series Varchar(2),
	@@EntityCode Varchar(10),
	@@DelQty int,
	@@CQty int,
	@@DelCur Cursor
Set @@DelCur = Cursor For
        select c.scrip_cd ,c.series,d.deliver_Qty , d.entitycode , 0
        from certinfo c , delivery d where entitycode not in 
	   (  select  targetparty from certinfo  where certinfo.scrip_cd = d.scrip_cd and sett_no = @Sett_No
              And sett_type =  @Sett_Type
           )
        and c.sett_no = @Sett_No And c.sett_type = @Sett_Type and d.scrip_cd = c.scrip_cd 
        and d.series = c.series AND D.SETT_NO = C.SETT_NO  and d.sett_type = c.sett_type 
        group by c.scrip_cd ,c.series, entitycode , deliver_qty , rec_centre  order by rec_centre desc 
open @@DelCur
fetch next from @@DelCur into @@ScripCd,@@Series,@@DelQty,@@EntityCode,@@CQty
While @@Fetch_Status = 0
Begin
	Select @@DelQty = @@DelQty - @@CQty
	Execute NseDelAllocateCursor @Sett_No,@Sett_Type,@@ScripCd,@@Series,@@EntityCode,@@DelQty,@@CQty 
	fetch next from @@DelCur into @@ScripCd,@@Series,@@DelQty,@@EntityCode,@@CQty
end
Close @@DelCur
DeAllocate @@DelCur

Set @@DelCur = Cursor For
	select c.scrip_cd,c.series,deliver_qty,entitycode,sum(c.qty) 
        from certinfo c,delivery d where c.targetparty = d.entitycode 
        and c.sett_no = d.sett_no and c.sett_type = d.sett_type 
        and c.scrip_Cd = d.scrip_cd and c.series = d.series and c.sett_no = @Sett_No and c.sett_type = @Sett_Type
        group by c.scrip_cd,c.series,d.deliver_qty,d.entitycode,c.targetparty,d.rec_centre 
        Having deliver_qty > Sum(qty)  order by rec_centre  
open @@DelCur
fetch next from @@DelCur into @@ScripCd,@@Series,@@DelQty,@@EntityCode,@@CQty
While @@Fetch_Status = 0
Begin
	Select @@DelQty = @@DelQty - @@CQty
	Execute NseDelAllocateCursor @Sett_No,@Sett_Type,@@ScripCd,@@Series,@@EntityCode,@@DelQty,@@CQty 
	fetch next from @@DelCur into @@ScripCd,@@Series,@@DelQty,@@EntityCode,@@CQty
end

Close @@DelCur
DeAllocate @@DelCur

GO
