-- Object: PROCEDURE dbo.V3_PROC_DELTRANS_CLEANUP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc V3_PROC_DELTRANS_CLEANUP
(
@strExchange VARCHAR(3),
@strSegment VARCHAR(7),
@SYSTEMUSER VARCHAR(20),
@Client_localIP varchar(20),
@SettNo varchar(7)
)
as
-------------------------------------------------------------------------------------
-- INSTRUCTIONS
-- REPLACE @SETTNO with the settlement Number upto which you want to cleanup the table
-- Run STEP 1 to STEP 26 one by one
-------------------------------------------------------------------------------------
Declare @@TabCount int
Declare @@MinSettNo  varchar(7)
Declare @@MaxSettNo varchar(7)
Declare @@MyString varchar(1000)



Select @@MinSettNo=Min(Sett_No), @@MaxSettNo=Max(Sett_No) from Deltrans (NoLock) where Sett_no <= (select max(sett_no) from sett_mst (nolock) Where start_Date <= getdate()-10)

if len(@@MaxSettNo) = 7 
begin
	set @SettNo = @@MaxSettNo
end
    

Insert into V2_WorkingDays (Exchange, Segment, WorkingDays, ProcessName, [FileName], ProcessParams, ProcessDate, ProcessBy, MachineIP) 
values 
(@strExchange ,  @strSegment , getdate() , 'DELTRANS CLEANUP' , 'Initiated' , '' , getdate(), @SYSTEMUSER , @Client_localIP)
   
Set @@MyString = 'From ' + @@MinSettNo + ' - To ' + @SettNo

Insert into V2_WorkingDays (Exchange, Segment, WorkingDays, ProcessName, [FileName], ProcessParams, ProcessDate, ProcessBy, MachineIP) 
values 
(@strExchange ,  @strSegment , getdate() , 'DELTRANS CLEANUP' , 'Process Started' , @@MyString , getdate(), @SYSTEMUSER , @Client_localIP)  

-------------------------------------------------------------------------------------
-- STEP 1
-------------------------------------------------------------------------------------


				EXEC SP_RENAME  'Deltrans',	'V2_Deltrans_Deletion_Work'

-------------------------------------------------------------------------------------
-- STEP 2
-------------------------------------------------------------------------------------

				EXEC SP_RENAME  'DeliveryClt' ,'V2_DeliveryClt_Deletion_Work'
				

Insert Into V2_Deltrans_Delete_Log values ('D10', getdate(), @SYSTEMUSER, @CLIENT_LOCALIP, @SETTNO)

Insert into V2_WorkingDays (Exchange, Segment, WorkingDays, ProcessName, [FileName], ProcessParams, ProcessDate, ProcessBy, MachineIP) 
values 
(@strExchange ,  @strSegment , getdate() , 'DELTRANS CLEANUP' , 'Process D10 Completed' , @@MyString , getdate(), @SYSTEMUSER , @Client_localIP)  


-------------------------------------------------------------------------------------
-- STEP 3
-------------------------------------------------------------------------------------

				IF EXISTS (SELECT *
						   FROM   DBO.SYSOBJECTS
						   WHERE  ID = OBJECT_ID(N'[dbo].[Deltrans_New_Delete]')
								  AND OBJECTPROPERTY(ID,N'IsTrigger') = 1)
				  DROP TRIGGER [DBO].[DELTRANS_NEW_DELETE] 

-------------------------------------------------------------------------------------
-- STEP 4
-------------------------------------------------------------------------------------
				
				IF EXISTS (SELECT *
						   FROM   DBO.SYSOBJECTS
						   WHERE  ID = OBJECT_ID(N'[dbo].[Deltrans_New_Insert]')
								  AND OBJECTPROPERTY(ID,N'IsTrigger') = 1)
				  DROP TRIGGER [DBO].[DELTRANS_NEW_INSERT] 

