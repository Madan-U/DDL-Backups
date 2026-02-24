-- Object: PROCEDURE dbo.InsNseDelCursor
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE Proc InsNseDelCursor (@Sett_No Varchar(7),@Sett_Type Varchar(2),@RefNo int) As
Declare @@ScripCd Varchar(12),
 @@Series Varchar(3),
 @@EntityCode Varchar(10),
 @@DelQty int,
 @@CQty int,
 @@TrType int,
 @@DelCur Cursor

Exec InsNseDematOutCursor

Set @@DelCur = Cursor For
        select d.scrip_cd,d.series,deliver_qty,entitycode,sum(Isnull(C.qty,0)),TrType=904
        from delivery d Left Outer Join DelTrans c on ( c.party_code = d.entitycode 
        and c.sett_no = d.sett_no and c.sett_type = d.sett_type and Filler2 = 1 and RefNo = @RefNo and DrCr = 'D'  and TrType = 906 
        and c.scrip_Cd = d.scrip_cd and c.series = d.series)
        where  c.sett_no = @Sett_No and c.sett_type = @Sett_Type
        group by d.scrip_cd,d.series,d.deliver_qty,d.entitycode,c.party_code,d.rec_centre ,TrType
        Having deliver_qty > sum(Isnull(C.qty,0)) order by rec_centre  

open @@DelCur
fetch next from @@DelCur into @@ScripCd,@@Series,@@DelQty,@@EntityCode,@@CQty,@@TrType

While @@Fetch_Status = 0
Begin
 Select @@DelQty = @@DelQty - @@CQty
 	
 Execute InsNseDelAllocate @Sett_No,@Sett_Type,@RefNo,@@ScripCd,@@Series,@@EntityCode,@@DelQty,@@CQty,@@TrType   
 fetch next from @@DelCur into @@ScripCd,@@Series,@@DelQty,@@EntityCode,@@CQty,@@TrType

end
Close @@DelCur
DeAllocate @@DelCur

/*
Set @@DelCur = Cursor For

        select d.scrip_cd,d.series,D.Qty,'EXE',sum(Isnull((Case When DrCr = 'D' Then C.qty Else -C.Qty End) ,0)),TrType = 904
        from DelNet d Left Outer Join DelTrans c on ( c.sett_no = d.sett_no and c.sett_type = d.sett_type and Filler2 = 1 and RefNo = @RefNo and TrType = 906 
        and c.scrip_Cd = d.scrip_cd and c.series = d.series)
        where  d.sett_no = @Sett_No and d.sett_type = @Sett_Type
	and D.InOut = 'I'  
        group by d.scrip_cd,d.series,d.Qty,trtype 
        Having D.Qty > sum(Isnull((Case When DrCr = 'D' Then C.qty Else -C.Qty End) ,0))
        order by d.scrip_cd		

open @@DelCur
fetch next from @@DelCur into @@ScripCd,@@Series,@@DelQty,@@EntityCode,@@CQty,@@TrType

While @@Fetch_Status = 0
Begin
 Select @@DelQty = @@DelQty - @@CQty
 Execute InsNseDelAllocate @Sett_No,@Sett_Type,@RefNo,@@ScripCd,@@Series,@@EntityCode,@@DelQty,@@CQty,@@TrType   
 fetch next from @@DelCur into @@ScripCd,@@Series,@@DelQty,@@EntityCode,@@CQty,@@TrType

end
Close @@DelCur
DeAllocate @@DelCur
*/
Set @@DelCur = Cursor For

select d.scrip_cd,d.series,(Case When Inout = 'I' Then D.Qty-sum(Isnull((Case When DrCr = 'D' Then C.qty 
Else Case When d.sett_type <> 'W' Then -C.Qty Else 0 End End) ,0)) Else 
sum(Isnull((Case When DrCr = 'D' Then -C.qty 
Else Case When d.sett_type <> 'W' Then C.Qty Else 0 End End) ,0)) - D.Qty end)
,'EXE',CQty=0,TrType=904
from DelNet d Left Outer Join DelTrans c on ( c.sett_no = d.sett_no and c.sett_type = d.sett_type 
and Filler2 = 1 and RefNo = @RefNo and TrType = 906 And 
CertNo like (Case When D.Sett_Type = 'A' Then '%' Else 'IN%' End)
and c.scrip_Cd = d.scrip_cd and c.series = d.series)
where  d.sett_no = @Sett_No and d.sett_type = @Sett_Type
group by d.scrip_cd,d.series,d.Qty,trtype,Inout
Having (Case When Inout = 'I' Then D.Qty-sum(Isnull((Case When DrCr = 'D' Then C.qty 
Else Case When d.sett_type <> 'W' Then -C.Qty Else 0 End End) ,0)) Else 
sum(Isnull((Case When DrCr = 'D' Then -C.qty 
Else Case When d.sett_type <> 'W' Then C.Qty Else 0 End End) ,0)) - D.Qty end) > 0 
order by d.scrip_cd	

open @@DelCur
fetch next from @@DelCur into @@ScripCd,@@Series,@@DelQty,@@EntityCode,@@CQty,@@TrType

While @@Fetch_Status = 0
Begin

Select @@DelQty = @@DelQty - @@CQty
Select @@CQty,@@DelQty  ,@@Scripcd

select @Sett_No,@Sett_Type,@RefNo,@@ScripCd,@@Series,@@EntityCode,@@DelQty,@@CQty,@@TrType
 Execute InsNseDelAllocate @Sett_No,@Sett_Type,@RefNo,@@ScripCd,@@Series,@@EntityCode,@@DelQty,@@CQty,@@TrType   
 fetch next from @@DelCur into @@ScripCd,@@Series,@@DelQty,@@EntityCode,@@CQty,@@TrType

end
Close @@DelCur
DeAllocate @@DelCur

GO
