-- Object: PROCEDURE dbo.InsertDematSpeed
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




/****** Object:  Stored Procedure dbo.InsertDematSpeed    Script Date: 12/16/2003 2:31:19 PM ******/

CREATE procedure InsertDematSpeed 

       @Sett_No                  varchar(7)          ,         
       @Sett_Type                varchar(2)          ,         
       @RefNo                    int                 ,         
       @TCode                    numeric(18,0)       ,         
       @TrType                   numeric(18,0)       ,         
       @Party_Code               varchar(10)         ,         
       @Scrip_Cd                 varchar(12)         = null,   
       @Series                   varchar(3)          = null,   
       @Qty                      numeric(18,0)       ,         
       @TrDate                   datetime            ,         
       @CltAccNo                 varchar(16)         = null,   
       @DpId                     varchar(16)         = null,   
       @DpName                   varchar(50)         = null,   
       @IsIn                     varchar(12)         = null,   
       @Branch_Cd                varchar(10)         = null,   
       @PartiPantCode            varchar(10)         = null,   
       @DpType                 varchar(4)         = null,   
       @TransNo                varchar(15)         ,         
       @DrCr                       varchar(1)    ,
       @BDpType               varchar(4)         = null,   
       @BDpId                     varchar(16)         = null,   
       @BCltAccNo             varchar(50)         = null,
       @Filler1		varchar(100),       
       @Filler2		Int,
       @Filler3		Int,
       @Filler4		Int,
       @Filler5		Int

as

       declare @procname varchar(50)
       select @procname = object_name(@@procid)

       begin transaction trnInsans

              begin
                     insert into DematTransSpeed(
                                          Sett_No,
                                          Sett_Type,
                                          RefNo,
                                          TCode,
                                          TrType,
                                          Party_Code,
                                          Scrip_Cd,
                                          Series,
                                          Qty,
                                          TrDate,
                                          CltAccNo,
                                          DpId,
                                          DpName,
                                          IsIn,
                                          Branch_Cd,
                                          PartiPantCode,
                                          DpType,
                                          TransNo,
                                          DrCr,
		             BDpType,               
		             BDpId,
       		             BCltAccNo,
		             Filler1,         
		             Filler2,
                                          Filler3,
                                          Filler4,
		             Filler5
                                          )
                     select
                                          @Sett_No,
                                          @Sett_Type,
                                          @RefNo,
                                          @TCode,
                                          @TrType,
                                          @Party_Code,
                                          @Scrip_Cd,
                                          @Series,
                                          @Qty,
                                          @TrDate,
                                          @CltAccNo,
                                          @DpId,
                                          @DpName,
                                          @IsIn,
                                          @Branch_Cd,
                                          @PartiPantCode,
                                          @DpType,
                                          @TransNo,
                                          @DrCr,
		             @BDpType,               
		             @BDpId,
       		             @BCltAccNo,
		             @Filler1,         
		             @Filler2,
                                          @Filler3,
                                          @Filler4,
		             @Filler5

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
