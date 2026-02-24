-- Object: PROCEDURE dbo.spAdjDaysCursor
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.spAdjDaysCursor    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.spAdjDaysCursor    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.spAdjDaysCursor    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.spAdjDaysCursor    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.spAdjDaysCursor    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.spAdjDaysCursor    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.spAdjDaysCursor    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.spAdjDaysCursor    Script Date: 20-Mar-01 11:43:36 PM ******/

/* 22/03/2000   this procedure is used to adjust the balance amount of  all the parties according to the dates*/
CREATE PROCEDURE     spAdjDaysCursor    @code varchar(12)
 AS
declare   @@trefno varchar(12) ,
@@tcur cursor    ,
@@tnodays integer,
 @@Prevdays  integer,
@@tvdt  datetime  ,
@@PrevVdt  datetime
                 set @@tcur = cursor for 
                 select  refno ,nodays ,vdt   from ledger 
                 where cltcode= @code
                 order by vdt,vtyp,  vno1,refno 
                 open @@tcur
  
fetch next  from @@tcur into   @@trefno , @@tnodays ,@@tvdt
 
 select @@PrevVdt  = @@tvdt
                       
while   @@fetch_status =0
begin
  fetch next  from @@tcur into    @@trefno   ,  @@tnodays  , @@tvdt
  update ledger set   nodays = abs(datediff(day, @@PrevVdt  ,@@tvdt))
                 where   current  of  @@tcur
 select @@PrevVdt  = @@tvdt   
end
close @@tcur
deallocate @@tcur

GO
