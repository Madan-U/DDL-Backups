-- Object: PROCEDURE dbo.Ins_Delpayoutcsv
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE Ins_Delpayoutcsv 
(
@RMNO varchar (20), 
@PARTY_CODE varchar (10), 
@SCRIP_CD varchar (12), 
@CERTNO varchar (12), 
@SETT_NO varchar (7), 
@SETT_TYPE varchar (2), 
@QTY int , 
@BDPTYPE varchar (4), 
@BDPID varchar (8), 
@BCLTDPID varchar (16), 
@DPTYPE varchar (4), 
@DPID varchar (8), 
@CLTDPID varchar (16)
)
As

declare @procname varchar(50)
select @procname = object_name(@@procid)

begin transaction trnInsans

	begin
		INSERT INTO dbo.Delpayoutcsv 
		(
		RMNO,
		PARTY_CODE,
		SCRIP_CD,
		CERTNO,
		SETT_NO,
		SETT_TYPE,
		QTY,
		BDPTYPE,
		BDPID,
		BCLTDPID,
		DPTYPE,
		DPID,
		CLTDPID,
		UPLOADDATE,
		PROCESSEDFLAG,
		PROCESSEDDATE
		 )
		 VALUES 
		(
		@RMNO,
		@PARTY_CODE,
		@SCRIP_CD,
		@CERTNO,
		@SETT_NO,
		@SETT_TYPE,
		@QTY,
		@BDPTYPE,
		@BDPID,
		@BCLTDPID,
		@DPTYPE,
		@DPID,
		@CLTDPID,
		GETDATE(),
		0,
		''
		)
	if @@error != 0
    begin
       rollback transaction trnInsans
       raiserror('Error inserting into table DematTrans.  Error occurred in procedure %s.  Rolling back transaction...', 16, 1, @procname)
       return
    end
    else
		begin
			commit transaction trnInsans
		end
    end

GO
