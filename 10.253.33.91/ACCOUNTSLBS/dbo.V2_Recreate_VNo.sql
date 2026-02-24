-- Object: PROCEDURE dbo.V2_Recreate_VNo
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/*select * from ledger where vno like '2006%'     
exec V2_Recreate_VNo*/    
    
    
CREATE Proc V2_Recreate_VNo    
as    
/*    
            VnoFlag = 0 Yearly      
            VnoFlag = 1 Daily      
            VnoFlag = 2 Monthly      
*/    
    
    
    
    
    
Select f.Vtyp, f.BookType, f.Vdt, Max(VNo), f.VNoFlag, f.FinYear    
From    
(    
      Select     
            x.Vtyp,     
            x.BookType,    
            Vdt = (Case when x.VNoFlag = 0 then Cast(x.Mn1 + ' 1 '+cast(x.Yr as varchar) as Datetime)    
                              when x.VnoFlag = 1 then Cast(left(x.Vdt,11) as Datetime)    
                              when x.VnoFlag = 2 then Cast(x.Mn + ' 1 '+cast(x.Yr as varchar) as Datetime)    
                        End),    
            X.VNO,    
            x.VnoFlag,    
            FinYear = x.FldAuto    
      From    
            (    
                  select     
                  a.Vtyp,     
                  a.BookType,     
                  a.Vdt,     
                  a.VNo,     
                  B.VnoFlag,     
                  b.FldAuto,     
                  Yr = Year(b.sdtCur) ,     
                  Mn1 = left(B.sdtCur,4),    
                  Mn = left(a.Vdt,4),    
                  Dt = day(a.Vdt)    
                  from LEDGER a, Parameter b    
                  where a.Vdt between b.SdtCur and b.LdtCur    
            ) X    
) F    
group by     
f.Vtyp, f.BookType, f.Vdt, f.VNoFlag, f.FinYear

GO