-------------------------------------------------------------------------------------
-- STEP 5
-------------------------------------------------------------------------------------
				
				IF EXISTS (SELECT *
						   FROM   DBO.SYSOBJECTS
						   WHERE  ID = OBJECT_ID(N'[dbo].[Deltrans_New_Update]')
								  AND OBJECTPROPERTY(ID,N'IsTrigger') = 1)
				  DROP TRIGGER [DBO].[DELTRANS_NEW_UPDATE] 

-------------------------------------------------------------------------------------
-- STEP 6
-------------------------------------------------------------------------------------

				IF EXISTS (SELECT *
						   FROM   DBO.SYSINDEXES
						   WHERE  NAME = N'DELHOLD'
								  AND ID = OBJECT_ID(N'[dbo].[V2_Deltrans_Deletion_Work]'))
				  DROP INDEX [DBO].[V2_DELTRANS_DELETION_WORK].[DELHOLD] 

-------------------------------------------------------------------------------------
-- STEP 7
-------------------------------------------------------------------------------------

				IF EXISTS (SELECT *
						   FROM   DBO.SYSINDEXES
						   WHERE  NAME = N'DELHOLDISett'
								  AND ID = OBJECT_ID(N'[dbo].[V2_Deltrans_Deletion_Work]'))
				  DROP INDEX [DBO].[V2_DELTRANS_DELETION_WORK].[DELHOLDISETT] 

-------------------------------------------------------------------------------------
-- STEP 8
-------------------------------------------------------------------------------------

				IF EXISTS (SELECT *
						   FROM   DBO.SYSINDEXES
						   WHERE  NAME = N'SNoIdx'
								  AND ID = OBJECT_ID(N'[dbo].[V2_Deltrans_Deletion_Work]'))
				  DROP INDEX [DBO].[V2_DELTRANS_DELETION_WORK].[SNOIDX] 

-------------------------------------------------------------------------------------
-- STEP 9
-------------------------------------------------------------------------------------
				
				CREATE INDEX F2 ON V2_DELTRANS_DELETION_WORK (FILLER2 DESC)

-------------------------------------------------------------------------------------
-- STEP 10
-------------------------------------------------------------------------------------
				
				DELETE FROM V2_DELIVERYCLT_DELETION_WORK
				WHERE       SETT_NO <= @SettNo

-------------------------------------------------------------------------------------
-- STEP 11
-------------------------------------------------------------------------------------
				
				EXEC SP_RENAME  'V2_DeliveryClt_Deletion_Work' , 'DeliveryClt'

Insert into V2_WorkingDays (Exchange, Segment, WorkingDays, ProcessName, [FileName], ProcessParams, ProcessDate, ProcessBy, MachineIP) 
values 
(@strExchange ,  @strSegment , getdate() , 'DELTRANS CLEANUP' , 'Process D20 Completed' , @@MyString , getdate(), @SYSTEMUSER , @Client_localIP)  

				
-------------------------------------------------------------------------------------
-- STEP 12
-------------------------------------------------------------------------------------

				DELETE FROM V2_DELTRANS_DELETION_WORK
				WHERE       FILLER2 = 0

Insert into V2_WorkingDays (Exchange, Segment, WorkingDays, ProcessName, [FileName], ProcessParams, ProcessDate, ProcessBy, MachineIP) 
values 
(@strExchange ,  @strSegment , getdate() , 'DELTRANS CLEANUP' , 'Process D30 Completed' , @@MyString , getdate(), @SYSTEMUSER , @Client_localIP)  

-------------------------------------------------------------------------------------
-- STEP 13
-------------------------------------------------------------------------------------

				DROP INDEX V2_DELTRANS_DELETION_WORK.F2 

-------------------------------------------------------------------------------------
-- STEP 14
-------------------------------------------------------------------------------------

				CREATE INDEX F2 ON V2_DELTRANS_DELETION_WORK (DRCR, DELIVERED, SETT_NO)

