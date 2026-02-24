-- Object: PROCEDURE dbo.V2_Deltrans_Archive_Restore
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*
alter table Deltrans_Report_Jrnl
add 	[UpdateBy] [varchar] (50) NULL 

alter table Deltrans_Report_Jrnl
add 	[UpdateBy] [varchar] (50) NULL


alter table Deltrans_Report_Jrnl
add 	[UpdateProcess] [Varchar] (100) NULL


alter table Deltrans_Report_Jrnl
add 	[UpdateIP] [varchar] (15) NULL 
*/

create Proc V2_Deltrans_Archive_Restore        
          
(          
@party_code varchar(10),          
@scrip_cd varchar(12),          
@sett_no varchar(7),          
@slipno numeric,
@UpdateBy varchar(50),
@UpdateIP varchar(15)
)          
          
          
          
as          
          
Declare @@CountRec bigint          
Declare @@UpdtCount Int    
          
SET @@COUNTREC = 0          
          
          
set transaction isolation level read uncommitted          
select @@CountRec = Count(1) from deltrans (nolock)          
where party_code = @party_Code          
and scrip_cd = @scrip_cd          
and sett_no = @sett_no          
and slipno = isnull(@slipno,0)          
          
if @@CountRec = 0          
begin          
          
 set transaction isolation level read uncommitted          
 select * Into #Deltrans_Report from deltrans_report (nolock)          
 where party_code = @party_Code          
 and scrip_cd = @scrip_cd          
 and sett_no = @sett_no          
 and slipno = isnull(@slipno,0)          
           
 SELECT @@COUNTREC = COUNT(1) FROM #DELTRANS_REPORT          
 WHERE DRCR = 'D'          
 AND DELIVERED = 'D'          
 AND FILLER2 = 1          
 AND TRTYPE IN (904,905)  
          
 IF @@COUNTREC > 0          
 BEGIN          
    
  Set @@UpdtCount = 0    
          
  Insert Into Deltrans_Report_Jrnl          
  select *, GETDATE(), @UpdateBy, 'Restore - Closed Record of a Slip No', @UpdateIP from #deltrans_report           
            
  insert into Deltrans          
  select          
   Sett_No,          
   Sett_type,          
   RefNo,          
   TCode,          
   TrType=904,          
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
   DrCr='D',          
   Delivered='0',          
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
  From #Deltrans_Report          
  WHERE DELIVERED = 'D'          
  AND DRCR = 'D'          
  AND FILLER2 = 1          
            
  Delete Deltrans_Report          
  From #Deltrans_Report D          
  where deltrans_report.sno = d.sno          
            
  Select @@UpdtCount = count(1) from #Deltrans_Report          
  WHERE DELIVERED = 'D'          
  AND DRCR = 'D'          
  AND FILLER2 = 1          
          
  Drop Table #Deltrans_Report          
          
  Select 'Y' + '|' + cast(@@UpdtCount as Varchar) + '|' + 'Successfully Restored'        
          
          
          
 END          
 ELSE          
 BEGIN          
        
  Drop Table #Deltrans_Report          
  Select 'N|0|No Actions Performed, No records found for given Criteria'        
 END          
          
End          
Else          
Begin          
          
  Select 'N|0|Transaction Failed due to Records present already in Transaction Table'         
End

GO
