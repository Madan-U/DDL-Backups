-- Object: PROCEDURE dbo.Transfer_NewData
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC Transfer_NewData                        
                        
As                                      
                        
/*------------------------------------------------------*/                                      
/*   INSERT    */                                      
/*------------------------------------------------------*/                                      
                        
      Declare @@DematCur Cursor                        
      Declare @@FldAuto Bigint                        
      Declare @@ActionFlag char(1)                        
      Declare @@SNO decimal                      
      Declare @InsFirstNo bigint                                      
      Declare @InsLastNo bigint                                      
      Declare @@TempSNo decimal(18, 0)                                      
      Declare @StartTime datetime            
      Declare @TotalRecCount bigint            
                
            
select @StartTime = Getdate()            
                
set transaction isolation level read uncommitted                                 
      Insert into               
            client1_report                                  
      select                 
            c1.*                 
      from                 
            client1 c1                 
            left outer join                 
            client1_report cr                                  
            on               
            (              
                  c1.cl_code=cr.cl_code              
            )                                  
      where                 
            isnull(cr.cl_code,'*') = '*'  
            and isnull(c1.cl_code,'*') <> '*'  
                                  
                                  
                
set transaction isolation level read uncommitted                                                
      Insert into               
            client2_report                                  
      select                 
            c2.*                 
      from                 
            client2 c2                 
            left outer join                 
            client2_report cr                                  
            on               
            (              
                  c2.party_code=cr.party_code              
            )                                  
      where                 
            isnull(cr.party_code,'*') ='*'                                                        
    and isnull(c2.party_code,'*') <> '*'  
      and isnull(C2.cl_code,'*') <> '*'  
                
            
Update Client1_Report Set Branch_Cd = C1.Branch_Cd,         
Sub_broker = C1.Sub_Broker,         
Trader = C1.Trader,      
Family = C1.Family,    
Area = C1.Area,      
Region = C1.Region,    
short_name = c1.short_name,
long_name = c1.long_name
From Client1 C1        
Where C1.Cl_Code = Client1_Report.Cl_Code        
And (Client1_Report.Branch_Cd <> C1.Branch_Cd        
Or   Client1_Report.Sub_broker <> C1.Sub_Broker        
Or   Client1_Report.Trader <> C1.Trader               
Or   Client1_Report.Family <> C1.Family              
Or   Client1_Report.long_name <> C1.long_name              
Or   Client1_Report.short_name <> C1.short_name      
Or   Client1_Report.Region <> C1.Region               
Or   Client1_Report.Area <> C1.Area                      
)         
            
            
BEGIN TRAN                  
    
    
    SELECT TOP 1 @@tempsno =  isnull(sno,0) FROM DELTRANS           
            
    
    
            
 UPDATE     
  DELTRANS            
 SET     
  sett_no = SETT_NO            
 WHERE     
  isnull(SNO,0) = 0            
    
    
            
      Update DoNotDelete_Deltrans            
      Set Sno = Sno            
      where Sno = 0            
                   
            
      select @InsFirstNo = isnull(fldlastins,0) from tblglobalparams                                      
      select @InsLastNo = IDENT_CURRENT('DoNotDelete_Deltrans')                                    
            
            
      Select                 
            *                 
      into                 
            #DoNotDelete_Deltrans                
      from      
            DonotDelete_Deltrans             
      where                 
            FldAuto <= @InsLastNo                
              Select @TotalRecCount = @@RowCount            
                
COMMIT                
            
-- Print @TotalRecCount            
-- Select * from #DoNotDelete_Deltrans            
            
                
 Create Index               
            TempIdx               
      on               
            #DonoTDelete_Deltrans               
            (              
                  ActionFlag,               
                  SNO,          
                  FldAuto              
            )                
            
            
            
                
            
                
      Select                  
            SNO,                 
            FldAuto=Max(FldAuto)                 
      into                 
            #FldAutoTable                 
      from                 
            #DonotDelete_Deltrans                 
      where                 
            ActionFlag <> 'D'                
      Group by               
 Sno                
                
                
Create Index               
      Idx               
on               
      #FldAutoTable               
      (              
            FldAuto              
      )                
                
                
set transaction isolation level read uncommitted                
      Delete                 
            Deltrans_Report                
      From                 
            #DoNotDelete_Deltrans DD,                 
            #FldAutoTable F                
      where                 
            Deltrans_Report.Sno = DD.SNO                
            and DD.FldAuto = F.FldAuto                
                
                                      
set transaction isolation level read uncommitted                
      Insert Into               
            Deltrans_Report                
      select                                       
            DD.SNo,                 
            Sett_No,                 
            Sett_type,                 
            RefNo,                 
            TCode,                 
   TrType,                 
            Party_Code,                 
            scrip_cd,                 
            series,                 
            Qty,                 
            FromNo,                                       
            ToNo,                       
            CertNo,                 
            FolioNo,                 
            HolderName,                 
            Reason,                 
            DrCr,                 
            Delivered,                 
            OrgQty,                 
            DpType,                 
            DpId,                 
            CltDpId,                                       
            BranchCd,                 
            PartipantCode,                 
            SlipNo,                 
            BatchNo,                 
            ISett_No,                 
            ISett_Type,                 
            ShareType,                       
            TransDate,                 
            Filler1,                                       
            Filler2,                 
            Filler3,                 
            BDpType,                 
            BDpId,                 
            BCltDpId,                 
            Filler4,                 
            Filler5                             
      from                 
            #DoNotDelete_Deltrans DD,                 
            #FldAutoTable F                          
      Where                 
            DD.FldAuto = F.FldAuto                
                
                
                
set transaction isolation level read uncommitted                
      Delete                 
            Deltrans_Report                
      From                 
            #DoNotDelete_Deltrans DD                
      where                 
            Deltrans_Report.Sno = DD.SNO                
            and DD.ActionFlag = 'D'                
                
                
Drop Table #FldAutoTable                
Drop Table #DoNotDelete_Deltrans                
                                      
                
set transaction isolation level read uncommitted                                  
      delete from               
            donotdelete_Deltrans                                      
      where               
            fldauto <= @InslastNo                                      
                                                    
      update                 
            tblglobalparams                                      
      set                 
            fldlastins = @InslastNo  
      where                 
            isnull(@InsLastNo,0) <> 0                                      
                                                              
                                      
      update                 
            tblglobalparams                
      set                 
            fldupdtdate = getdate()

GO