-------------------------------------------------------------------------------------
-- STEP 15
-------------------------------------------------------------------------------------

				DELETE FROM V2_DELTRANS_DELETION_WORK
				WHERE       DRCR = 'C'
							AND SETT_NO <= @SettNo

Insert into V2_WorkingDays (Exchange, Segment, WorkingDays, ProcessName, [FileName], ProcessParams, ProcessDate, ProcessBy, MachineIP) 
values 
(@strExchange ,  @strSegment , getdate() , 'DELTRANS CLEANUP' , 'Process D40 Completed' , @@MyString , getdate(), @SYSTEMUSER , @Client_localIP)  

-------------------------------------------------------------------------------------
-- STEP 16
-------------------------------------------------------------------------------------

				DELETE FROM V2_DELTRANS_DELETION_WORK
				WHERE       DRCR = 'D'
							AND DELIVERED = 'D'
							AND SETT_NO <= @SettNo

-------------------------------------------------------------------------------------
-- STEP 17
-------------------------------------------------------------------------------------

				DROP INDEX V2_DELTRANS_DELETION_WORK.F2 

Insert into V2_WorkingDays (Exchange, Segment, WorkingDays, ProcessName, [FileName], ProcessParams, ProcessDate, ProcessBy, MachineIP) 
values 
(@strExchange ,  @strSegment , getdate() , 'DELTRANS CLEANUP' , 'Process D50 Completed' , @@MyString , getdate(), @SYSTEMUSER , @Client_localIP)  

-------------------------------------------------------------------------------------
-- STEP 18
-------------------------------------------------------------------------------------

				CREATE CLUSTERED INDEX [ADELHOLD] ON [DBO].[V2_DELTRANS_DELETION_WORK] ([SETT_NO], [SETT_TYPE], [PARTY_CODE], [SCRIP_CD], [SERIES], [CERTNO], [TRTYPE], [FILLER2], [DRCR], [BDPTYPE], [BDPID], [BCLTDPID]) ON [PRIMARY]

-------------------------------------------------------------------------------------
-- STEP 19
-------------------------------------------------------------------------------------

				DROP INDEX V2_DELTRANS_DELETION_WORK.ADELHOLD 

-------------------------------------------------------------------------------------
-- STEP 20
-------------------------------------------------------------------------------------

				CREATE INDEX [DELHOLD] ON [DBO].[V2_DELTRANS_DELETION_WORK] ([SETT_NO], [SETT_TYPE], [PARTY_CODE], [SCRIP_CD], [SERIES], [CERTNO], [TRTYPE], [FILLER2], [DRCR], [BDPTYPE], [BDPID], [BCLTDPID]) ON [PRIMARY]
				
-------------------------------------------------------------------------------------
-- STEP 21
-------------------------------------------------------------------------------------

				CREATE INDEX [DELHOLDISETT] ON [DBO].[V2_DELTRANS_DELETION_WORK] ([ISETT_NO], [ISETT_TYPE], [PARTY_CODE], [SCRIP_CD], [SERIES], [CERTNO], [TRTYPE], [FILLER2], [DRCR], [BDPTYPE], [BDPID], [BCLTDPID]) ON [PRIMARY]
				
-------------------------------------------------------------------------------------
-- STEP 22
-------------------------------------------------------------------------------------

				CREATE INDEX [SNOIDX] ON [DBO].[V2_DELTRANS_DELETION_WORK] ([SNO]) ON [PRIMARY]
				
-------------------------------------------------------------------------------------
-- STEP 23
-------------------------------------------------------------------------------------
				    
				EXEC sp_rename 'V2_Deltrans_Deletion_Work', 'Deltrans'


Insert into V2_WorkingDays (Exchange, Segment, WorkingDays, ProcessName, [FileName], ProcessParams, ProcessDate, ProcessBy, MachineIP) 
values 
(@strExchange ,  @strSegment , getdate() , 'DELTRANS CLEANUP' , 'Process D60 Completed' , @@MyString , getdate(), @SYSTEMUSER , @Client_localIP)

GO
