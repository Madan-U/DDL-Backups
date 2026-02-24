-- Object: PROCEDURE dbo.CBO_GETSETTLMENT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




--where party_code like  @party_code +'%'

--Select Party_Code,Scrip_Cd,TransNo,Qty,DpId,CltAccno,SNo From DematTrans Where  Sett_No = '2005538' And Sett_Type = 'D' And Scrip_Cd Like '%' And Party_Code Like '%' And TrType <> 906-- And IsIn In (Select IsIn From MultiIsIn Where Scrip_Cd = DematTrans.Scrip_Cd And Valid = 1 And Series = DematTrans.Series And IsIn = DematTrans.IsIn) Order By Party_Code,Scrip_Cd,TransNo,Qty,DpId,CltAccno


--Select Distinct Party_Code from DematTrans where sett_no = '2005538' and sett_Type = 'D'  And Scrip_cd = 'ALBK' And TrType <> 906 Order By Party_Code 
--Select Distinct Scrip_Cd from DematTrans where sett_no = '2005538' and sett_Type = 'N' And TrType <> 906
--Sql = Sql + " and RefNo = " & RefNo & " Order By Scrip_Cd "


--insert into DematTrans (Sett_No,Sett_Type,Refno,Tcode,Trtype, Party_Code,Scrip_Cd,Qty,Series,Trdate,Cltaccno,Dpid,Dpname,Isin,Branch_Cd,Partipantcode,Dptype,Transno,Drcr,Bdptype,Bdpid,Bcltaccno,Filler1,Filler2,Filler3,Filler4,Filler5 )
--values('2005538','N','110','241593','904','0A143','ALBK','300','EQ','2005-03-24','241593','IN300853','PPP','88','222','222',' Demat','23','3','23','1','55','NSDL','1127','15615750','1900-01-01','0')                            
--select * from DematTrans
--EXEC CBO_GETSETTLMENT 'P','2005538','D','ALBK','BROKER','BROKER'

CREATE                            PROCEDURE [dbo].[CBO_GETSETTLMENT]
	@FLAG   VARCHAR(1),
        @SETNO VARCHAR(10),
        @SETTYPE VARCHAR(10),
        @SCRIPCODE VARCHAR(10),
        @STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
AS
DECLARE
		@SQL Varchar(2000)
		
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	IF @FLAG <> 'N' AND @FLAG <> 'T' AND @FLAG <> 'S' AND @FLAG <> 'P'
		BEGIN
			RAISERROR ('Add/Edit Flags Not Set Properly', 16, 1)
			RETURN
		END
        
	 IF @FLAG = 'N'
		BEGIN
			Select Distinct Sett_No From  bsedb.dbo.DematTrans --where RefNo = 110 And TrType <> 906  Order By Sett_No 
		END

	ELSE IF @FLAG = 'T'
       Select Distinct Sett_Type from  bsedb.dbo.DematTrans where sett_no = @SETNO-- And RefNo = '110' And TrType <> 906 Order By Sett_Type
    ELSE IF @FLAG = 'S'
		 Select Distinct Scrip_Cd from bsedb.dbo.DematTrans where sett_no = @SETNO and sett_Type = @SETTYPE --And TrType <> 906 
     ELSE IF @FLAG = 'P'
 		Select Distinct Party_Code from  bsedb.dbo.DematTrans where sett_no = @SETNO and sett_Type = @SETTYPE And Scrip_cd = @SCRIPCODE --And TrType <> 906 Order By Party_Code

GO
