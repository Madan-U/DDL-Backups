-- Object: PROCEDURE dbo.Acc_GenVno_new
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

        
        
CREATE PROC [dbo].[Acc_GenVno_new]  
@vdt      varchar(11),  /* dd/mm/yyyy */              
@vtyp     smallint,              
@booktype varchar(2),              
@sdtcur   varchar(11),              
@ldtcur   varchar(11),    
@noofrecords int = 1    
/* @vnoflag  int */              
as              
              
              
              
Declare @@voudt  as datetime              
Declare @@maxvno as numeric(12,0)              
Declare @@vnoflag as tinyint              
Declare @@vno as varchar(12)              
Declare @@rcnt as int              
Declare @@FldAuto bigint              
Declare @@YearlyVdt varchar(11)            
Declare @@DailyVDt Varchar(11)              
Declare @@MonthlyVdt varchar(11)              
Declare @@UpdtVdt varchar(11)              
Declare @@FinYear smallint            
    
Declare @@ReturnVno as varchar(12)    
              
--SET NOCOUNT ON              
set Xact_abort on              
              
begin transaction              
      
Select       
      @sdtcur = LEFT(SDTCUR,11),       
      @ldtcur = LEFT(LDTCUR,11),       
      @@vnoflag = vnoflag,             
      @@FinYear = FldAuto              
from       
      Parameter       
where        
      convert(datetime,@vdt) BETWEEN sdtcur and ldtcur       
      
/*      
Select             
from             
      Parameter             
where              
      sdtcur like @sdtcur + '%'             
      and ldtcur like @ldtcur + '%'            
*/            
            
/*             
Reinitialising the Dates to be posted in the table.              
      For Daily, the Voucher Date is taken            
      For Monthly, the 1st Day of the Month  is Taken            
      For Yearly, the first Day of the year is taken            
*/            
            
select             
      @@voudt = (select convert(datetime,@vdt)),             
      @@MonthlyVdt = left(@Vdt,4)+' 1 '+right(@Vdt,4),             
      @@DailyVdt = @Vdt,             
      @@YearlyVdt = LEFT(@SDTCUR,4) + ' 1 '+ right(@SDTCUR,4)            
        
-- Doing Yearly Voucher Gen              
if @@vnoflag = 0              
   begin              
      select             
            @@FldAuto = isnull(FldAuto,0) ,             
            @@maxvno = convert(NUMERIC,isnull(lastvno,0))             
      from             
            V2_LastVno WITH (INDEX(VNOIDX),TABLOCKX,HOLDLOCK)             
      where             
            vtyp = @vtyp             
            and booktype = @booktype             
            and vdt = @@YearlyVdt + ' 00:00:00'             
            and VnoFlag = @@VnoFlag             
            and FinYear = @@FinYear            
            
            
      if @@ROWCOUNT=0            
         begin              
            -- If No Record Present, then Insert            
           select             
                  @@FldAuto=0,             
                  @@UpdtVdt = @@YearlyVdt,             
                  @@ReturnVno = Right(@@YearlyVdt,4) + '00000001',              
  @@Vno = Right(@@YearlyVdt,4) + Replicate('0', 8-len(@noofrecords)) + cast(@noofrecords as varchar)                
 end              
         else              
         begin              
           select             
            -- If record is Present, then Update            
                  @@UpdtVdt = @@YearlyVdt,             
                  @@Returnvno = rtrim(convert(varchar,@@maxvno + 1))  ,            
  @@Vno = rtrim(convert(varchar,@@maxvno + @noofrecords))              
         end              
   end              
            
-- Doing Daily Voucher Gen              
else if @@vnoflag = 1              
        begin              
            
          select             
                  @@FldAuto = isnull(FldAuto,0) ,              
                  @@maxvno =convert(NUMERIC,isnull(lastvno,0))             
            from         
                  V2_LastVno WITH (Index(VnoIdx), TABLOCKX,HOLDLOCK)             
            where             
                  vtyp = @vtyp             
                  and booktype = @booktype             
                  and vdt = @@DailyVDt + ' 00:00:00'              
                  and VnoFlag = @@VnoFlag and FinYear = @@FinYear            
            
            
          if  @@ROWCOUNT=0            
             begin              
            -- If No Record Present, then Insert            
                select             
                  @@FldAuto=0,             
                  @@UpdtVdt = @@DailyVdt,             
                  @@Returnvno = (select convert(varchar,year(@@voudt)) + right('0'+ltrim(convert(varchar,month(@@voudt))),2) + right('00'+ltrim(convert(varchar,day(@@voudt))),2))+'0001'          ,    
  @@Vno = (select convert(varchar,year(@@voudt)) + right('0'+ltrim(convert(varchar,month(@@voudt))),2) + right('00'+ltrim(convert(varchar,day(@@voudt))),2))+ Replicate('0', 4-len(@noofrecords)) + cast(@noofrecords as varchar)    
    
             end              
          else              
             begin              
            -- If record is Present, then Update            
               select             
                  @@UpdtVdt = @@DailyVdt,             
                  @@Returnvno = rtrim(convert(varchar,@@maxvno + 1)),              
  @@Vno = rtrim(convert(varchar,@@maxvno + @noofrecords))              
    
             end              
        end              
            
-- Doing Monthly Voucher Gen              
else if @@vnoflag = 2              
        begin              
          select             
                  @@FldAuto = isnull(FldAuto,0) ,             
                  @@maxvno =convert(NUMERIC,isnull(lastvno,0))             
            from             
                  V2_LastVno WITH (index(VNoIdx), TABLOCKX,HOLDLOCK)             
            where             
                  vtyp = @vtyp             
                  and booktype = @booktype             
                  and vdt = @@MonthlyVDt + ' 00:00:00'              
                  and VnoFlag = @@VnoFlag and FinYear = @@FinYear            
            
            
          if  @@ROWCOUNT=0            
             begin              
            -- If No Record Present, then Insert            
                select             
                  @@FldAuto=0,             
                  @@UpdtVdt = @@MonthlyVdt,             
                  @@Returnvno = (select convert(varchar,year(@@voudt)) + right('0'+ltrim(convert(varchar,month(@@voudt))),2))+'000001',              
  @@Vno = (select convert(varchar,year(@@voudt)) + right('0'+ltrim(convert(varchar,month(@@voudt))),2))+ Replicate('0', 6-len(@noofrecords)) + cast(@noofrecords as varchar)    
    
             end              
         else              
             begin              
            -- If record is Present, then Update            
               select             
                  @@UpdtVdt = @@MonthlyVdt,             
                  @@Returnvno = rtrim(convert(varchar,@@maxvno + 1)),              
  @@Vno = rtrim(convert(varchar,@@maxvno + @noofrecords))              
    
             end              
        end      
            
              
if @@error <> 0               
begin              
 rollback transaction              
 select vno = ''              
 return              
end               
else              
begin              
       if isnull(@@vno,'') <> ''               
       begin              
                  if isnull(@@FldAuto,0) = 0              
                  begin              
                    -- If No Record Present, then Insert            
                        insert into V2_LastVno             
                        (Vtyp, BookType, Vdt, LastVno, VnoFlag, FinYear)            
                        values             
                        (@vtyp,@booktype,@@UpdtVdt,@@vno, @@VnoFlag, @@FinYear)              
                  end              
                  else              
                  begin              
                        -- If record is Present, then Update            
                        Update             
                              V2_LastVno             
                        set             
                              Lastvno = @@Vno             
                        where             
                              FldAuto = @@FldAuto              
                  end             
     
                        commit transaction              
    
                        select vno = @@Returnvno              
                        return              
       end               
end

GO
