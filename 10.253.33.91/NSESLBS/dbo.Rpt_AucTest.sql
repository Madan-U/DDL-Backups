-- Object: PROCEDURE dbo.Rpt_AucTest
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE Rpt_AucTest
@ReportId Int,                     -- Not Used 
@ReportSection Varchar(3)

AS

/* This is used Detail section */
If @ReportSection = 'D'
Begin
	SELECT  
	 PARTY_CODE,  
	 LONG_NAME,  
	 NSESCRIP_CD,  
	 BSESCRIP_CD,  
	 SCRIPNAME,  
	 NSEPOOL,  
	 BSEPOOL,  
	 MPAY,  
	 NPAY,  
	 MSHRT,  
	 NSHRT,  
	 NSEHOLD,  
	 BSEHOLD,  
	 NSEMARG,  
	 BSEMARG,  
	 NFOMARG,  
	 MTFHOLD,  
	 POAHOLD,  
	 TOTALHOLD,  
	 CL_RATE,  
	 HOLDAMT,  
	 BRANCH_CD,  
	 SUB_BROKER,  
	 TRADER,  
	 AREA,  
	 REGION,  
	 FAMILY,  
	 CLIENT_CTGRY,  
	 DEBITFLAG,  
	 CERTNO,  
	 RUNDATE  
	FROM  
	 TBL_CONSTOCKREPORT  
 	ORDER BY BRANCH_CD, SUB_BROKER, PARTY_CODE
End

ELSE 
Begin
	Select @ReportSection  from  OWNER where 1 = 2
End

GO
