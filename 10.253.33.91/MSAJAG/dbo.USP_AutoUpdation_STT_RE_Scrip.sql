-- Object: PROCEDURE dbo.USP_AutoUpdation_STT_RE_Scrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--EXEC  DBO.USP_AutoUpdation_STT_RE_Scrip @SCRIP_CD_NSE ='' ,@SCRIP_CD_BSE ='' , @SERIES   ='',  @FromDT   ='2022-09-12' , @ChargeFlag =2

CREATE PROCEDURE [dbo].[USP_AutoUpdation_STT_RE_Scrip] 
(
  @SCRIP_CD_NSE VARCHAR(10),
  @SCRIP_CD_BSE VARCHAR(10),
  @SERIES   VARCHAR(3),
  @FromDT   DATE ,
  @ChargeFlag INT
)
AS
BEGIN

--- 201
--DECLARE @SCRIP_CD VARCHAR(10)
--DECLARE @SERIES  VARCHAR(3)
--Declare @FromDT   DATE
Declare @TODate   DATE 
SET @TODate ='2049-12-31'
-- BSE Server
IF EXISTS (Select top 1 * From [AngelBSECM].BSEDB_AB.DBO.TBL_STT_SCRIP WHERE SCRIP_CD=@SCRIP_CD_BSE AND SERIES =@SERIES)
BEGIN
Select 'Records Already Exists' [Validation]
END
ELSE BEGIN
INSERT INTO [AngelBSECM].BSEDB_AB.DBO.TBL_STT_SCRIP 
      (
            SCRIP_CD,DATEFROM,DATETO,ADDEDBY,ADDEDON,MODIFIEDBY,MODIFIEDON,
            SERIES,CHARGE_FLAG
      )
  VALUES (@SCRIP_CD_BSE, @FromDT, @TODate, 'E74347', Getdate(), '', '', 
                         CASE WHEN @SERIES ='BE' THEN 'BSE' ELSE @SERIES END, @ChargeFlag)
 
 Select ' Records Successfully Added ' [Validation]
END
--  196 Server NSE Server 
IF EXISTS (Select top 1 * From MSAJAG.DBO.TBL_STT_SCRIP WHERE SCRIP_CD=@SCRIP_CD_NSE AND SERIES =@SERIES )
BEGIN
Select 'Records Already Exists' [Validation]
END
ELSE
BEGIN
Insert into MSAJAG.DBO.TBL_STT_SCRIP
(
      SCRIP_CD,DATEFROM,DATETO,ADDEDBY,ADDEDON,MODIFIEDBY,MODIFIEDON,
      SERIES,CHARGE_FLAG
)
VALUES (@SCRIP_CD_NSE, @FromDT, @TODate, 'E74347', Getdate(), '', '', 
                                             'BE', @ChargeFlag)

											 
Insert into MSAJAG.DBO.TBL_STT_SCRIP
(
      SCRIP_CD,DATEFROM,DATETO,ADDEDBY,ADDEDON,MODIFIEDBY,MODIFIEDON,
      SERIES,CHARGE_FLAG
)
VALUES (@SCRIP_CD_NSE, @FromDT, @TODate, 'E74347', Getdate(), '', '', 
                                             'BL', @ChargeFlag)


Select ' Records Successfully Added ' [Validation]
END

END

GO
