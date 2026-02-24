-- Object: PROCEDURE dbo.spAdjTimeCursor
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.spAdjTimeCursor    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.spAdjTimeCursor    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.spAdjTimeCursor    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.spAdjTimeCursor    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.spAdjTimeCursor    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.spAdjTimeCursor    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.spAdjTimeCursor    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.spAdjTimeCursor    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE     spAdjTimeCursor    @ttime varchar(20) 
 AS
declare   @@trefno varchar(12) ,
@@tvdt datetime  ,
@@tvtyp varchar(2),
@@tvno1 varchar(2),
@@tdate datetime,
@@tsec   varchar(2),
@@tcnt  integer,
@@code varchar(12),
@@tcur cursor    
                 set @@tcur = cursor for 
 select      cltcode,vdt,vtyp,vno1,refno     from ledger 
                order by cltcode,vdt,vtyp,vno1,refno  
                open @@tcur
while   @@fetch_status =0
begin
               fetch next  from @@tcur into   @@code,  @@tvdt   ,  @@tvtyp,   @@tvno1,   @@trefno
         
 select  @@tdate = @@tvdt
        
        
                  If    @@tcnt = 59 
                 begin
                        select    @@tcnt = 0
                  End
 select  @@tcnt=@@tcnt+1
        
                   If    @@tcnt < 9
 begin
                             select   @@tsec = "0"  +   @@tcnt
                  End   
                    If Len( @@tvdt) > 21 
                   begin
                           select   @@tdate = Left(@@tdate, 17)
          select  @@tdate = @@tdate  +  @@tsec
                   end
 if Len( @@tvdt  ) = 21
                   begin
          select   @@tdate = Left( @@tdate, 16)
          select  @@tdate = @@tdate  +  @@tsec
                   end
 if Len( @@tvdt  ) <   21
 begin
          select  @@tdate = Left(@@tdate, 10)  +   " "  + @tTime
  End
                update ledger set vdt= @@tdate  
                 where   current of  @@tcur
              
end
close @@tcur
deallocate @@tcur

GO
